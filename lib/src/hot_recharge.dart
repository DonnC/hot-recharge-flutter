import 'package:flutter/foundation.dart';

import 'models/index.dart';
import 'services/api.dart';

/// connect to hot-recharge and perfom airtime topup and zesa recharge
class HotRecharge {
  // hot-recharge account email
  final String accessCode;

  // hot-recharge account password
  final String accessPswd;

  // flag to enable | disable logging internal data to console
  final bool enableLogger;

  String _email;
  String _pswd;

  Api _api;

  /// connect to hot-recharge services, accessCode: account email, accessPswd: account password
  /// `enableLogger` set to true to enable printing internal detailed messages on console. Useful while testing
  HotRecharge({
    @required this.accessCode,
    @required this.accessPswd,
    this.enableLogger: false,
  }) {
    _email = accessCode.trim();
    _pswd = accessPswd.trim();

    _api = Api(
      email: _email,
      pswd: _pswd,
      enableLogger: enableLogger,
    );
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

  /// recharge a mobile number, number can be any supported zim number 07xxx.. or 08...
  /// brandID - (Optional)
  /// customMessage - (Optional), customised sms to send to user upon topup, 135 chars max
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
  /// meterNumber is a 11 char zesa meter number
  /// it is advised to first check customer and prompt for them to verify the details from [CustomerInfo] -> customerName response
  /// before proceeding to make zesa recharge payment
  /// ```dart
  /// var checkCustomer = await api.checkZesaCustomer('<a-11-digit-meter-number>');
  ///
  /// // show a dialog prompt for user to confirm their info before proceeding
  /// // can be anything here just for user to confirm their details
  /// showPromptDialog(checkCustomer.apiResponse.customerInfo.customerName);
  ///
  /// // if confirmed..proceed to make zesa recharge
  /// // else, do something
  /// ```
  Future<ApiResponse> checkZesaCustomer(String meterNumber) async {
    final zesaCustomer = await _api.checkZesaCustomer(meterNumber);

    return zesaCustomer;
  }

  /// recharge zesa meter number, contact is where the token will be sent to as message
  ///
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
  /// var resp = await api.rechargeZesa(2.5, '07xxxxxxxx', 'xxxxxxxxxxx', customMessage: custom_message);
  ///
  /// print(resp.message);
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

  /// recharge bundle package
  ///
  /// customMessage - Optional, customised sms to send to user upon topup, 135 chars max
  ///      custom Message place holders to use and their representation on end user:
  ///      %AMOUNT% - $xxx.xx
  ///      %BUNDLE% - Name of data bundle
  ///      %ACCESSNAME% - as defined on website (Teller | branch name)
  ///      %COMPANYNAME% - as defined by Customer on the website www.hot.co.zw
  ///
  /// ```dart
  /// final custom_message = """
  ///   Recharge of \$ %AMOUNT% is successful.
  ///   %BUNDLE% bundle has been recharged
  ///   The best %COMPANYNAME%!
  /// """;
  ///
  /// var resp = await api.rechargeBundle('<product-code>', '07xxxxxxxx', customMessage: custom_message);
  /// print(resp.message);
  /// ```
  /// return -> [ApiResponse]
  Future<ApiResponse> rechargeBundle(
    String productCode,
    String contact, {
    int amount,
    String customMessage,
  }) async {
    final bundle = await _api.rechargeBundle(
      productCode,
      contact,
      amount: amount,
      customMessage: customMessage,
    );

    return bundle;
  }

  /// get available data bundles
  /// returns a list of data bundles in [bundles] attribute on successful [ApiResponse]
  Future<ApiResponse> getAvailableBundles() async {
    final bundles = await _api.getDataBundles();

    return bundles;
  }

  /// query available evd (electronic vouchers)
  Future<ApiResponse> queryEvd() async {
    final evd = await _api.queryEVD();

    return evd;
  }

  /// recharge electronic voucher for supported network
  ///
  /// first call [api.queryEvd()] to get appropriate fields to pass here as args
  Future<ApiResponse> rechargeEvd(
    int brandID,
    double pinValue, // the then Denomination
    String contact,
    int quantity,
  ) async {
    final evdR = await _api.rechargeEvd(
      brandID,
      pinValue, // Denomination
      contact,
      quantity,
    );

    return evdR;
  }

  /*
  /// bulk recharge electronic voucher
  Future<ApiResponse> bulkRechargeEvd(
    int brandID,
    double pinValue, // Denomination
    int quantity,
  ) async {
    final bulkEvd = await _api.bulkPurchaseEvd(
      brandID,
      pinValue, // Denomination

      quantity,
    );

    return bulkEvd;
  }
  */

  /// query previous zesa transaction by its rechargeID
  ///
  /// also very useful for querying zesa recharge transactions for [ApiResponse] rechargeResponse -> [RechargeResponse.PENDING]
  ///
  /// very useful when `rechargeZesa(...)` returns  [RechargeResponse.PENDING]. Its reccommended not to perform a recharge again but poll this query until transaction status is success
  /// refer to Docs for more
  Future<ApiResponse> queryZesaTransaction(int rechargeId) async {
    final queryZesa = _api.queryZesaTransaction(rechargeId);

    return queryZesa;
  }
}
