import 'dart:convert';

/// evd model
class EvdPin {
  final int brandId;
  final String brandName;
  final double pinValue;
  final int stock;

  EvdPin({
    this.brandId,
    this.brandName,
    this.pinValue,
    this.stock,
  });

  Map<String, dynamic> toMap() {
    return {
      'BrandId': brandId,
      'BrandName': brandName,
      'PinValue': pinValue,
      'Stock': stock,
    };
  }

  factory EvdPin.fromMap(Map<String, dynamic> map) {
    return EvdPin(
      brandId: map['BrandId'] ?? 0,
      brandName: map['BrandName'] ?? '',
      pinValue: map['PinValue'] ?? 0.0,
      stock: map['Stock'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'EvdPin(brandId: $brandId, brandName: $brandName, pinValue: $pinValue, stock: $stock)';
  }
}
