import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import '../../hot_recharge.dart';

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
  static const String _END_USER_BALANCE =
      "agents/enduser-balance?targetmobile=";

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  final String email;
  final String pswd;
  final bool enableLogger;

  final Dio _dio = Dio();

  Map<String, String> _headers;

  Api({
    this.email,
    this.pswd,
    this.enableLogger,
  }) {
    _buildHeaders();
    _log('api service initialised', LOG_LEVEL.INFO);
  }

  /// auto generate agent-reference using uuid v4 chunk
  String _generateReference() {
    const uuid = Uuid();
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
      'x-access-code': email,
      'x-access-password': pswd,
      'x-agent-reference': _generateReference(),
      'Content-type': _MIME_TYPES,
      'cache-control': "no-cache",
    };
  }

  /// update x-agent-reference automatically
  /// api requires that each request have a unique agent-reference
  void _autoUpdateReference() {
    _headers.update(
      'x-agent-reference',
      (value) => _generateReference(),
    );
  }

  Future<ApiResponse> getWalletBalance() async {
    _autoUpdateReference();

    _log('making request for: topup wallet balance', LOG_LEVEL.INFO);

    try {
      String url = _ROOT_ENDPOINT + _API_VERSION + _WALLET_BALANCE;

      Response response = await _dio.get(
        url,
        options: Options(
          headers: _headers,
        ),
      );

      var data = response.data;

      _log('raw topup wallet balance response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == 2) {
        // success
        WalletBalance wb = WalletBalance.fromMap(data);

        return ApiResponse(
          message: 'wallet balance success',
          rechargeResponse: RechargeResponse.SUCCESS,
          apiResponse: wb,
        );
      }

      _log(data, LOG_LEVEL.WARNING);

      return ApiResponse(
        message: data.containsKey('ReplyMessage')
            ? data['ReplyMessage']
            : 'wallet balance failed',
        rechargeResponse: RechargeResponse.API_ERROR,
        apiResponse: data,
      );
    }

    // error
    catch (e) {
      _log(e, LOG_LEVEL.ERROR);

      return ApiResponse(
        rechargeResponse: RechargeResponse.ERROR,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse> getZesaWalletBalance() async {
    _autoUpdateReference();

    _log('making request for: zesa wallet balance', LOG_LEVEL.INFO);

    try {
      String url = _ROOT_ENDPOINT + _API_VERSION + _ZESA_BALANCE;

      Response response = await _dio.get(
        url,
        options: Options(
          headers: _headers,
        ),
      );

      var data = response.data;

      _log('zesa wallet balance response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == 2) {
        // success
        ZesaWalletBalance zb = ZesaWalletBalance.fromJson(data);

        return ApiResponse(
          message: 'zesa wallet balance success',
          rechargeResponse: RechargeResponse.SUCCESS,
          apiResponse: zb,
        );
      }

      _log(data, LOG_LEVEL.WARNING);

      return ApiResponse(
        message: data.containsKey('ReplyMessage')
            ? data['ReplyMessage']
            : 'zesa wallet balance failed',
        rechargeResponse: RechargeResponse.API_ERROR,
        apiResponse: data,
      );
    }

    // error
    catch (e) {
      _log(e, LOG_LEVEL.ERROR);

      return ApiResponse(
        rechargeResponse: RechargeResponse.ERROR,
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

      Response response = await _dio.get(
        url,
        options: Options(
          headers: _headers,
        ),
      );

      var data = response.data;

      _log('query topup transaction response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == '2') {
        // success
        QueryTransaction qt = QueryTransaction.fromJson(data);

        return ApiResponse(
          message: 'query transaction success',
          rechargeResponse: RechargeResponse.SUCCESS,
          apiResponse: qt,
        );
      }

      _log(data, LOG_LEVEL.WARNING);

      return ApiResponse(
        message: data.containsKey('ReplyMessage')
            ? data['ReplyMessage']
            : 'query transaction failed',
        rechargeResponse: RechargeResponse.API_ERROR,
        apiResponse: data,
      );
    }

    // error
    catch (e) {
      _log(e, LOG_LEVEL.ERROR);

      return ApiResponse(
        rechargeResponse: RechargeResponse.ERROR,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse> rechargePinless(
    double amount,
    String contact, {
    String brandID,
    String customMessage,
  }) async {
    _autoUpdateReference();

    _log('making request for: topup number', LOG_LEVEL.INFO);

    try {
      Map<String, dynamic> payload = <String, dynamic>{};

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

      Response response = await _dio.post(
        url,
        data: payload,
        options: Options(
          headers: _headers,
        ),
      );

      _headers['Content-type'] = _MIME_TYPES;

      var data = response.data;

      _log('topup number response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == 2) {
        // success
        PinlessRecharge pr = PinlessRecharge.fromJson(data);

        return ApiResponse(
          message: 'recharge pinless success',
          rechargeResponse: RechargeResponse.SUCCESS,
          apiResponse: pr,
        );
      }

      _log(data, LOG_LEVEL.WARNING);

      return ApiResponse(
        message: data.containsKey('ReplyMessage')
            ? data['ReplyMessage']
            : 'pinless recharge failed',
        rechargeResponse: RechargeResponse.API_ERROR,
        apiResponse: data,
      );
    }

    // error
    catch (e) {
      _log(e, LOG_LEVEL.ERROR);

      return ApiResponse(
        rechargeResponse: RechargeResponse.ERROR,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse> checkZesaCustomer(String meterNumber) async {
    if (meterNumber.length != 11) {
      _log(
          'zesa meter number must be equal to 11 chars: `$meterNumber` [${meterNumber.length}]',
          LOG_LEVEL.ERROR);

      return ApiResponse(
        rechargeResponse: RechargeResponse.ERROR,
        message: 'zesa meter number passed not equal to required char of 11',
      );
    }

    _autoUpdateReference();

    _log('making request for: query zesa customer', LOG_LEVEL.INFO);

    try {
      String url = _ROOT_ENDPOINT + _API_VERSION + _CHECK_ZESA_CUSTOMER;

      _headers.remove('Content-type');

      Response response = await _dio.post(
        url,
        data: {
          'MeterNumber': meterNumber,
        },
        options: Options(
          headers: _headers,
        ),
      );

      _headers['Content-type'] = _MIME_TYPES;

      var data = response.data;

      _log('query zesa customer response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == 2) {
        // success
        ZesaCustomerDetail zcd = ZesaCustomerDetail.fromJson(data);

        return ApiResponse(
          message: 'check zesa customer success',
          rechargeResponse: RechargeResponse.SUCCESS,
          apiResponse: zcd,
        );
      }

      _log(data, LOG_LEVEL.WARNING);

      return ApiResponse(
        message: data.containsKey('ReplyMessage')
            ? data['ReplyMessage']
            : 'check zesa customer failed',
        rechargeResponse: RechargeResponse.API_ERROR,
        apiResponse: data,
      );
    }

    // error
    catch (e) {
      _log(e, LOG_LEVEL.ERROR);

      return ApiResponse(
        rechargeResponse: RechargeResponse.ERROR,
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
      Map<String, dynamic> payload = <String, dynamic>{};

      payload['Amount'] = amount.toString();
      payload['meterNumber'] = meterNumber;

      if (customMessage != null) {
        payload['CustomerSMS'] = customMessage;
      }

      if (contact.startsWith('07')) {
        payload['TargetNumber'] = contact;
      }

      _log('zesa recharge payload: $payload', LOG_LEVEL.INFO);

      String url = _ROOT_ENDPOINT + _API_VERSION + _RECHARGE_ZESA;

      _headers.remove('Content-type');

      Response response = await _dio.post(
        url,
        data: payload,
        options: Options(
          headers: _headers,
        ),
      );

      _headers['Content-type'] = _MIME_TYPES;

      var data = response.data;

      _log('zesa recharge response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == 2) {
        // success
        ZesaRecharge zr = ZesaRecharge.fromJson(data);

        return ApiResponse(
          message: 'zesa recharge success',
          rechargeResponse: RechargeResponse.SUCCESS,
          apiResponse: zr,
        );
      }

      if (data['ReplyCode'] == 4) {
        // pending zesa transaction
        return ApiResponse(
          message: 'zesa recharge pending',
          rechargeResponse: RechargeResponse.PENDING,
          apiResponse: data,
        );
      }

      _log(data, LOG_LEVEL.WARNING);

      return ApiResponse(
        message: data.containsKey('ReplyMessage')
            ? data['ReplyMessage']
            : 'zesa recharge failed',
        rechargeResponse: RechargeResponse.API_ERROR,
        apiResponse: data,
      );
    }

    // error
    catch (e) {
      _log(e, LOG_LEVEL.ERROR);

      return ApiResponse(
        rechargeResponse: RechargeResponse.ERROR,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse> queryZesaTransaction(int rechargeId) async {
    _autoUpdateReference();

    _log('making request for: query zesa transaction', LOG_LEVEL.INFO);

    try {
      String url = _ROOT_ENDPOINT + _API_VERSION + _QUERY_ZESA;

      _headers.remove('Content-type');

      Response response = await _dio.post(
        url,
        data: {"RechargeId": rechargeId.toString()},
        options: Options(
          headers: _headers,
        ),
      );

      var data = response.data;

      _headers['Content-type'] = _MIME_TYPES;

      _log('query zesa transaction response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == 2) {
        // success
        final QueryZesaTransaction qzt = QueryZesaTransaction.fromMap(data);

        return ApiResponse(
          message: 'query zesa transaction success',
          rechargeResponse: RechargeResponse.SUCCESS,
          apiResponse: qzt,
        );
      }

      return ApiResponse(
        message: data.containsKey('ReplyMessage')
            ? data['ReplyMessage']
            : 'query zesa transaction failed',
        rechargeResponse: RechargeResponse.API_ERROR,
        apiResponse: data,
      );
    }

    // error
    catch (e) {
      _log(e, LOG_LEVEL.ERROR);

      return ApiResponse(
        rechargeResponse: RechargeResponse.ERROR,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse> endUserBalance(String mobileNumber) async {
    _autoUpdateReference();

    if (mobileNumber.isEmpty) {
      _log(
        'Mobile number cannot be empty: $mobileNumber',
        LOG_LEVEL.ERROR,
      );
      return ApiResponse(
        message: 'Mobile number is required!',
        rechargeResponse: RechargeResponse.ERROR,
      );
    }
    try {
      String url =
          _ROOT_ENDPOINT + _API_VERSION + _END_USER_BALANCE + mobileNumber;
      Response response = await _dio.get(
        url,
        options: Options(
          headers: _headers,
        ),
      );

      var data = response.data;

      _log('End user airtime balance response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == 2) {
        EndUserBalance eub = EndUserBalance.fromMap(data);

        return ApiResponse(
          apiResponse: eub,
          message: 'Success!',
          rechargeResponse: RechargeResponse.SUCCESS,
        );
      }

      return ApiResponse(
        message: data.containsKey('ReplyMessage')
            ? data['ReplyMessage']
            : 'Retrieving balance failed',
        rechargeResponse: RechargeResponse.API_ERROR,
        apiResponse: data,
      );
    } catch (e) {
      _log(e, LOG_LEVEL.ERROR);
      return ApiResponse(
        rechargeResponse: RechargeResponse.ERROR,
        message: e.toString(),
      );
    }
  }
}

/// used internally when `enableLogger` is set to true
/// used to determine log level
enum LOG_LEVEL {
  DEBUG,
  INFO,
  ERROR,
  WARNING,
  WTF,
  LOG,
}
