// zesa check customer detail
import 'dart:convert';

import 'customer_info.dart';

/// get zesa customer details from their meter-number
class ZesaCustomerDetail {
  final int replyCode;
  final String replyMsg;
  final String meter;
  final String agentReference;
  final CustomerInfo customerInfo;

  ZesaCustomerDetail({
    this.replyCode,
    this.replyMsg,
    this.meter,
    this.agentReference,
    this.customerInfo,
  });

  ZesaCustomerDetail copyWith({
    int replyCode,
    String replyMsg,
    int meter,
    String agentReference,
    CustomerInfo customerInfo,
  }) {
    return ZesaCustomerDetail(
      replyCode: replyCode ?? this.replyCode,
      replyMsg: replyMsg ?? this.replyMsg,
      meter: meter ?? this.meter,
      agentReference: agentReference ?? this.agentReference,
      customerInfo: customerInfo ?? this.customerInfo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ReplyCode': replyCode,
      'ReplyMsg': replyMsg,
      'Meter': meter,
      'AgentReference': agentReference,
      'CustomerInfo': customerInfo?.toMap(),
    };
  }

  factory ZesaCustomerDetail.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ZesaCustomerDetail(
      replyCode: map['ReplyCode'],
      replyMsg: map['ReplyMsg'],
      meter: map['Meter'],
      agentReference: map['AgentReference'],
      customerInfo: CustomerInfo.fromMap(map['CustomerInfo']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ZesaCustomerDetail.fromJson(String source) =>
      ZesaCustomerDetail.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ZesaCustomerDetail(replyCode: $replyCode, replyMsg: $replyMsg, meter: $meter, agentReference: $agentReference, customerInfo: $customerInfo)';
  }
}
