import 'dart:convert';

import 'package:hot_recharge/hot_recharge.dart';

/// query zesa transaction success response model
/// it return same original response [ZesaRecharge] with additional information of [CustomerInfo]
class QueryZesaTransaction {
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
  final CustomerInfo customerInfo;

  QueryZesaTransaction({
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
    this.customerInfo,
  });

  QueryZesaTransaction copyWith({
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
    ZesaCustomerDetail customerInfo,
  }) {
    return QueryZesaTransaction(
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
      customerInfo: customerInfo ?? this.customerInfo,
    );
  }

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
      'CustomerInfo': customerInfo.toMap(),
    };
  }

  factory QueryZesaTransaction.fromMap(Map<String, dynamic> map) {
    return QueryZesaTransaction(
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
      customerInfo: CustomerInfo.fromMap(map['CustomerInfo']),
    );
  }

  String toJson() => json.encode(toMap());

  factory QueryZesaTransaction.fromJson(String source) =>
      QueryZesaTransaction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QueryZesaTransaction(replyCode: $replyCode, replyMsg: $replyMsg, walletBalance: $walletBalance, amount: $amount, discount: $discount, meter: $meter, accountName: $accountName, address: $address, tokens: $tokens, agentReference: $agentReference, rechargeID: $rechargeID, customerInfo: $customerInfo)';
  }
}
