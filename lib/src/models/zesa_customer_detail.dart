// zesa check customer detail
import 'dart:convert';

import 'customer_info.dart';

class ZesaCustomerDetail {
  final int replyCode;
  final String replyMsg;
  final int meterNumber;
  final String agentReference;
  final CustomerInfo customerInfo;

  ZesaCustomerDetail({
    this.replyCode,
    this.replyMsg,
    this.meterNumber,
    this.agentReference,
    this.customerInfo,
  });

  ZesaCustomerDetail copyWith({
    int replyCode,
    String replyMsg,
    int meterNumber,
    String agentReference,
    CustomerInfo customerInfo,
  }) {
    return ZesaCustomerDetail(
      replyCode: replyCode ?? this.replyCode,
      replyMsg: replyMsg ?? this.replyMsg,
      meterNumber: meterNumber ?? this.meterNumber,
      agentReference: agentReference ?? this.agentReference,
      customerInfo: customerInfo ?? this.customerInfo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ReplyCode': replyCode,
      'ReplyMsg': replyMsg,
      'MeterNumber': meterNumber,
      'AgentReference': agentReference,
      'CustomerInfo': customerInfo?.toMap(),
    };
  }

  factory ZesaCustomerDetail.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ZesaCustomerDetail(
      replyCode: map['ReplyCode'],
      replyMsg: map['ReplyMsg'],
      meterNumber: map['MeterNumber'],
      agentReference: map['AgentReference'],
      customerInfo: CustomerInfo.fromMap(map['CustomerInfo']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ZesaCustomerDetail.fromJson(String source) =>
      ZesaCustomerDetail.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ZesaCustomerDetail(replyCode: $replyCode, replyMsg: $replyMsg, meterNumber: $meterNumber, agentReference: $agentReference, customerInfo: $customerInfo)';
  }
}
