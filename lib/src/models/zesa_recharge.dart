import 'dart:convert';

import 'zesa_token.dart';

/// response model on successful zesa recharge
class ZesaRecharge {
  final int replyCode;
  final String replyMsg;
  final double walletBalance;
  final double amount;
  final double discount;
  final String meter;
  final String accountName;
  final String address;
  final List<ZesaTokenItem> tokens;
  final String agentReference;
  final int rechargeID;

  Map<String, dynamic> toMap() {
    return {
      'ReplyCode': replyCode,
      'ReplyMsg': replyMsg,
      'WalletBalance': walletBalance,
      'Amount': amount,
      'Discount': discount,
      'Meter': meter,
      'AccountName': accountName,
      'Address': address,
      'Tokens': tokens?.map((x) => x.toMap())?.toList(),
      'AgentReference': agentReference,
      'RechargeID': rechargeID,
    };
  }

  ZesaRecharge({
    this.replyCode,
    this.replyMsg,
    this.walletBalance,
    this.amount,
    this.discount,
    this.meter,
    this.accountName,
    this.address,
    this.tokens,
    this.agentReference,
    this.rechargeID,
  });

  ZesaRecharge copyWith({
    int replyCode,
    String replyMsg,
    double walletBalance,
    double amount,
    double discount,
    String meter,
    String accountName,
    String address,
    List<ZesaTokenItem> tokens,
    String agentReference,
    int rechargeID,
  }) {
    return ZesaRecharge(
      replyCode: replyCode ?? this.replyCode,
      replyMsg: replyMsg ?? this.replyMsg,
      walletBalance: walletBalance ?? this.walletBalance,
      amount: amount ?? this.amount,
      discount: discount ?? this.discount,
      meter: meter ?? this.meter,
      accountName: accountName ?? this.accountName,
      address: address ?? this.address,
      tokens: tokens ?? this.tokens,
      agentReference: agentReference ?? this.agentReference,
      rechargeID: rechargeID ?? this.rechargeID,
    );
  }

  

  factory ZesaRecharge.fromMap(Map<String, dynamic> map) {
    return ZesaRecharge(
      replyCode: map['ReplyCode'],
      replyMsg: map['ReplyMsg'],
      walletBalance: map['WalletBalance'],
      amount: map['Amount'],
      discount: map['Discount'],
      meter: map['Meter'],
      accountName: map['AccountName'],
      address: map['Address'],
      tokens: List<ZesaTokenItem>.from(
          map['Tokens']?.map((x) => ZesaTokenItem.fromMap(x))),
      agentReference: map['AgentReference'],
      rechargeID: map['RechargeID'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ZesaRecharge.fromJson(String source) =>
      ZesaRecharge.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ZesaRecharge(replyCode: $replyCode, replyMsg: $replyMsg, walletBalance: $walletBalance, amount: $amount, discount: $discount, meter: $meter, accountName: $accountName, address: $address, tokens: $tokens, agentReference: $agentReference, rechargeID: $rechargeID)';
  }
}
