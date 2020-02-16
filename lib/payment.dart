import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:stripe_payment/stripe_payment.dart';

class PaymentPage extends StatefulWidget {
  String documentID;
  String userId;
  PaymentPage({this.documentID,this.userId});
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // StripePayment.setOptions(StripeOptions(
    //     publishableKey: "pk_test_FkOMrG0E6NTE8Tja09b0NYEw00ESmyOm7X",
    //     merchantId: "Test",
    //     androidPayMode: "test"));
  }

  _launchURL() async {
  const url = 'https://sandbox.payhere.lk/pay/oa2605079';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(
          "Payment",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: FlatButton(
          child: Text("Add Card"),
          onPressed: () {
            _launchURL();
          },
        ),
      ),
    );
  }
}
