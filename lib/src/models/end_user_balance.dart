import 'dart:convert';

class EndUserBalance {
  final int replyCode;
  final String replyMsg;
  final double mobileBalance;
  final String windowPeriod;
  final String agentReference;
  EndUserBalance({
    this.replyCode,
    this.replyMsg,
    this.mobileBalance,
    this.windowPeriod,
    this.agentReference,
  });

  Map<String, dynamic> toMap() {
    return {
      'ReplyCode': replyCode,
      'ReplyMsg': replyMsg,
      'MobileBalance': mobileBalance,
      'WindowPeriod': windowPeriod,
      'AgentReference': agentReference,
    };
  }

  factory EndUserBalance.fromMap(Map<String, dynamic> map) {
    return EndUserBalance(
      replyCode: map['ReplyCode']?.toInt(),
      replyMsg: map['ReplyMsg'],
      mobileBalance: map['MobileBalance']?.toDouble(),
      windowPeriod: map['WindowPeriod'],
      agentReference: map['AgentReference'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EndUserBalance.fromJson(String source) =>
      EndUserBalance.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EndUserBalance(ReplyCode: $replyCode, ReplyMsg: $replyMsg, MobileBalance: $mobileBalance, WindowPeriod: $windowPeriod, AgentReference: $agentReference)';
  }
}
