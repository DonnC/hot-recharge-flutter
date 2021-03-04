# [Hot Recharge](https://ssl.hot.co.zw/)
perform airtime topup across all networks, vouchers and zesa recharge with hot-recharge flutter plugin

- ℹ Not an official hot-recharge flutter plugin
- a flutter plugin port of [hot-recharge python library]()

## Plugin installation
- add hotrecharge to your `pubspec.yaml` file
```yaml
dependencies:
  flutter:
    sdk: flutter

  hot_recharge: any
```

## [CHANGELOG](CHANGELOG.md)
please see full [changelog here](CHANGELOG.md)

## Sign Up
- needs a hot recharge co-operate account, sign up [here](https://ssl.hot.co.zw/register.aspx)
- ![sign up](https://github.com/DonnC/Hot-Recharge-ZW/raw/master/Docs/images/signup_cooperate.png)

## Authentication keys
- `accessCode` := the email address used on registration
- `accessPswd` := the password of the account used on registration
  
```dart
// import hot-recharge plugin
import 'package:hot_recharge/hot_recharge.dart';

// create api instance
api = HotRecharge(accessCode: '<your-email>', accessPswd: '<your-pwd>');
```

## Performing requests
- this shows how to perform api requests to hot-recharge services
```dart
import hotrecharge
import pprint

api = hotrecharge.HotRecharge(headers=credentials)

try:
    # get wallet balance
    wallet_bal_response = api.walletBalance()

    # get end user balance
    end_user_bal_resp = api.endUserBalance(mobile_number='077xxxxxxx')

    # get data bundles
    data_bundles_resp = api.getDataBundles()

    print("Wallet Balance: ")
    pprint.pprint(wallet_bal_response)

    print("End User Balance: ")
    pprint.pprint(end_user_bal_resp)

    print("Data Bundles Balance: ")
    pprint.pprint(data_bundles_resp)

except Exception as ex:
    print(f"There was a problem: {ex}")
```
-
# Recharge
## Recharge data bundles
- use bundle product code
- an optional customer sms can be send together upon request
- Place holders used include
```
%AMOUNT% 	    $XXX.XX
%COMPANYNAME%	As Defined by Customer on the website www.hot.co.zw
%ACCESSNAME%	Defined by Customer on website – Teller or Trusted User or branch name
%BUNDLE%	    Name of the Data Bundle
```
```python
import hotrecharge
from pprint import pprint

# you can opt to update the reference code manually 
# by setting `use_random_ref` to False
api = hotrecharge.HotRecharge(headers=credentials, use_random_ref=False)

try:

    # option message to send to user
    customer_sms =  " Amount of %AMOUNT% for data %BUNDLE% recharged! " \
                    " %ACCESSNAME%. The best %COMPANYNAME%!"

    # need to update reference manually, if `use_random_ref` is set to False
    api.updateReference('<new-random-string>')

    response = api.dataBundleRecharge(product_code="<bundle-product-code>", number="071xxxxxxx", mesg=customer_sms)

    pprint(response)

except Exception as ex:
    print(f"There was a problem: {ex}")
```

### Recharge pinless
```python
import hotrecharge

api = hotrecharge.HotRecharge(headers=credentials)

try:
    customer_sms = "Recharge of %AMOUNT% successful" \
                   "Initial balance $%INITIALBALANCE%" \
                   "Final Balance $%FINALBALANCE%" \
                   "%COMPANYNAME%"

    response = api.rechargePinless(amount=3.5, number="077xxxxxxx", mesg=customer_sms)

    print(response)

except Exception as ex:
    print(f"There was a problem: {ex}")
```

# New in `v1.3.0`✨
- fully implemented method parameters e.g `brandID` and `mesg` for customerSMS on api method calls
### Query transaction
- You can now query a previous transaction by its `agentReference` for reconciliation. 
- It is reccommended to query within the last 30 days of the transaction
```python
import hotrecharge

api = hotrecharge.HotRecharge(headers=credentials)

try:
    response = api.rechargePinless(amount=3.5, number="077xxxxxxx")

    # save agentReference to query for reconciliation
    prevTransactionAgentReference = response.get("agentReference")

    result = api.queryTransactionReference(prevTransactionAgentReference)

    print(response, result)

except Exception as ex:
    print(f"There was a problem: {ex}")
```

## Support 🤿
- A little support can go a long way
- You can help by making `PR` on any changes you would like to contribute to
- `Fork` or `star` this repo, it will help a lot 



## Note on Zesa Recharges
### Requirements 
A method  for Purchasing ZESA Tokens 
• It is a ZESA requirement that any purchase must be verified. As such please ensure that you use the `check customer details` method and prompt the customer to confirm the details before calling this method. 
• There is a new transaction state specifically for ZESA that is Pending verification indicated by reply code 4. Transactions in this state can result in successful transactions after a period of time once ZESA complete transaction. API Users must call Query ZESA method periodically until a permanent resolution of the transaction occurs. This polling of a pending transaction should not exceed more that 4 request a minute. Resending of transactions that have not yet failed can result in the duplication of transaction and lose of funds. 
Please note ZESA does not allow refunds so the cost of any errors cannot be recovered. 

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
