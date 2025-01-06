import 'dart:convert';

class AddressEntity {
  final int? id;
  final String address;
  final double lat;
  final double lng;
  final String additional;

  AddressEntity({
    this.id,
    required this.address,
    required this.lat,
    required this.lng,
    required this.additional,
  });


  AddressEntity copyWith({
    int? id,
    String? address,
    double? lat,
    double? lng,
    String? additional,
  }) {
    return AddressEntity(
      id: id ??  this.id,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      additional: additional ?? this.additional,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'lat': lat.toString(),
      'lng': lng.toString(),
      'additional': additional,
    };
  }

  factory AddressEntity.fromMap(Map<String, dynamic> map) {
    return AddressEntity(
      id: map['id']?.toInt(),
      address: map['address'] ?? '',
      lat: double.parse( map['lat'] ?? '0.0'),
      lng: double.parse(map['lng'] ?? '0.0'),
      additional: map['additional'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressEntity.fromJson(String source) => AddressEntity.fromMap(json.decode(source));
}
