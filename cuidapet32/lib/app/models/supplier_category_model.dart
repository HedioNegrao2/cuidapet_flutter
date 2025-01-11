import 'dart:convert';


class SupplierCategoryModel {
  int id;
  String name;
  String type;
  SupplierCategoryModel({
    required this.id,
    required this.name,
    required this.type,
  });

  


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }

  factory SupplierCategoryModel.fromMap(Map<String, dynamic> map) {
    return SupplierCategoryModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      type: map['type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SupplierCategoryModel.fromJson(String source) => SupplierCategoryModel.fromMap(json.decode(source));
}
