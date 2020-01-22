import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_fix/main.dart';
import 'package:flutter/material.dart';
import 'package:easy_fix/home1.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginPage extends StatefulWidget {
  String phoneNumber;
  LoginPage({this.phoneNumber});
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _editingController1 = TextEditingController();
  TextEditingController _editingController2 = TextEditingController();
  bool _isSigningIn = false;
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    final phoneField = TextFormField(
      keyboardType: TextInputType.number,
      obscureText: false,
      style: style,
      controller: _editingController1,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Mobile Number",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextFormField(
      keyboardType: TextInputType.text,
      obscureText: !_showPassword,
      style: style,
      controller: _editingController2,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password ",
          suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
              child: Icon(
                _showPassword ? Icons.visibility : Icons.visibility_off,
              )),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButon = Material(
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
          var userDoc = await Firestore.instance
              .collection("Customers")
              .document(_editingController1.text)
              .get();

          if (userDoc.exists) {
            if (userDoc.data['pass'] != _editingController2.text) {
              Alert(
                context: context,
                title: "Password doesn't match!",
                desc: "A user already exist for this phone number!",
                type: AlertType.error,
              ).show();
              setState(() {
                _isSigningIn = false;
              });
              return;
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            phoneNumber: _editingController1.text,
                          )));
            }
          } else {
            Alert(
              context: context,
              title: "You are not registered!",
              desc: "A user already exist for this phone number!",
              type: AlertType.error,
            ).show();
            setState(() {
              _isSigningIn = false;
            });
            return;
          }
        },
        child: Text(
          "Log in",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final registerButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => FirstlogPage()));
        },
        child: Text(
          "Register",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(30, 100, 30, 10),
          color: Colors.white,
          child: ListView(children: <Widget>[
            Column(
              children: <Widget>[
                _isSigningIn ? LinearProgressIndicator() : SizedBox.shrink(),
                Image.asset(
                  "assets/logo.jpg",
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 45.0),
                phoneField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(height: 35.0),
                loginButon,
                SizedBox(height: 35.0),
                registerButon,
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
