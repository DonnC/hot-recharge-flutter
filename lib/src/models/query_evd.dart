import 'dart:convert';

import 'index.dart';

/// get EVD response
class QueryEvd {
  final int replyCode;
  final String replyMsg;
  final List<EvdPin> inStock;
  final String agentReference;

  QueryEvd({
    this.replyCode,
    this.replyMsg,
    this.inStock,
    this.agentReference,
  });

  Map<String, dynamic> toMap() {
    return {
      'ReplyCode': replyCode,
      'ReplyMsg': replyMsg,
      'InStock': inStock?.map((x) => x.toMap())?.toList(),
      'AgentReference': agentReference,
    };
  }

  factory QueryEvd.fromMap(Map<String, dynamic> map) {
    return QueryEvd(
      replyCode: map['ReplyCode'] ?? 0,
      replyMsg: map['ReplyMsg'] ?? '',
      inStock: List<EvdPin>.from(
          map['InStock']?.map((x) => EvdPin.fromMap(x) ?? EvdPin()) ??
              const []),
      agentReference: map['AgentReference'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'QueryEvd(replyCode: $replyCode, replyMsg: $replyMsg, inStock: $inStock, agentReference: $agentReference)';
  }
}
