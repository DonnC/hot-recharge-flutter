import 'dart:convert';

class EndUserBalance {
  final int replyCode;
  final String replyMesg;
  final double mobileBalance;
  final dynamic windowPeriod;
  final String agentReference;

  EndUserBalance({
    this.replyCode,
    this.replyMesg,
    this.mobileBalance,
    this.windowPeriod,
    this.agentReference,
  });

  EndUserBalance copyWith({
    int replyCode,
    String replyMesg,
    double mobileBalance,
    int windowPeriod,
    String agentReference,
  }) {
    return EndUserBalance(
      replyCode: replyCode ?? this.replyCode,
      replyMesg: replyMesg ?? this.replyMesg,
      mobileBalance: mobileBalance ?? this.mobileBalance,
      windowPeriod: windowPeriod ?? this.windowPeriod,
      agentReference: agentReference ?? this.agentReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ReplyCode': replyCode,
      'ReplyMesg': replyMesg,
      'MobileBalance': mobileBalance,
      'WindowPeriod': windowPeriod,
      'AgentReference': agentReference,
    };
  }

  factory EndUserBalance.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return EndUserBalance(
      replyCode: map['ReplyCode'],
      replyMesg: map['ReplyMesg'],
      mobileBalance: map['MobileBalance'],
      windowPeriod: map['WindowPeriod'],
      agentReference: map['AgentReference'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EndUserBalance.fromJson(String source) =>
      EndUserBalance.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EndUserBalance(replyCode: $replyCode, replyMesg: $replyMesg, mobileBalance: $mobileBalance, windowPeriod: $windowPeriod, agentReference: $agentReference)';
  }
}
