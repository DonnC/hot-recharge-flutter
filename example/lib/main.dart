import 'package:flutter/material.dart';

import 'package:hot_recharge/hot_recharge.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HR Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Hot-Recharge Plugin Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController amountController;
  TextEditingController phoneController;
  HotRecharge hotRecharge;

  bool loading = false;

  // can add custom message to sent to user
  final mesg =
      'Recharge of \$ %AMOUNT% is successful.\nThe best %COMPANYNAME%!';

  @override
  void initState() {
    setupHR();
    amountController = TextEditingController();
    phoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void showSnackbar(String message, Color color) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message),
      ),
    );
  }

  void setupHR() {
    hotRecharge = HotRecharge(
      accessCode: '<your-acc-email>',
      accessPswd: '<your-acc-pswd>',
      //enableLogger: true, // enable detailed request logger on console. Use while TESTING only
    );
  }

  Future<void> rechargeNumber() async {
    setState(() {
      loading = true;
    });

    var response = await hotRecharge.topupNumber(
      double.parse(amountController.text),
      phoneController.text,
      customMessage: mesg,
    );

    if (response.rechargeResponse == RechargeResponse.SUCCESS) {
      final PinlessRecharge result = response.apiResponse;
      showSnackbar(result.replyMsg, Colors.green);
    }

    // there was a problem
    else {
      showSnackbar('failed to sent airtime: ${response.message}', Colors.red);
    }

    setState(() {
      loading = false;
      phoneController.clear();
      amountController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Number to recharge',
                hintText: '07xxxxxx.. or 08xxxxx..',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Amount to recharge',
              ),
            ),
            SizedBox(height: 30),
            loading
                ? CircularProgressIndicator()
                : Container(
                  color: Colors.blue,
                  child: TextButton(
                      onPressed: () async => await rechargeNumber(),
                      child: Text(
                        'Recharge',
                      ),
                    ),
                ),
          ],
        ),
      ),
    );
  }
}
