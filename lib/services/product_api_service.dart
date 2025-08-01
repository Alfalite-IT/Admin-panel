import 'dart:convert';
import 'package:admin_panel/services/api_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';
import 'auth_service.dart';

class ProductApiService {
  final String _baseUrl = 'http://localhost:8080';
  late final Client _client;

  ProductApiService(AuthService authService) {
    _client = InterceptedClient.build(interceptors: [
      ApiInterceptor(authService),
    ]);
  }

  Future<List<Product>> fetchProducts() async {
    final response = await _client.get(Uri.parse('$_baseUrl/products'));
    if (response.statusCode == 200) {
      final List<dynamic> productJson = json.decode(response.body);
      return productJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> createProduct(Product product) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/products'),
      body: json.encode(product.toJson()),
    );
    if (response.statusCode == 201) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create product.');
    }
  }

  Future<Product> updateProduct(Product product) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/products/${product.id}'),
      body: json.encode(product.toJson()),
    );
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update product.');
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await _client.delete(
      Uri.parse('$_baseUrl/products/$id'),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete product.');
    }
  }

  Future<String> uploadImage(XFile imageFile) async {
    final uri = Uri.parse('$_baseUrl/upload/image');
    final request = MultipartRequest('POST', uri);

    final bytes = await imageFile.readAsBytes();
    final mimeType = imageFile.mimeType;

    request.files.add(MultipartFile.fromBytes(
      'image',
      bytes,
      filename: imageFile.name,
      contentType: mimeType != null ? MediaType.parse(mimeType) : null,
    ));

    final response = await _client.send(request);
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final decoded = json.decode(responseBody);
      return decoded['imageUrl'];
    } else {
      throw Exception(
          'Failed to upload image. Status: ${response.statusCode}, Body: $responseBody');
    }
  }
} 