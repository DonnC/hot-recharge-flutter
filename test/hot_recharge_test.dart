import 'package:flutter_test/flutter_test.dart';

import 'package:hot_recharge/hot_recharge.dart';

void main() async {
  // create object
  final api = HotRecharge(
    accessCode: '',
    accessPswd: '',
    enableLogger: true,
  );

  test('get topup wallet balance: return ApiResponse instance', () async {
    final bal = await api.topupWalletBalance();

    print(bal.apiResponse);
    print(bal.message);
    print(bal.statusresponse);

    expect(bal, isInstanceOf<ApiResponse>());
  });

  test('get zesa wallet balance: return ApiResponse instance', () async {
    final bal = await api.zesaWalletBalance();

    print(bal.apiResponse);
    print(bal.message);
    print(bal.statusresponse);

    expect(bal, isInstanceOf<ApiResponse>());
  });

  // TODO: Run once to save account balance
  test('topup user account : return ApiResponse instance', () async {
    final bal = await api.topupNumber(1.50, '07xxxxxxxx');

    print(bal.apiResponse);
    print(bal.message);
    print(bal.statusresponse);

    expect(bal, isInstanceOf<ApiResponse>());
  });

  test('query topup transaction ref : return ApiResponse instance', () async {
    final bal = await api
        .queryTopupTransaction('<previous-query-transaction-agent-ref>');

    print(bal.apiResponse);
    print(bal.message);
    print(bal.statusresponse);

    expect(bal, isInstanceOf<ApiResponse>());
  });
}
