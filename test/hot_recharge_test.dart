import 'package:flutter_test/flutter_test.dart';

import 'package:hot_recharge/hot_recharge.dart';

void main() async {
  test('get topup wallet balance: return ApiResponse instance', () async {
    final api = HotRecharge(
      accessCode: '',
      accessPswd: '',
    );

    final bal = await api.topupWalletBalance();

    print(bal.apiResponse);
    print(bal.message);
    print(bal.statusresponse);

    expect(bal, isInstanceOf<ApiResponse>());
  });
}
