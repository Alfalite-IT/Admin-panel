import 'dart:io';
import 'package:admin_panel/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';
import '../services/product_api_service.dart';
import '../services/unauthorized_exception.dart';

class ProductEditDialog extends StatefulWidget {
  final Product? product;
  final ProductApiService apiService;

  const ProductEditDialog(
      {super.key, this.product, required this.apiService});

  @override
  ProductEditDialogState createState() => ProductEditDialogState();
}

class ProductEditDialogState extends State<ProductEditDialog> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  late Product _product;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _product = widget.product ?? Product.empty();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    form.save();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          const Center(child: CircularProgressIndicator()),
    );

    try {
      String? imageUrl = _product.image;
      if (_imageFile != null) {
        imageUrl = await widget.apiService.uploadImage(_imageFile!);
      }
      _product = _product.copyWith(image: imageUrl);

      if (widget.product == null) {
        await widget.apiService.createProduct(_product);
      } else {
        await widget.apiService.updateProduct(_product);
      }

      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading
      Navigator.of(context).pop(true); // Close dialog
    } on UnauthorizedException {
      // Interceptor handles logout, AuthWrapper will navigate. Do nothing.
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save product: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formFields = [
      _buildTextFormField(
        initialValue: _product.name,
        labelText: 'Name',
        onSaved: (value) => _product = _product.copyWith(name: value),
      ),
      _buildTextFormField(
        initialValue: _product.location.join(', '),
        labelText: 'Location (comma-separated)',
        onSaved: (value) => _product = _product.copyWith(
            location: value?.split(',').map((e) => e.trim()).toList()),
      ),
      _buildTextFormField(
        initialValue: _product.application.join(', '),
        labelText: 'Application (comma-separated)',
        onSaved: (value) => _product = _product.copyWith(
            application: value?.split(',').map((e) => e.trim()).toList()),
      ),
      _buildTextFormField(
        initialValue: widget.product == null ? '' : _product.horizontal.toString(),
        labelText: 'Horizontal Resolution',
        keyboardType: TextInputType.number,
        onSaved: (value) => _product =
            _product.copyWith(horizontal: int.tryParse(value ?? '') ?? 0),
      ),
      _buildTextFormField(
        initialValue: widget.product == null ? '' : _product.vertical.toString(),
        labelText: 'Vertical Resolution',
        keyboardType: TextInputType.number,
        onSaved: (value) => _product =
            _product.copyWith(vertical: int.tryParse(value ?? '') ?? 0),
      ),
      _buildTextFormField(
        initialValue: widget.product == null ? '' : _product.pixelPitch.toString(),
        labelText: 'Pixel Pitch',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onSaved: (value) => _product =
            _product.copyWith(pixelPitch: double.tryParse(value ?? '') ?? 0.0),
      ),
      _buildTextFormField(
        initialValue: widget.product == null ? '' : _product.width.toString(),
        labelText: 'Width (mm)',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onSaved: (value) => _product =
            _product.copyWith(width: double.tryParse(value ?? '') ?? 0.0),
      ),
      _buildTextFormField(
        initialValue: widget.product == null ? '' : _product.height.toString(),
        labelText: 'Height (mm)',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onSaved: (value) => _product =
            _product.copyWith(height: double.tryParse(value ?? '') ?? 0.0),
      ),
      _buildTextFormField(
        initialValue: widget.product == null ? '' : _product.depth.toString(),
        labelText: 'Depth (mm)',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onSaved: (value) => _product =
            _product.copyWith(depth: double.tryParse(value ?? '') ?? 0.0),
      ),
      _buildTextFormField(
        initialValue: widget.product == null ? '' : _product.consumption.toString(),
        labelText: 'Consumption (W)',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onSaved: (value) => _product =
            _product.copyWith(consumption: double.tryParse(value ?? '') ?? 0.0),
      ),
      _buildTextFormField(
        initialValue: widget.product == null ? '' : _product.weight.toString(),
        labelText: 'Weight (kg)',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onSaved: (value) => _product =
            _product.copyWith(weight: double.tryParse(value ?? '') ?? 0.0),
      ),
      _buildTextFormField(
        initialValue: widget.product == null ? '' : _product.brightness.toString(),
        labelText: 'Brightness (nits)',
        keyboardType: TextInputType.number,
        onSaved: (value) => _product =
            _product.copyWith(brightness: int.tryParse(value ?? '') ?? 0),
      ),
      _buildTextFormField(
        initialValue: _product.refreshRate?.toString(),
        labelText: 'Refresh Rate (Hz)',
        keyboardType: TextInputType.number,
        isOptional: true,
        onSaved: (value) =>
            _product = _product.copyWith(refreshRate: double.tryParse(value ?? '')),
      ),
      _buildTextFormField(
        initialValue: _product.contrast,
        labelText: 'Contrast',
        isOptional: true,
        onSaved: (value) => _product = _product.copyWith(contrast: value),
      ),
      _buildTextFormField(
        initialValue: _product.visionAngle,
        labelText: 'Vision Angle',
        isOptional: true,
        onSaved: (value) => _product = _product.copyWith(visionAngle: value),
      ),
      _buildTextFormField(
        initialValue: _product.redundancy,
        labelText: 'Redundancy',
        isOptional: true,
        onSaved: (value) => _product = _product.copyWith(redundancy: value),
      ),
      _buildTextFormField(
        initialValue: _product.curvedVersion,
        labelText: 'Curved Version',
        isOptional: true,
        onSaved: (value) => _product = _product.copyWith(curvedVersion: value),
      ),
      _buildTextFormField(
        initialValue: _product.opticalMultilayerInjection,
        labelText: 'Optical Multilayer Injection',
        isOptional: true,
        onSaved: (value) => _product =
            _product.copyWith(opticalMultilayerInjection: value),
      ),
    ];

    return AlertDialog(
      title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 800,
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildImagePreview(),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 5.5,
                    children: formFields,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    ImageProvider? imageProvider;
    if (_imageFile != null) {
      imageProvider = FileImage(File(_imageFile!.path));
    } else if (_product.image != null && _product.image!.isNotEmpty) {
      imageProvider = NetworkImage('http://localhost:8080${_product.image}');
    }

    return Column(
      children: [
        Container(
          height: 150,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
            image: imageProvider != null
                ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                : null,
          ),
          child:
              imageProvider == null ? const Center(child: Text('No Image')) : null,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _pickImage,
          child: const Text('Select Image'),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    String? initialValue,
    required String labelText,
    required void Function(String?) onSaved,
    TextInputType? keyboardType,
    bool isOptional = false,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Color(0xFFF78400)),
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: (value) {
        if (!isOptional && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
} 