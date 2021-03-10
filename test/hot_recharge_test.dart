import 'package:flutter_test/flutter_test.dart';

import 'package:hot_recharge/hot_recharge.dart';

void main() async {
  // create hot-recharge api object
  final api = HotRecharge(
    accessCode: '',
    accessPswd: '',
    enableLogger: true,
  );

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
      final bal = await api.topupNumber(1.50, '07xxxxxxxx');

      print(bal.apiResponse);
      print(bal.message);
      print(bal.rechargeResponse);

      expect(bal, isInstanceOf<ApiResponse>());
    });

    test('query topup transaction ref : return ApiResponse instance', () async {
      final bal = await api
          .queryTopupTransaction('<previous-query-transaction-agent-ref>');

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
      final bal = await api.checkZesaCustomer('your-11-char-meter-number');

      print(bal.apiResponse);
      print(bal.message);
      print(bal.rechargeResponse);

      expect(bal, isInstanceOf<ApiResponse>());
    });
  });
}
