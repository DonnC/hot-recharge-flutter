// example
import 'package:hot_recharge/hot_recharge.dart';

void main() async {
  print('=== making hot-recharge services ===');

  final api = HotRecharge(
    accessCode: '',
    accessPswd: '',
  );

  final bal = await api.topupWalletBalance();

  print(bal.apiResponse);
  print(bal.message);
  print(bal.statusresponse);

  print('=== done ===');
}
