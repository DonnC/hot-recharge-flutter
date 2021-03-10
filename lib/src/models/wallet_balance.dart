import 'dart:convert';

/// business topup account wallet balance
class WalletBalance {
  final String agentReference;
  final int replyCode;
  final String replyMsg;
  final double walletBalance;

  WalletBalance({
    this.agentReference,
    this.replyCode,
    this.replyMsg,
    this.walletBalance,
  });

  WalletBalance copyWith({
    String agentReference,
    int replyCode,
    String replyMsg,
    double walletBalance,
  }) {
    return WalletBalance(
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

  factory WalletBalance.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return WalletBalance(
      agentReference: map['AgentReference'],
      replyCode: map['ReplyCode'],
      replyMsg: map['ReplyMsg'],
      walletBalance: map['WalletBalance'],
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletBalance.fromJson(String source) =>
      WalletBalance.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WalletBalance(agentReference: $agentReference, replyCode: $replyCode, replyMsg: $replyMsg, walletBalance: $walletBalance)';
  }
}
