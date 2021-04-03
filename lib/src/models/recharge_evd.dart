import 'dart:convert';

/// recharge evd success response model
class RechargeEvd {
  final String agentReference;
  final double amount;
  final double discount;
  final int rechargeID;
  final int replyCode;
  final String replyMsg;
  final List<String> pins;
  final double walletBalance;

  RechargeEvd({
    this.agentReference,
    this.amount,
    this.discount,
    this.rechargeID,
    this.replyCode,
    this.replyMsg,
    this.pins,
    this.walletBalance,
  });

  Map<String, dynamic> toMap() {
    return {
      'AgentReference': agentReference,
      'Amount': amount,
      'Discount': discount,
      'RechargeID': rechargeID,
      'ReplyCode': replyCode,
      'ReplyMsg': replyMsg,
      'Pins': pins,
      'WalletBalance': walletBalance,
    };
  }

  factory RechargeEvd.fromMap(Map<String, dynamic> map) {
    return RechargeEvd(
      agentReference: map['AgentReference'] ?? '',
      amount: map['Amount'] ?? 0.0,
      discount: map['Discount'] ?? 0.0,
      rechargeID: map['RechargeID'] ?? 0,
      replyCode: map['ReplyCode'] ?? 0,
      replyMsg: map['ReplyMsg'] ?? '',
      pins: List<String>.from(map['Pins'] ?? const []),
      walletBalance: map['WalletBalance'] ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'RechargeEvd(agentReference: $agentReference, amount: $amount, discount: $discount, rechargeID: $rechargeID, replyCode: $replyCode, replyMsg: $replyMsg, pins: $pins, walletBalance: $walletBalance)';
  }
}
