import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_fix/home1.dart';
import 'package:easy_fix/providers/user_provider.dart';
import 'package:easy_fix/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

//  import 'package:famguard/ui/signup.dart';
void main() {
  runApp(MyApp());
  return;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _phoneNumber;
  _MyAppState() {
    UserProvider.getPhoneNumber().then((number) {
      if (number != null) {
        setState(() {
          _phoneNumber = number;
          print("NUmber ${_phoneNumber}");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _phoneNumber == null ? new FirstlogPage() : HomePage(),
      theme: new ThemeData(primarySwatch: Colors.blue),
    );
  }
}

class FirstlogPage extends StatefulWidget {
  @override
  _FirstlogPageState createState() => _FirstlogPageState();
}

class _FirstlogPageState extends State<FirstlogPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _editingController = TextEditingController();
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    final phonefeild = TextFormField(
      keyboardType: TextInputType.number,
      style: style,
      controller: _editingController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter Your Mobile Number",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final next = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          setState(() {
            _isSigningIn = true;
          });

          String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
          RegExp regExp = new RegExp(patttern);
          if (!regExp.hasMatch(_editingController.text)) {
            Alert(
              context: context,
              title: "Phone number invalid!",
              desc: "Enter a valid phone number!",
              type: AlertType.warning,
            ).show();
            setState(() {
              _isSigningIn = false;
            });
            return;
          }
          var userDoc = await Firestore.instance
              .collection("users")
              .document(_editingController.text)
              .get();

          if (userDoc.exists) {
            Alert(
              context: context,
              title: "User exits",
              desc: "A user already exist for this phone number! try again !!",
              type: AlertType.error,
            ).show();
            setState(() {
              _isSigningIn = false;
            });
            return;
          }

          Firestore.instance
              .collection("users")
              .document(_editingController.text)
              .setData({"keyphone": _editingController.text}).then((_) {
            setState(() {
              _isSigningIn = false;
            });
            UserProvider.savePhoneNumber(_editingController.text);
            print("completed");
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SignupPage(phoneNumber: _editingController.text)));
          }).catchError((err) {
            setState(() {
              _isSigningIn = false;
            });
            print(err);
          });
        },
        child: Text(
          "Next",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return new Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _isSigningIn ? LinearProgressIndicator() : SizedBox.shrink(),
                Spacer(),
                Image.asset(
                  "assets/logo.jpg",
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20.0),
                phonefeild,
                SizedBox(
                  height: 40.0,
                ),
                next,
                Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
