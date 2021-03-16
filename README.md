# [Hot Recharge](https://ssl.hot.co.zw/)
perform airtime topup across all networks, vouchers and zesa recharge with hot-recharge flutter plugin

- ℹ Not an official hot-recharge flutter plugin
- a flutter plugin port of [hot-recharge python library](https://pypi.org/project/hot-recharge/) and [hot-recharge node package](https://www.npmjs.com/package/hotrecharge)

## screenshots
![mobile-topup](https://raw.githubusercontent.com/DonnC/hot-recharge-flutter/main/Docs/demo.gif)

## Plugin installation
- add latest version of `hot_recharge` to your `pubspec.yaml` file
```yaml
dependencies:
  flutter:
    sdk: flutter

  hot_recharge:
```

## Sign Up
- needs a hot recharge co-operate account, sign up [here](https://ssl.hot.co.zw/register.aspx)
- or contact hot-recharge for a proper account
- ![sign up](https://raw.githubusercontent.com/DonnC/hot-recharge-flutter/main/Docs/images/signup_cooperate.png)

## Authentication keys
- `accessCode` := the email address used on registration
- `accessPswd` := the password of the account used on registration
  
```dart
// import hot-recharge plugin
import 'package:hot_recharge/hot_recharge.dart';

// create api instance
hotRecharge = HotRecharge(
    accessCode: '<your-email>', 
    accessPswd: '<your-pwd>',
    enableLogger: false, // flag to true to enable detailed log while testing, use while testing ONLY
);
```

## Features
- [✔]  perfom airtime topup
- [✔]  perfom zesa recharge
- [✔]  query airtime topup transaction
- [✔]  query zesa transaction
- [✔]  get account airtime balance
- [✔]  get account zesa balance
- [✔]  check zesa customer
- [❌] perform evd transaction
- [❌] perform bundle topup
- `(...)` and more

## Performing requests
- all requests returns an instance of `ApiResponse` response model
- this shows how to perform api requests to hot-recharge services

#### topup number
```dart
// supports both mobile and '08xxxx...' numbers
final bal = await hotRecharge.topupNumber(1.50, '07xxxxxx');

// check response status
if (bal.rechargeResponse == RechargeResponse.SUCCESS) {
      final PinlessRecharge result = bal.apiResponse;
      showSnackbar(message: result.replyMsg);
    }

    // there was a problem
    else {
      showSnackbar(message: 'failed to sent airtime: ${bal.message}');
    }

```
#### query transaction
```dart
// query a previous transaction agent reference for reconcilliation
final result = await hotRecharge.queryTopupTransaction('previous-agent-reference');

print(result);

```

#### Custom messages
- the api supports sending `OPTIONAL` custom messages to the user as confirmation messages
- you can customize how the message will arrive like on the client | user side
- certain placeholders have to be used and total message length should be less than 150 chars
- --
- **For airtime topup**
  
custom Message place holders to use and their representation on end user:
-  `%AMOUNT% - $xxx.xx`
-  `%INITIALBALANCE% - $xxx.xx`
- `%FINALBALANCE% - $xxx.xx`
-  `%TXT% - xxx texts`
-  `%DATA% - xxx MB`
-  `%COMPANYNAME% - as defined by Customer on the website www.hot.co.zw`
-  `%ACCESSNAME% - defined by Customer on website – Teller or Trusted User or branch name`
  `

- example
  ```dart
  final mesg = 'Recharge of \$ %AMOUNT% is successful.\nThe best %COMPANYNAME%!';

  var response = await hotRecharge.topupNumber(
      2.0,
      '07xxxxxxxx',
      customMessage: mesg,
    );

  print(response);
   ```
---
- **For zesa transactions**
  
custom Message place holders to use and their representation on end user:
- `%AMOUNT% - $xxx.xx`
- `%KWH% - Unit in Kilowatt Hours(Kwh)`
- `%ACOUNTNAME% - Account holdername of meter number`
- `%METERNUMBER% - meter number`
- `%COMPANYNAME% - as defined by Customer on the website www.hot.co.zw`



## Note on Zesa Recharges
### Requirements 
- A method  for Purchasing ZESA Tokens 
- It is a ZESA requirement that any purchase must be **verified**. As such please ensure that you use the `checkCustomerDetail()` method 
```dart
    final result = await api.checkZesaCustomer(meterNumber);

    // check response status
    if (result.rechargeResponse == RechargeResponse.SUCCESS) {
        ZesaCustomerDetail details = result.apiResponse;
        var customerInfo = details.customerInfo;

        // prompt for user to verify info obtained from api
        zesaUserPromptDialog(message: customerInfo.customerName);
    }

    // there was a problem
    else {
      showSnackbar(message: 'failed to check zesa user: ${result.message}');
    }
  ```

- and prompt the customer to confirm the details **before** calling this method (`api.rechargeZesa(...)`). 
- There is a new transaction state specifically for ZESA that is Pending verification indicated by **reply code 4** (`RechargeResponse.PENDING`). Transactions in this state can result in successful transactions after a period of time once ZESA complete transaction.
- You must call Query ZESA method (`api.queryZesaTransaction(...)`) periodically until a permanent resolution of the transaction occurs. This polling of a pending transaction should not exceed more that **4 request a minute**. Resending of transactions that have not yet failed can result in the duplication of transaction and lose of funds. 
- Please note ZESA does not allow *refunds* so the cost of any errors cannot be recovered. 


## Support 🤿
- A little support can go a long way
- For general questions and discussions please make use of [github discussions here](https://github.com/DonnC/hot-recharge-flutter/discussions)
- You can help by making `PR` on any changes you would like to contribute to
- `Fork` or `star` this repo, it will help us lot 

- `With 💙 from FlutterDevZW ` by [@DonnC](https://github.com/DonnC) & [@iamngoni](https://github.com/iamngoni)

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
