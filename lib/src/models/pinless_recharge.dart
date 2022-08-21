import 'dart:convert';

/// response model for a successful pinless recharge (airtime topup to user number)
class PinlessRecharge {
  final String agentReference;
  final double amount;
  final double data;
  final double discount;
  final double finalBalance;
  final double initialBalance;
  final int rechargeID;
  final int replyCode;
  final String replyMsg;
  final int sms;
  final double walletBalance;
  final dynamic window;

  PinlessRecharge({
    required this.agentReference,
    required this.amount,
    required this.data,
    required this.discount,
    required this.finalBalance,
    required this.initialBalance,
    required this.rechargeID,
    required this.replyCode,
    required this.replyMsg,
    required this.sms,
    required this.walletBalance,
    this.window,
  });

  PinlessRecharge copyWith({
    String? agentReference,
    double? amount,
    double? data,
    double? discount,
    double? finalBalance,
    double? initialBalance,
    int? rechargeID,
    int? replyCode,
    String? replyMsg,
    int? sms,
    double? walletBalance,
    dynamic window,
  }) {
    return PinlessRecharge(
      agentReference: agentReference ?? this.agentReference,
      amount: amount ?? this.amount,
      data: data ?? this.data,
      discount: discount ?? this.discount,
      finalBalance: finalBalance ?? this.finalBalance,
      initialBalance: initialBalance ?? this.initialBalance,
      rechargeID: rechargeID ?? this.rechargeID,
      replyCode: replyCode ?? this.replyCode,
      replyMsg: replyMsg ?? this.replyMsg,
      sms: sms ?? this.sms,
      walletBalance: walletBalance ?? this.walletBalance,
      window: window ?? this.window,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'AgentReference': agentReference,
      'Amount': amount,
      'Data': data,
      'Discount': discount,
      'FinalBalance': finalBalance,
      'InitialBalance': initialBalance,
      'RechargeID': rechargeID,
      'ReplyCode': replyCode,
      'ReplyMsg': replyMsg,
      'SMS': sms,
      'WalletBalance': walletBalance,
      'Window': window,
    };
  }

  factory PinlessRecharge.fromMap(Map<String, dynamic> map) {
    return PinlessRecharge(
      agentReference: map['AgentReference'],
      amount: map['Amount'],
      data: map['Data'],
      discount: map['Discount'],
      finalBalance: map['FinalBalance'],
      initialBalance: map['InitialBalance'],
      rechargeID: map['RechargeID'],
      replyCode: map['ReplyCode'],
      replyMsg: map['ReplyMsg'],
      sms: map['SMS'],
      walletBalance: map['WalletBalance'],
      window: map['Window'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PinlessRecharge.fromJson(String source) =>
      PinlessRecharge.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PinlessRecharge(agentReference: $agentReference, amount: $amount, data: $data, discount: $discount, finalBalance: $finalBalance, initialBalance: $initialBalance, rechargeID: $rechargeID, replyCode: $replyCode, replyMsg: $replyMsg, sms: $sms, walletBalance: $walletBalance, window: $window)';
  }
}
