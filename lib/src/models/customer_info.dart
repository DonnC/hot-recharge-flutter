import 'dart:convert';

/// zesa customer information model, property of [ZesaCustomerDetail] -> customerInfo
/// used to get customer information from their zesa meter number
class CustomerInfo {
  final String customerName;
  final String reference;
  final String address;
  final String meterNumber;

  CustomerInfo({
    this.reference,
    this.meterNumber,
    this.customerName,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'CustomerName': customerName,
      'Address': address,
      'MeterNumber': meterNumber,
      'Reference': reference,
    };
  }

  factory CustomerInfo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CustomerInfo(
      customerName: map['CustomerName'],
      address: map['Address'],
      meterNumber: map['MeterNumber'],
      reference: map['Reference'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerInfo.fromJson(String source) =>
      CustomerInfo.fromMap(json.decode(source));

  @override
  String toString() =>
      'CustomerInfo(customerName: $customerName, address: $address, meternumber: $meterNumber, reference: $reference)';
}
