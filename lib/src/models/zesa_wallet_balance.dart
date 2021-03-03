import 'dart:convert';

class ZesaWalletBalance {
  final String agentReference;
  final int replyCode;
  final String replyMsg;
  final double walletBalance;

  ZesaWalletBalance({
    this.agentReference,
    this.replyCode,
    this.replyMsg,
    this.walletBalance,
  });

  ZesaWalletBalance copyWith({
    String agentReference,
    int replyCode,
    String replyMsg,
    double walletBalance,
  }) {
    return ZesaWalletBalance(
      agentReference: agentReference ?? this.agentReference,
      replyCode: replyCode ?? this.replyCode,
      replyMsg: replyMsg ?? this.replyMsg,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'AgentReference': agentReference,
      'ReplyCode': replyCode,
      'ReplyMsg': replyMsg,
      'WalletBalance': walletBalance,
    };
  }

  factory ZesaWalletBalance.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ZesaWalletBalance(
      agentReference: map['AgentReference'],
      replyCode: map['ReplyCode'],
      replyMsg: map['ReplyMsg'],
      walletBalance: map['WalletBalance'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ZesaWalletBalance.fromJson(String source) =>
      ZesaWalletBalance.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ZesaWalletBalance(agentReference: $agentReference, replyCode: $replyCode, replyMsg: $replyMsg, walletBalance: $walletBalance)';
  }
}
