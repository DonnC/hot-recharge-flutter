import 'package:flutter/foundation.dart';

import 'models/index.dart';
import 'services/api.dart';

/// connect to hot-recharge and perfom topup programmatically
/// sign up for hot-recharge cooperate account or contact hot-recharge for proper account
class HotRecharge {
  // hot-recharge account email
  final String accessCode;

  // hot-recharge account password
  final String accessPswd;

  String _email;
  String _pswd;
  Api _api;

  HotRecharge({
    @required this.accessCode,
    @required this.accessPswd,
  }) {
    _email = accessCode.trim();
    _pswd = accessPswd.trim();

    _api = Api(email: _email, pswd: _pswd);
  }

  /// get account airtime topup wallet balance. Returns -> [ApiResponse]
  Future<ApiResponse> topupWalletBalance() async {
    final bal = await _api.getWalletBalance();

    return bal;
  }

  /// get account zesa wallet balance. Returns -> [ApiResponse]
  Future<ApiResponse> zesaWalletBalance() async {
    final bal = await _api.getZesaWalletBalance();

    return bal;
  }

  /// Query a transaction for reconciliation: reccommended is to query within the last 30 days of the transaction
  /// `agentReference`:  previous transaction record's agentReference
  /// return -> [ApiResponse]
  Future<ApiResponse> queryTopupTransaction(String agentReference) async {
    final result = await _api.queryTopupTransaction(agentReference);

    return result;
  }

  /// recharge a mobile number, number can be any supported zim number 07xxx.. or landline 08...
  /// brandID - Optional:
  /// customMessage - Optional, customised sms to send to user upon topup, 135 chars max
  ///      custom Message place holders to use and their representation on end user:
  ///      %AMOUNT% - $xxx.xx
  ///      %INITIALBALANCE% - $xxx.xx
  ///      %FINALBALANCE% - $xxx.xx
  ///      %TXT% - xxx texts
  ///      %DATA% - xxx MB
  ///      %COMPANYNAME% - as defined by Customer on the website www.hot.co.zw
  ///      %ACCESSNAME% - defined by Customer on website – Teller or Trusted User or branch name
  ///
  /// ```dart
  /// final custom_message = """
  ///   Your recharge of \$ %AMOUNT% is successful.
  ///   Your final airtime bal: \$ %FINALBALANCE%.
  ///   Thank you for using %COMPANYNAME%.
  /// """;
  /// var resp = api.topupNumber(2.5, '07xxxxxxxx', customMessage: custom_message);
  /// ```
  /// return -> [ApiResponse]
  Future<ApiResponse> topupNumber(
    double amount,
    String contact, {
    String brandID,
    String customMessage,
  }) async {
    final topup = await _api.rechargePinless(
      amount,
      contact,
      brandID: brandID,
      customMessage: customMessage,
    );

    return topup;
  }

  /// get more information about zesa customer from meter-number
  Future<ApiResponse> checkZesaCustomer(var meterNumber) async {
    final zesaCustomer = await _api.checkZesaCustomer(meterNumber);

    return zesaCustomer;
  }

  /// recharge zesa meter number, contact is where the token will be sent to as message
  /// customMessage - Optional, customised sms to send to user upon topup, 135 chars max
  ///      custom Message place holders to use and their representation on end user:
  ///      %AMOUNT% - $xxx.xx
  ///      %KWH% - Unit in Kilowatt Hours(Kwh)
  ///      %ACOUNTNAME% - Account holdername of meter number
  ///      %METERNUMBER% - meter number
  ///      %COMPANYNAME% - as defined by Customer on the website www.hot.co.zw
  ///
  /// ```dart
  /// final custom_message = """
  ///   Recharge of \$ %AMOUNT% is successful.
  ///   Units %KWH% Kwh recharged for meter %METERNUMBER% of %ACOUNTNAME%.
  ///   The best %COMPANYNAME%!
  /// """;
  ///
  /// var resp = api.rechargeZesa(2.5, '07xxxxxxxx', 'xxxxxxxxxxx', customMessage: custom_message);
  /// ```
  /// return -> [ApiResponse]
  Future<ApiResponse> rechargeZesa(
    double amount,
    String contact,
    String meterNumber, {
    String customMessage,
  }) async {
    final zesa = await _api.rechargeZesa(
      amount,
      contact,
      meterNumber,
      customMessage: customMessage,
    );

    return zesa;
  }

  /// query previous zesa transaction by its rechargeID
  /// also very useful for querying zesa recharge transactions for [ApiResponse] statusresponse -> [RECHARGERESPONSE.PENDING]
  /// very useful when `rechargeZesa(...)` returns  [RECHARGERESPONSE.PENDING]. Its reccommended not to perform a recharge again but poll this query until transaction status is success
  /// refer to Docs for more
  Future<ApiResponse> queryZesaTransaction(String rechargeId) async {
    final queryZesa = _api.queryZesaTransaction(rechargeId);

    return queryZesa;
  }
}