class Product {
  final int id;
  final String name;
  final List<String> location;
  final List<String> application;
  final int horizontal;
  final int vertical;
  final double pixelPitch;
  final double width;
  final double height;
  final double depth;
  final double consumption;
  final double weight;
  final int brightness;
  final String image;
  final double? refreshRate;
  final String? contrast;
  final String? visionAngle;
  final String? redundancy;
  final String? curvedVersion;
  final String? opticalMultilayerInjection;

  Product({
    required this.id,
    required this.name,
    required this.location,
    required this.application,
    required this.horizontal,
    required this.vertical,
    required this.pixelPitch,
    required this.width,
    required this.height,
    required this.depth,
    required this.consumption,
    required this.weight,
    required this.brightness,
    required this.image,
    this.refreshRate,
    this.contrast,
    this.visionAngle,
    this.redundancy,
    this.curvedVersion,
    this.opticalMultilayerInjection,
  });

  factory Product.empty() {
    return Product(
      id: 0,
      name: '',
      location: [],
      application: [],
      horizontal: 0,
      vertical: 0,
      pixelPitch: 0.0,
      width: 0.0,
      height: 0.0,
      depth: 0.0,
      consumption: 0.0,
      weight: 0.0,
      brightness: 0,
      image: '',
      refreshRate: null,
      contrast: null,
      visionAngle: null,
      redundancy: null,
      curvedVersion: null,
      opticalMultilayerInjection: null,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      location: List<String>.from(json['location']),
      application: List<String>.from(json['application']),
      horizontal: json['horizontal'],
      vertical: json['vertical'],
      pixelPitch: (json['pixelPitch'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      depth: (json['depth'] as num).toDouble(),
      consumption: (json['consumption'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      brightness: json['brightness'],
      image: json['image'],
      refreshRate: (json['refreshRate'] as num?)?.toDouble(),
      contrast: json['contrast'],
      visionAngle: json['visionAngle'],
      redundancy: json['redundancy'],
      curvedVersion: json['curvedVersion'],
      opticalMultilayerInjection: json['opticalMultilayerInjection'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'application': application,
      'horizontal': horizontal,
      'vertical': vertical,
      'pixelPitch': pixelPitch,
      'width': width,
      'height': height,
      'depth': depth,
      'consumption': consumption,
      'weight': weight,
      'brightness': brightness,
      'image': image,
      'refreshRate': refreshRate,
      'contrast': contrast,
      'visionAngle': visionAngle,
      'redundancy': redundancy,
      'curvedVersion': curvedVersion,
      'opticalMultilayerInjection': opticalMultilayerInjection,
    };
  }

  Product copyWith({
    int? id,
    String? name,
    List<String>? location,
    List<String>? application,
    int? horizontal,
    int? vertical,
    double? pixelPitch,
    double? width,
    double? height,
    double? depth,
    double? consumption,
    double? weight,
    int? brightness,
    String? image,
    double? refreshRate,
    String? contrast,
    String? visionAngle,
    String? redundancy,
    String? curvedVersion,
    String? opticalMultilayerInjection,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      application: application ?? this.application,
      horizontal: horizontal ?? this.horizontal,
      vertical: vertical ?? this.vertical,
      pixelPitch: pixelPitch ?? this.pixelPitch,
      width: width ?? this.width,
      height: height ?? this.height,
      depth: depth ?? this.depth,
      consumption: consumption ?? this.consumption,
      weight: weight ?? this.weight,
      brightness: brightness ?? this.brightness,
      image: image ?? this.image,
      refreshRate: refreshRate ?? this.refreshRate,
      contrast: contrast ?? this.contrast,
      visionAngle: visionAngle ?? this.visionAngle,
      redundancy: redundancy ?? this.redundancy,
      curvedVersion: curvedVersion ?? this.curvedVersion,
      opticalMultilayerInjection:
          opticalMultilayerInjection ?? this.opticalMultilayerInjection,
    );
  }
} 