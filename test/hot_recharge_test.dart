import 'package:flutter_test/flutter_test.dart';

import 'package:hot_recharge/hot_recharge.dart';

void main() async {
  // create hot-recharge api object
  final api = HotRecharge(
    accessCode: '',
    accessPswd: '',
    enableLogger: true,
  );

  // test variables here
  // TODO: replace with your actual testing variables
  String meterNumber = '';
  String topupRefNumber = '';
  String numberToSentZesaToken = '';
  String numberToTopup = '';
  int zesaRechargeId = 0000000;
  double zesaAmount = 50;
  double topupAmount = 1.50;

  // TODO: Create a more refined test suite

  group('Hot-Recharge: Airtime', () {
    test('get topup wallet balance: return ApiResponse instance', () async {
      final bal = await api.topupWalletBalance();

      print(bal.apiResponse);
      print(bal.message);
      print(bal.rechargeResponse);

      expect(bal, isInstanceOf<ApiResponse>());
    });

// TODO: Run this wisely (maybe once | twice with minimum amount) to save your testing account balance
    test('topup user account : return ApiResponse instance', () async {
      final bal = await api.topupNumber(topupAmount, numberToTopup);

      print(bal.apiResponse);
      print(bal.message);
      print(bal.rechargeResponse);

      expect(bal, isInstanceOf<ApiResponse>());
    });

    test('query topup transaction ref : return ApiResponse instance', () async {
      final bal = await api.queryTopupTransaction(topupRefNumber);

      print(bal.apiResponse);
      print(bal.message);
      print(bal.rechargeResponse);

      expect(bal, isInstanceOf<ApiResponse>());
    });
  });

  group('Hot-Recharge: Zesa', () {
    test('get zesa wallet balance: return ApiResponse instance', () async {
      final bal = await api.zesaWalletBalance();

      print(bal.apiResponse);
      print(bal.message);
      print(bal.rechargeResponse);

      expect(bal, isInstanceOf<ApiResponse>());
    });

    test('check zesa customer: return ApiResponse instance', () async {
      final bal = await api.checkZesaCustomer(meterNumber);

      print(bal.apiResponse);
      print(bal.message);
      print(bal.rechargeResponse);

      expect(bal, isInstanceOf<ApiResponse>());
    });

    test('query zesa transaction ref : return ApiResponse instance', () async {
      final bal = await api.queryZesaTransaction(zesaRechargeId);

      print(bal.apiResponse);
      print(bal.message);
      print(bal.rechargeResponse);

      expect(bal, isInstanceOf<ApiResponse>());
    });

    // TODO: Run this wisely (maybe once | twice with minimum amount) to save your testing zesa account balance
    test('recharge zesa: return ApiResponse instance', () async {
      final message =
          'Recharge of \$ %AMOUNT% is successful.\nUnits %KWH% Kwh recharged for meter %METERNUMBER% of %ACOUNTNAME%.\nThe best %COMPANYNAME%!';

      // minimum zesa recharge as of this test was $20 from the api response but actual minimum is $50
      final bal = await api.rechargeZesa(
        zesaAmount,
        numberToSentZesaToken,
        meterNumber,
        customMessage: message,
      );

      print(bal.apiResponse);
      print(bal.message);
      print(bal.rechargeResponse);

      expect(bal, isInstanceOf<ApiResponse>());
    });
  });

  test('End-user Airtime Balance : return ApiResponse instance', () async {
    final bal = await api.endUserBalance(numberToTopup);

    print(bal.apiResponse);
    print(bal.message);
    print(bal.rechargeResponse);

    expect(bal, isInstanceOf<ApiResponse>());
  });
}
