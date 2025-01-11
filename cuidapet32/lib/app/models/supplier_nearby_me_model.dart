import 'dart:convert';


class SupplierNearbyMeModel {
  final String id;
  final String name;
  final String logo;
  final double distance;
  final int category;
  SupplierNearbyMeModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.distance,
    required this.category,
  });  

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'distance': distance,
      'category': category,
    };
  }

  factory SupplierNearbyMeModel.fromMap(Map<String, dynamic> map) {
    return SupplierNearbyMeModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      logo: map['logo']?.toString() ?? '',
      distance: map['distance']?.toDouble() ?? 0.0,
      category: map['category']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SupplierNearbyMeModel.fromJson(String source) => SupplierNearbyMeModel.fromMap(json.decode(source));
}
