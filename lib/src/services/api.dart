import 'dart:async';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../../hot_recharge.dart';
import '../utils.dart';

class Api {
  static const String _ROOT_ENDPOINT = "https://ssl.hot.co.zw";
  static const String _API_VERSION = "/api/v1/";
  static const String _MIME_TYPES = "application/json";

  // endpoints definition
  static const String _RECHARGE_PINLESS = "agents/recharge-pinless";
  static const String _QUERY_EVD = "agents/query-evd";
  static const String _GET_DATA_BUNDLES = "agents/get-data-bundles";
  static const String _RECHARGE_BUNDLE = "agents/recharge-data";
  static const String _RECHARGE_ZESA = "agents/recharge-zesa";
  static const String _WALLET_BALANCE = "agents/wallet-balance";
  static const String _ZESA_BALANCE = 'agents/wallet-balance-zesa';
  static const String _CHECK_ZESA_CUSTOMER = "agents/check-customer-zesa";
  static const String _QUERY_TRANSACTION =
      "agents/query-transaction?agentReference=";
  static const String _QUERY_ZESA = "agents/query-zesa-transaction";
  static const String _RECHARGE_EVD = "agents/recharge-evd";
  static const String _BULK_RECHARGE_EVD = "agents/bulk-evd";

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

  Future<ApiResponse> getDataBundles() async {
    _autoUpdateReference();

    _log('making request for: get data bundles', LOG_LEVEL.INFO);

    try {
      String url = _ROOT_ENDPOINT + _API_VERSION + _GET_DATA_BUNDLES;

      var response = await http.get(
        url,
        headers: this._headers,
      );

      var data = jsonDecode(response.body) as Map;

      _log('raw data bundles response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == 2) {
        // success
        DataBundles db = DataBundles.fromMap(data);

        return ApiResponse(
          message: 'data bundle success',
          rechargeResponse: RechargeResponse.SUCCESS,
          apiResponse: db,
        );
      }

      _log(data, LOG_LEVEL.WARNING);

      return ApiResponse(
        message: data.containsKey('ReplyMessage')
            ? data['ReplyMessage']
            : 'get data bundles failed',
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

  Future<ApiResponse> queryEVD() async {
    _autoUpdateReference();

    _log('making request for: query evd', LOG_LEVEL.INFO);

    try {
      String url = _ROOT_ENDPOINT + _API_VERSION + _QUERY_EVD;

      var response = await http.get(
        url,
        headers: this._headers,
      );

      var data = jsonDecode(response.body) as Map;

      _log('raw query evd response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == 2) {
        // success
        QueryEvd qe = QueryEvd.fromMap(data);

        return ApiResponse(
          message: 'query evd success',
          rechargeResponse: RechargeResponse.SUCCESS,
          apiResponse: qe,
        );
      }

      _log(data, LOG_LEVEL.WARNING);

      return ApiResponse(
        message: data.containsKey('ReplyMessage')
            ? data['ReplyMessage']
            : 'query evd failed',
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

  // TODO: Not tested
  Future<ApiResponse> _bulkPurchaseEvd(
    int brandID,
    double pinValue,
    int quantity,
  ) async {
    _autoUpdateReference();

    _log('making request for: bulkd evd recharge', LOG_LEVEL.INFO);

    try {
      Map<String, dynamic> payload = Map<String, dynamic>();

      payload['BrandID'] = brandID.toString();
      payload['Denomination'] = pinValue.toString();
      payload['Quantity'] = quantity.toString();

      _log('bulk evd recharge payload: $payload', LOG_LEVEL.INFO);

      String url = _ROOT_ENDPOINT + _API_VERSION + _BULK_RECHARGE_EVD;

      //_headers.remove('Content-type');

      var response = await http.post(
        url,
        body: payload,
        headers: this._headers,
      );

      //_headers['Content-type'] = _MIME_TYPES;

      var data = jsonDecode(response.body) as Map;

      _log('bulk evd recharge response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == 2) {
        // success
        //BundleRecharge br = BundleRecharge.fromJson(response.body);

        return ApiResponse(
          message: 'bulk evd recharge success',
          rechargeResponse: RechargeResponse.SUCCESS,
          apiResponse: response.body,
        );
      }

      _log(data, LOG_LEVEL.WARNING);

      return ApiResponse(
        message: data.containsKey('ReplyMessage')
            ? data['ReplyMessage']
            : 'bulk evd recharge failed',
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

  Future<ApiResponse> rechargeEvd(
    int brandID,
    double pinValue, // Denomination
    String contact,
    int quantity,
  ) async {
    _autoUpdateReference();

    _log('making request for: evd recharge', LOG_LEVEL.INFO);

    try {
      Map<String, dynamic> payload = Map<String, dynamic>();

      payload['BrandID'] = brandID.toString();
      payload['TargetNumber'] = contact;
      payload['Denomination'] = pinValue.toString();
      payload['Quantity'] = quantity.toString();

      _log('evd recharge payload: $payload', LOG_LEVEL.INFO);

      String url = _ROOT_ENDPOINT + _API_VERSION + _RECHARGE_EVD;

      //_headers.remove('Content-type');
      var request = http.Request('POST', Uri.parse(url))
        ..body = jsonEncode(payload)
        ..headers.addAll(this._headers);

      var response = await request.send();

      //var response = await http.post(
      //  url,
      //  body: payload,
      //  headers: this._headers,
      //);
      //

      if (response.statusCode == 200) {
        var _body = await response.stream.bytesToString();

        //_headers['Content-type'] = _MIME_TYPES;

        var data = jsonDecode(_body) as Map;

        _log('evd recharge response: $data', LOG_LEVEL.DEBUG);

        if (data['ReplyCode'] == 2) {
          // success
          RechargeEvd re = RechargeEvd.fromMap(data);

          return ApiResponse(
            message: 'evd recharge success',
            rechargeResponse: RechargeResponse.SUCCESS,
            apiResponse: re,
          );
        }

        _log(data, LOG_LEVEL.WARNING);

        return ApiResponse(
          message: data.containsKey('ReplyMessage')
              ? data['ReplyMessage']
              : 'evd recharge failed',
          rechargeResponse: RechargeResponse.API_ERROR,
          apiResponse: data,
        );
      }

      // raise exception
      else {
        throw Exception(response.reasonPhrase);
      }
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

  Future<ApiResponse> rechargeBundle(
    String productCode,
    String contact, {

    /// value of the bundle (optional)
    int amount,
    String customMessage,
  }) async {
    _autoUpdateReference();

    _log('making request for: bundle recharge', LOG_LEVEL.INFO);

    try {
      Map<String, dynamic> payload = Map<String, dynamic>();

      payload['ProductCode'] = productCode;

      // optional, use product code instead
      //payload['Amount'] = amount.toString();

      if (customMessage != null) {
        payload['CustomerSMS'] = customMessage;
      }

      // 07xxxxx | 086xxxxx
      if (contact.startsWith('07') || contact.startsWith('08')) {
        payload['TargetMobile'] = contact;
      }

      _log('data recharge payload: $payload', LOG_LEVEL.INFO);

      String url = _ROOT_ENDPOINT + _API_VERSION + _RECHARGE_BUNDLE;

      _headers.remove('Content-type');

      var response = await http.post(
        url,
        body: payload,
        headers: this._headers,
      );

      _headers['Content-type'] = _MIME_TYPES;

      var data = jsonDecode(response.body) as Map;

      _log('data recharge response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == 2) {
        // success
        BundleRecharge br = BundleRecharge.fromJson(response.body);

        return ApiResponse(
          message: 'bundle recharge success',
          rechargeResponse: RechargeResponse.SUCCESS,
          apiResponse: br,
        );
      }

      _log(data, LOG_LEVEL.WARNING);

      return ApiResponse(
        message: data.containsKey('ReplyMessage')
            ? data['ReplyMessage']
            : 'bundle recharge failed',
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

  Future<ApiResponse> getWalletBalance() async {
    _autoUpdateReference();

    _log('making request for: topup wallet balance', LOG_LEVEL.INFO);

    try {
      String url = _ROOT_ENDPOINT + _API_VERSION + _WALLET_BALANCE;

      var response = await http.get(
        url,
        headers: this._headers,
      );

      var data = jsonDecode(response.body) as Map;

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

      var response = await http.get(
        url,
        headers: this._headers,
      );

      var data = jsonDecode(response.body) as Map;

      _log('zesa wallet balance response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == 2) {
        // success
        ZesaWalletBalance zb = ZesaWalletBalance.fromJson(response.body);

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

      var response = await http.get(
        url,
        headers: this._headers,
      );

      var data = jsonDecode(response.body) as Map;

      _log('query topup transaction response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == '2') {
        // success
        QueryTransaction qt = QueryTransaction.fromJson(response.body);

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

      var data = jsonDecode(response.body) as Map;

      _log('topup number response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == 2) {
        // success
        PinlessRecharge pr = PinlessRecharge.fromJson(response.body);

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

      var response = await http.post(
        url,
        body: {
          'MeterNumber': meterNumber,
        },
        headers: this._headers,
      );

      _headers['Content-type'] = _MIME_TYPES;

      var data = jsonDecode(response.body) as Map;

      _log('query zesa customer response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == 2) {
        // success
        ZesaCustomerDetail zcd = ZesaCustomerDetail.fromJson(response.body);

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
      Map<String, dynamic> payload = Map<String, dynamic>();

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

      var response = await http.post(
        url,
        body: payload,
        headers: this._headers,
      );

      _headers['Content-type'] = _MIME_TYPES;

      var data = jsonDecode(response.body) as Map;

      _log('zesa recharge response: $data', LOG_LEVEL.DEBUG);

      if (data['ReplyCode'] == 2) {
        // success
        ZesaRecharge zr = ZesaRecharge.fromJson(response.body);

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

      var response = await http.post(
        url,
        body: {"RechargeId": rechargeId.toString()},
        headers: this._headers,
      );

      var data = jsonDecode(response.body) as Map;

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
