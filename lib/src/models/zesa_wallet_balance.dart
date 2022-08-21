import 'dart:convert';

/// get business | user account zesa wallet balance
class ZesaWalletBalance {
  final String agentReference;
  final int replyCode;
  final String replyMsg;
  final double walletBalance;

  ZesaWalletBalance({
    required this.agentReference,
    required this.replyCode,
    required this.replyMsg,
    required this.walletBalance,
  });

  ZesaWalletBalance copyWith({
    String? agentReference,
    int? replyCode,
    String? replyMsg,
    double? walletBalance,
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
