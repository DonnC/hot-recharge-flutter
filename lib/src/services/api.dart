/*
  Hot Recharge Flutter Api Library
  __author__  Donald Chinhuru | Ngonidzashe Mangudya
  __version__ 1.0.0
  __name__    Hot Recharge

  a python port for hot-recharge library
*/

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:hot_recharge/src/models/index.dart';
import 'package:hot_recharge/src/utils.dart';
import 'package:uuid/uuid.dart';

class Api {
  static const String _ROOT_ENDPOINT = "ssl.hot.co.zw";
  static const String _API_VERSION = "/api/v1/";
  static const String _MIME_TYPES = "application/json";

  // endpoints definition
  static const String _RECHARGE_PINLESS = "agents/recharge-pinless";
  static const String _RECHARGE_ZESA = "agents/recharge-zesa";
  static const String _WALLET_BALANCE = "agents/wallet-balance";
  static const String _ZESA_BALANCE = 'agents/wallet-balance-zesa';
  static const String _CHECK_ZESA_CUSTOMER = "agents/check-customer-zesa";
  static const String _QUERY_TRANSACTION =
      "agents/query-transaction?agentReference=";
  static const String _QUERY_ZESA = "agents/query-zesa-transaction";
  static const String _END_USER_BALANCE =
      "agents/enduser-balance?targetmobile=";

  final String email;
  final String pswd;

  Map<String, dynamic> _headers;

  Api({
    this.email,
    this.pswd,
  }) {
    this._buildHeaders();
  }

  /// auto generate agent-reference using uuid v4 chunk
  String _generateReference() {
    final uuid = Uuid();
    String val = uuid.v4();

    var chunk = val.split('-');

    return chunk.first;
  }

  /// build up headers to use as requested in each request by the api
  void _buildHeaders() {
    _headers = {
      'x-access-code': this.email,
      'x-access-password': this.pswd,
      'x-agent-reference': this._generateReference(),
      'Content-type': _MIME_TYPES,
      'cache-control': "no-cache",
    };
  }

  /// update x-agent-reference automatically
  /// api requires that each request have a unique agent-reference
  void _autoUpdateReference() {
    this._headers.update(
          'x-agent-reference',
          (value) => this._generateReference(),
        );
  }

