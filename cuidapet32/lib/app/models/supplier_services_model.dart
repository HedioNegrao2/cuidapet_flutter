import 'dart:convert';


class SupplierServicesModel {
  final int id;
  final int spupplierId;
  final String name;
  final double price;
  
  SupplierServicesModel({
    required this.id,
    required this.spupplierId,
    required this.name,
    required this.price,
  });

  

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'spupplier_id': spupplierId,
      'name': name,
      'price': price,
    };
  }

  factory SupplierServicesModel.fromMap(Map<String, dynamic> map) {
    return SupplierServicesModel(
      id: map['id']?.toInt() ?? 0,
      spupplierId: map['spupplier_id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SupplierServicesModel.fromJson(String source) => SupplierServicesModel.fromMap(json.decode(source));
}
