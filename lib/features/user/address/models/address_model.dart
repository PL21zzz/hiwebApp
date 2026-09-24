import 'dart:convert';

class AddressModel {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final String province;
  final String ward;
  final String streetAddress;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.province,
    required this.ward,
    required this.streetAddress,
    this.isDefault = false,
  });

  String get fullAddress {
    final parts = [streetAddress, ward, province].where((p) => p.trim().isNotEmpty);
    return parts.join(', ');
  }

  AddressModel copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? email,
    String? province,
    String? ward,
    String? streetAddress,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      province: province ?? this.province,
      ward: ward ?? this.ward,
      streetAddress: streetAddress ?? this.streetAddress,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'province': province,
      'ward': ward,
      'streetAddress': streetAddress,
      'isDefault': isDefault,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      province: map['province'] ?? '',
      ward: map['ward'] ?? '',
      streetAddress: map['streetAddress'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) => AddressModel.fromMap(json.decode(source));
}
