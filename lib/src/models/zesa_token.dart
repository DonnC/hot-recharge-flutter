import 'dart:convert';

/// zesa token item model, a property in [ZesaRecharge] -> tokens
class ZesaTokenItem {
  final String token;
  final double units;
  final double netAmount;
  final double levy;
  final double arrears;
  final double taxAmount;
  final String zesaReference;

  ZesaTokenItem({
    required this.token,
    required this.units,
    required this.netAmount,
    required this.levy,
    required this.arrears,
    required this.taxAmount,
    required this.zesaReference,
  });

  ZesaTokenItem copyWith({
    String? token,
    double? units,
    double? netAmount,
    double? levy,
    double? arrears,
    double? taxAmount,
    String? zesaReference,
  }) {
    return ZesaTokenItem(
      token: token ?? this.token,
      units: units ?? this.units,
      netAmount: netAmount ?? this.netAmount,
      levy: levy ?? this.levy,
      arrears: arrears ?? this.arrears,
      taxAmount: taxAmount ?? this.taxAmount,
      zesaReference: zesaReference ?? this.zesaReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Token': token,
      'Units': units,
      'NetAmount': netAmount,
      'Levy': levy,
      'Arrears': arrears,
      'TaxAmount': taxAmount,
      'ZesaReference': zesaReference,
    };
  }

  factory ZesaTokenItem.fromMap(Map<String, dynamic> map) {
    return ZesaTokenItem(
      token: map['Token'],
      units: map['Units'],
      netAmount: map['NetAmount'],
      levy: map['Levy'],
      arrears: map['Arrears'],
      taxAmount: map['TaxAmount'],
      zesaReference: map['ZesaReference'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ZesaTokenItem.fromJson(String source) =>
      ZesaTokenItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ZesaTokenItem(token: $token, units: $units, netAmount: $netAmount, levy: $levy, arrears: $arrears, taxAmount: $taxAmount, zesaReference: $zesaReference)';
  }
}
