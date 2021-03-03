import 'dart:convert';

// zesa customer info object
class CustomerInfo {
  final String customerName;
  final String address;

  CustomerInfo({
    this.customerName,
    this.address,
  });

  CustomerInfo copyWith({
    String customerName,
    String address,
  }) {
    return CustomerInfo(
      customerName: customerName ?? this.customerName,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'CustomerName': customerName,
      'Address': address,
    };
  }

  factory CustomerInfo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CustomerInfo(
      customerName: map['CustomerName'],
      address: map['Address'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerInfo.fromJson(String source) =>
      CustomerInfo.fromMap(json.decode(source));

  @override
  String toString() =>
      'CustomerInfo(customerName: $customerName, address: $address)';
}
