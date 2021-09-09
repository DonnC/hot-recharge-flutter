import 'dart:convert';

/// response model for a successful pinless recharge (airtime topup to user number)
class BundleRecharge {
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

  BundleRecharge({
    this.agentReference,
    this.amount,
    this.data,
    this.discount,
    this.finalBalance,
    this.initialBalance,
    this.rechargeID,
    this.replyCode,
    this.replyMsg,
    this.sms,
    this.walletBalance,
    this.window,
  });

  BundleRecharge copyWith({
    String agentReference,
    double amount,
    double data,
    double discount,
    double finalBalance,
    double initialBalance,
    int rechargeID,
    int replyCode,
    String replyMsg,
    int sms,
    double walletBalance,
    dynamic window,
  }) {
    return BundleRecharge(
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


  factory BundleRecharge.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return BundleRecharge(
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

  factory BundleRecharge.fromJson(String source) =>
      BundleRecharge.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BundleRecharge(agentReference: $agentReference, amount: $amount, data: $data, discount: $discount, finalBalance: $finalBalance, initialBalance: $initialBalance, rechargeID: $rechargeID, replyCode: $replyCode, replyMsg: $replyMsg, sms: $sms, walletBalance: $walletBalance, window: $window)';
  }
}