  Future<ApiResponse> getWalletBalance() async {
    _autoUpdateReference();

    try {
      String url = _ROOT_ENDPOINT + _API_VERSION + _WALLET_BALANCE;

      http.Response response = await http.get(
        url,
        headers: this._headers,
      );

      var data = jsonDecode(response.body);

      if (data['ReplyCode'] == 2) {
        // success
        WalletBalance wb = WalletBalance.fromMap(data);

        return ApiResponse(
          message: 'wallet balance success',
          statusresponse: RECHARGERESPONSE.SUCCESS,
          apiResponse: wb,
        );
      }

      return ApiResponse(
        message: 'wallet balance failed',
        statusresponse: RECHARGERESPONSE.API_ERROR,
        apiResponse: data,
      );
    }

    // error
    catch (e) {
      return ApiResponse(
        statusresponse: RECHARGERESPONSE.ERROR,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse> getZesaWalletBalance() async {
    _autoUpdateReference();

    try {
      String url = _ROOT_ENDPOINT + _API_VERSION + _ZESA_BALANCE;

      http.Response response = await http.get(
        url,
        headers: this._headers,
      );

      var data = jsonDecode(response.body);

      if (data['ReplyCode'] == 2) {
        // success
        ZesaWalletBalance zb = ZesaWalletBalance.fromJson(response.body);

        return ApiResponse(
          message: 'zesa wallet balance success',
          statusresponse: RECHARGERESPONSE.SUCCESS,
          apiResponse: zb,
        );
      }

      return ApiResponse(
        message: 'zesa wallet balance failed',
        statusresponse: RECHARGERESPONSE.API_ERROR,
        apiResponse: data,
      );
    }

    // error
    catch (e) {
      return ApiResponse(
        statusresponse: RECHARGERESPONSE.ERROR,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse> queryTopupTransaction(String agentReference) async {
    _autoUpdateReference();

    try {
      String url =
          _ROOT_ENDPOINT + _API_VERSION + _QUERY_TRANSACTION + agentReference;

      http.Response response = await http.get(
        url,
        headers: this._headers,
      );

      var data = jsonDecode(response.body);

      if (data['ReplyCode'] == 2) {
        // success
        QueryTransaction qt = QueryTransaction.fromJson(response.body);

        return ApiResponse(
          message: 'query transaction success',
          statusresponse: RECHARGERESPONSE.SUCCESS,
          apiResponse: qt,
        );
      }

      return ApiResponse(
        message: 'query transaction failed',
        statusresponse: RECHARGERESPONSE.API_ERROR,
        apiResponse: data,
      );
    }

    // error
    catch (e) {
      return ApiResponse(
        statusresponse: RECHARGERESPONSE.ERROR,
        message: e.toString(),
      );
    }
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
  ///   Thank you for using %COMPANYNAME%
  /// """;
  /// var resp = api.rechargePinless(2.5, '07xxxxxxxx', customMessage: custom_message);
  /// ```
  /// return: [ApiResponse]
  Future<ApiResponse> rechargePinless(
    double amount,
    String contact, {
    String brandID,
    String customMessage,
  }) async {
    _autoUpdateReference();

    try {
      Map<String, dynamic> payload;

      payload['amount'] = amount;

      if (brandID != null) {
        payload['BrandID'] = brandID;
      }

      if (customMessage != null) {
        payload['CustomerSMS'] = customMessage;
      }

      if (contact.startsWith('07') || contact.startsWith('08')) {
        payload['targetMobile'] = contact;
      }

      String url = _ROOT_ENDPOINT + _API_VERSION + _RECHARGE_PINLESS;

      http.Response response = await http.post(
        url,
        body: payload,
        headers: this._headers,
      );

      var data = jsonDecode(response.body);

      if (data['ReplyCode'] == 2) {
        // success
        PinlessRecharge pr = PinlessRecharge.fromJson(response.body);

        return ApiResponse(
          message: 'recharge pinless success',
          statusresponse: RECHARGERESPONSE.SUCCESS,
          apiResponse: pr,
        );
      }

      return ApiResponse(
        message: 'pinless recharge failed',
        statusresponse: RECHARGERESPONSE.API_ERROR,
        apiResponse: data,
      );
    }

    // error
    catch (e) {
      return ApiResponse(
        statusresponse: RECHARGERESPONSE.ERROR,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse> checkZesaCustomer(String meterNumber) async {
    _autoUpdateReference();

    try {
      String url = _ROOT_ENDPOINT + _API_VERSION + _CHECK_ZESA_CUSTOMER;

      http.Response response = await http.post(
        url,
        body: {
          'MeterNumber': meterNumber,
        },
        headers: this._headers,
      );

      var data = jsonDecode(response.body);

      if (data['ReplyCode'] == 2) {
        // success
        ZesaCustomerDetail zcd = ZesaCustomerDetail.fromJson(response.body);

        return ApiResponse(
          message: 'check zesa customer success',
          statusresponse: RECHARGERESPONSE.SUCCESS,
          apiResponse: zcd,
        );
      }

      return ApiResponse(
        message: 'check zesa customer failed',
        statusresponse: RECHARGERESPONSE.API_ERROR,
        apiResponse: data,
      );
    }

    // error
    catch (e) {
      return ApiResponse(
        statusresponse: RECHARGERESPONSE.ERROR,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse> rechargeZesa(
    double amount,
    String contact,
    String meterNumber, {
    String customMessage,
  }) async {
    _autoUpdateReference();

    try {
      Map<String, dynamic> payload;

      payload['Amount'] = amount;
      payload['meterNumber'] = meterNumber;

      if (customMessage != null) {
        payload['CustomerSMS'] = customMessage;
      }

      if (contact.startsWith('07')) {
        payload['TargetMobile'] = contact;
      }

      String url = _ROOT_ENDPOINT + _API_VERSION + _RECHARGE_ZESA;

      http.Response response = await http.post(
        url,
        body: payload,
        headers: this._headers,
      );

      var data = jsonDecode(response.body);

      if (data['ReplyCode'] == 2) {
        // success
        ZesaRecharge zr = ZesaRecharge.fromJson(response.body);

        return ApiResponse(
          message: 'zesa recharge success',
          statusresponse: RECHARGERESPONSE.SUCCESS,
          apiResponse: zr,
        );
      }

      if (data['ReplyCode'] == 4) {
        // pending zesa transaction
        return ApiResponse(
          message: 'zesa recharge pending',
          statusresponse: RECHARGERESPONSE.PENDING,
          apiResponse: data,
        );
      }

      return ApiResponse(
        message: 'zesa recharge failed',
        statusresponse: RECHARGERESPONSE.API_ERROR,
        apiResponse: data,
      );
    }

    // error
    catch (e) {
      return ApiResponse(
        statusresponse: RECHARGERESPONSE.ERROR,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse> queryZesaTransaction(String rechargeId) async {
    _autoUpdateReference();

    try {
      String url = _ROOT_ENDPOINT + _API_VERSION + _QUERY_ZESA;

      http.Response response = await http.post(
        url,
        body: {"RechargeId": rechargeId},
        headers: this._headers,
      );

      var data = jsonDecode(response.body);

      if (data['ReplyCode'] == 2) {
        // success
        // TODO: Return proper model

        return ApiResponse(
          message: 'query zesa transaction success',
          statusresponse: RECHARGERESPONSE.SUCCESS,
          apiResponse: data,
        );
      }

      return ApiResponse(
        message: 'query zesa transaction failed',
        statusresponse: RECHARGERESPONSE.API_ERROR,
        apiResponse: data,
      );
    }

    // error
    catch (e) {
      return ApiResponse(
        statusresponse: RECHARGERESPONSE.ERROR,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse> endUserBalance(String mobileNumber) async {
    this._autoUpdateReference();
    http.Response response;
    try {
      String url =
          _ROOT_ENDPOINT + _API_VERSION + _END_USER_BALANCE + mobileNumber;
      response = await http.get(url, headers: this._headers);

      var data = json.decode(response.body);
      return data;
    } catch (e) {
      return ApiResponse(
        statusresponse: RECHARGERESPONSE.ERROR,
        message: e.toString(),
      );
    }
  }
}
