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
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class Api {
  static const String _ROOT_ENDPOINT = "https://ssl.hot.co.zw";
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

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  final String email;
  final String pswd;
  final bool enableLogger;

  Map<String, String> _headers;

  Api({
    this.email,
    this.pswd,
    this.enableLogger,
  }) {
    this._buildHeaders();
    _log('api service initialised', LOG_LEVEL.INFO);
  }

  /// auto generate agent-reference using uuid v4 chunk
  String _generateReference() {
    final uuid = Uuid();
    String val = uuid.v4();

    var chunk = val.split('-');

    _log('auto generated ref: ${chunk.first}', LOG_LEVEL.INFO);

    return chunk.first;
  }

  void _log(var message, LOG_LEVEL level) {
    if (enableLogger) {
      switch (level) {
        case LOG_LEVEL.DEBUG:
          logger.d(message);
          break;

        case LOG_LEVEL.INFO:
          logger.i(message);
          break;

        case LOG_LEVEL.ERROR:
          logger.e(message);
          break;

        case LOG_LEVEL.WARNING:
          logger.w(message);
          break;

        default:
          logger.i(message);
      }
    }
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

    _log('making request for: topup wallet balance', LOG_LEVEL.INFO);

    try {
      String url = _ROOT_ENDPOINT + _API_VERSION + _WALLET_BALANCE;

      var response = await http.get(
        url,
        headers: this._headers,
      );

      var data = jsonDecode(response.body);

      _log('raw topup wallet balance response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == 2) {
        // success
        WalletBalance wb = WalletBalance.fromMap(data);

        return ApiResponse(
          message: 'wallet balance success',
          statusresponse: RECHARGERESPONSE.SUCCESS,
          apiResponse: wb,
        );
      }

      _log(data, LOG_LEVEL.WARNING);

      return ApiResponse(
        message: 'wallet balance failed',
        statusresponse: RECHARGERESPONSE.API_ERROR,
        apiResponse: data,
      );
    }

    // error
    catch (e) {
      _log(e, LOG_LEVEL.ERROR);

      return ApiResponse(
        statusresponse: RECHARGERESPONSE.ERROR,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse> getZesaWalletBalance() async {
    _autoUpdateReference();

    _log('making request for: zesa wallet balance', LOG_LEVEL.INFO);

    try {
      String url = _ROOT_ENDPOINT + _API_VERSION + _ZESA_BALANCE;

      var response = await http.get(
        url,
        headers: this._headers,
      );

      var data = jsonDecode(response.body);

      _log('zesa wallet balance response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == 2) {
        // success
        ZesaWalletBalance zb = ZesaWalletBalance.fromJson(response.body);

        return ApiResponse(
          message: 'zesa wallet balance success',
          statusresponse: RECHARGERESPONSE.SUCCESS,
          apiResponse: zb,
        );
      }

      _log(data, LOG_LEVEL.WARNING);

      return ApiResponse(
        message: 'zesa wallet balance failed',
        statusresponse: RECHARGERESPONSE.API_ERROR,
        apiResponse: data,
      );
    }

    // error
    catch (e) {
      _log(e, LOG_LEVEL.ERROR);

      return ApiResponse(
        statusresponse: RECHARGERESPONSE.ERROR,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse> queryTopupTransaction(String agentReference) async {
    _autoUpdateReference();

    _log('making request for: query topup transaction', LOG_LEVEL.INFO);

    try {
      String url =
          _ROOT_ENDPOINT + _API_VERSION + _QUERY_TRANSACTION + agentReference;

      var response = await http.get(
        url,
        headers: this._headers,
      );

      var data = jsonDecode(response.body);

      _log('query topup transaction response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == '2') {
        // success
        QueryTransaction qt = QueryTransaction.fromJson(response.body);

        return ApiResponse(
          message: 'query transaction success',
          statusresponse: RECHARGERESPONSE.SUCCESS,
          apiResponse: qt,
        );
      }

      _log(data, LOG_LEVEL.WARNING);

      return ApiResponse(
        message: 'query transaction failed',
        statusresponse: RECHARGERESPONSE.API_ERROR,
        apiResponse: data,
      );
    }

    // error
    catch (e) {
      _log(e, LOG_LEVEL.ERROR);

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

    _log('making request for: topup number', LOG_LEVEL.INFO);

    try {
      Map<String, dynamic> payload = Map<String, dynamic>();

      payload['amount'] = amount.toString();

      if (brandID != null) {
        payload['BrandID'] = brandID;
      }

      if (customMessage != null) {
        payload['CustomerSMS'] = customMessage;
      }

      if (contact.startsWith('07') || contact.startsWith('08')) {
        payload['targetMobile'] = contact;
      }

      _log('topup number payload: $payload', LOG_LEVEL.INFO);

      String url = _ROOT_ENDPOINT + _API_VERSION + _RECHARGE_PINLESS;

      _headers.remove('Content-type');

      var response = await http.post(
        url,
        body: payload,
        headers: this._headers,
      );

      _headers['Content-type'] = _MIME_TYPES;

      var data = jsonDecode(response.body);

      _log('topup number response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == 2) {
        // success
        PinlessRecharge pr = PinlessRecharge.fromJson(response.body);

        return ApiResponse(
          message: 'recharge pinless success',
          statusresponse: RECHARGERESPONSE.SUCCESS,
          apiResponse: pr,
        );
      }

      _log(data, LOG_LEVEL.WARNING);

      return ApiResponse(
        message: 'pinless recharge failed',
        statusresponse: RECHARGERESPONSE.API_ERROR,
        apiResponse: data,
      );
    }

    // error
    catch (e) {
      _log(e, LOG_LEVEL.ERROR);

      return ApiResponse(
        statusresponse: RECHARGERESPONSE.ERROR,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse> checkZesaCustomer(var meterNumber) async {
    _autoUpdateReference();

    _log('making request for: query zesa customer', LOG_LEVEL.INFO);

    try {
      String url = _ROOT_ENDPOINT + _API_VERSION + _CHECK_ZESA_CUSTOMER;

      _headers.remove('Content-type');

      var response = await http.post(
        url,
        body: {
          'MeterNumber': meterNumber,
        },
        headers: this._headers,
      );

      _headers['Content-type'] = _MIME_TYPES;

      var data = jsonDecode(response.body);

      _log('query zesa customer response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == 2) {
        // success
        ZesaCustomerDetail zcd = ZesaCustomerDetail.fromJson(response.body);

        return ApiResponse(
          message: 'check zesa customer success',
          statusresponse: RECHARGERESPONSE.SUCCESS,
          apiResponse: zcd,
        );
      }

      _log(data, LOG_LEVEL.WARNING);

      return ApiResponse(
        message: 'check zesa customer failed',
        statusresponse: RECHARGERESPONSE.API_ERROR,
        apiResponse: data,
      );
    }

    // error
    catch (e) {
      _log(e, LOG_LEVEL.ERROR);

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

    _log('making request for: zesa recharge', LOG_LEVEL.INFO);

    try {
      Map<String, dynamic> payload = Map<String, dynamic>();

      payload['Amount'] = amount.toString();
      payload['meterNumber'] = meterNumber;

      if (customMessage != null) {
        payload['CustomerSMS'] = customMessage;
      }

      if (contact.startsWith('07')) {
        payload['TargetMobile'] = contact;
      }

      _log('zesa recharge payload: $payload', LOG_LEVEL.INFO);

      String url = _ROOT_ENDPOINT + _API_VERSION + _RECHARGE_ZESA;

      _headers.remove('Content-type');

      var response = await http.post(
        url,
        body: payload,
        headers: this._headers,
      );

      _headers['Content-type'] = _MIME_TYPES;

      var data = jsonDecode(response.body);

      _log('zesa recharge response: $data', LOG_LEVEL.DEBUG);

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

      _log(data, LOG_LEVEL.WARNING);

      return ApiResponse(
        message: 'zesa recharge failed',
        statusresponse: RECHARGERESPONSE.API_ERROR,
        apiResponse: data,
      );
    }

    // error
    catch (e) {
      _log(e, LOG_LEVEL.ERROR);

      return ApiResponse(
        statusresponse: RECHARGERESPONSE.ERROR,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse> queryZesaTransaction(String rechargeId) async {
    _autoUpdateReference();

    _log('making request for: query zesa transaction', LOG_LEVEL.INFO);

    try {
      String url = _ROOT_ENDPOINT + _API_VERSION + _QUERY_ZESA;

      _headers.remove('Content-type');

      var response = await http.post(
        url,
        body: {"RechargeId": rechargeId},
        headers: this._headers,
      );

      var data = jsonDecode(response.body);

      _headers['Content-type'] = _MIME_TYPES;

      _log('query zesa transaction response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == '2') {
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
      _log(e, LOG_LEVEL.ERROR);

      return ApiResponse(
        statusresponse: RECHARGERESPONSE.ERROR,
        message: e.toString(),
      );
    }
  }
}
