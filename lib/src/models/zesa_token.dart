import 'dart:convert';

// zesa token item model
class ZesaTokenItem {
  final String token;
  final String units;
  final String netAmount;
  final String levy;
  final String arrears;
  final String taxAmount;
  final String zesaReference;

  ZesaTokenItem({
    this.token,
    this.units,
    this.netAmount,
    this.levy,
    this.arrears,
    this.taxAmount,
    this.zesaReference,
  });

  ZesaTokenItem copyWith({
    String token,
    String units,
    String netAmount,
    String levy,
    String arrears,
    String taxAmount,
    String zesaReference,
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
    if (map == null) return null;

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
