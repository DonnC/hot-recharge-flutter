import 'dart:convert';

/// data bundle product model
class BundleProduct {
  final int bundleId;
  final int brandId;
  final String network;
  final String productCode;
  final int amount;
  final String name;
  final String description;
  final String validity;

  BundleProduct({
    this.bundleId,
    this.brandId,
    this.network,
    this.productCode,
    this.amount,
    this.name,
    this.description,
    this.validity,
  });

  Map<String, dynamic> toMap() {
    return {
      'BundleId': bundleId,
      'BrandId': brandId,
      'Network': network,
      'ProductCode': productCode,
      'Amount': amount,
      'Name': name,
      'Description': description,
      'Validity': validity,
    };
  }

  factory BundleProduct.fromMap(Map<String, dynamic> map) {
    return BundleProduct(
      bundleId: map['BundleId'] ?? 0,
      brandId: map['BrandId'] ?? 0,
      network: map['Network'] ?? '',
      productCode: map['ProductCode'] ?? '',
      amount: map['Amount'] ?? 0,
      name: map['Name'] ?? '',
      description: map['Description'] ?? '',
      validity: map['Validity'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'BundleProduct(bundleId: $bundleId, brandId: $brandId, network: $network, productCode: $productCode, amount: $amount, name: $name, description: $description, validity: $validity)';
  }
}
