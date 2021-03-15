import 'package:flutter_test/flutter_test.dart';

import 'package:hot_recharge/hot_recharge.dart';

void main() async {
  test('get topup wallet balance: return ApiResponse instance', () async {
    final api = HotRecharge(
      accessCode: 'imngonii@gmail.com',
      accessPswd: 'Nickm@ng13',
    );

    final bal = await api.endUserBalance("0777213388");

    expect(bal, isInstanceOf<ApiResponse>());
  });
}
