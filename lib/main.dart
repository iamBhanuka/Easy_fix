import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_fix/home1.dart';
import 'package:easy_fix/providers/user_provider.dart';
import 'package:easy_fix/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:easy_fix/logfirst.dart';
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
  TextEditingController _phoneNumber = TextEditingController();
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    final phonefeild = TextFormField(
      keyboardType: TextInputType.number,
      style: style,
      controller: _phoneNumber,
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
          if (!regExp.hasMatch(_phoneNumber.text)) {
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
              .collection("users").where("phoneNumber",isEqualTo: _phoneNumber.text)
              .getDocuments();

          if (userDoc.documents.length > 0) {
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
              .add({"phoneNumber": _phoneNumber.text}).then((doc) {
            setState(() {
              _isSigningIn = false;
            });
            UserProvider.savePhoneNumber(_phoneNumber.text);
            print("completed");
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SignupPage(userDoc: doc.documentID)));
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
            
            child: ListView(
                          children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _isSigningIn ? LinearProgressIndicator() : SizedBox.shrink(),
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
                    SizedBox(height: 30,),
                    InkWell(child: Text("If you have a account click hear....!!",textAlign: TextAlign.center,style: TextStyle(fontSize: 22,color: Colors.blue),),onTap: () {
                     Navigator.pop(context);
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage()));
                    },),
                    
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
