import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_fix/vehicle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:crypto/crypto.dart';

class SignupPage extends StatefulWidget {
  String userDoc;
  SignupPage({this.userDoc});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  var _formKey = GlobalKey<FormState>();

  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _idfield = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _conPassword = TextEditingController();

  bool _isSigningIn = false;
  bool _showPassword = false;
  bool _showconPassword = false;

  @override
  Widget build(BuildContext context) {
    final fname = TextFormField(
      keyboardType: TextInputType.text,
      style: style,
      validator: (value) {
        if (value.isEmpty) {
          return "First Name Can't be Empty";
        }
        return null;
      },
      controller: _firstName,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "First Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final lName = TextFormField(
      keyboardType: TextInputType.text,
      obscureText: false,
      style: style,
      validator: (value) {
        if (value.isEmpty) {
          return "Last Name Can't be Empty";
        }
        return null;
      },
      controller: _lastName,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Last Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final idField = TextFormField(
      keyboardType: TextInputType.text,
      style: style,
      validator: (value) {
        if (value.isEmpty) {
          return "ID Can't be Empty";
        }
        return null;
      },
      controller: _idfield,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "ID",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: style,
      controller: _email,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextFormField(
      keyboardType: TextInputType.text,
      obscureText: !_showPassword,
      style: style,
      validator: (value) {
        if (value.isEmpty) {
          return "Password Can't be Empty";
        }
        return null;
      },
      controller: _password,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
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
    final confermpasswordField = TextFormField(
      keyboardType: TextInputType.text,
      obscureText: !_showconPassword,
      style: style,
      validator: (value) {
        if (value.isEmpty) {
          return "You should Conferm Password";
        }
        return null;
      },
      controller: _conPassword,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Conferm Password",
          suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _showconPassword = !_showconPassword;
                });
              },
              child: Icon(
                _showconPassword ? Icons.visibility : Icons.visibility_off,
              )),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final nextButon = Material(
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

          if (_formKey.currentState.validate()) {
            if (_password.text != _conPassword.text) {
              Alert(
                context: context,
                title: "Password is not match",
                desc: "Check your Password!",
                type: AlertType.error,
              ).show();
              setState(() {
                _isSigningIn = false;
              });
              return;
            }

            String patttern =
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regExp = new RegExp(patttern);
            if (!regExp.hasMatch(_email.text)) {
              Alert(
                context: context,
                title: "Email invalid!",
                desc: "Enter a valid Email Address!",
                type: AlertType.warning,
              ).show();
              setState(() {
                _isSigningIn = false;
              });
              return;
            }

            var userDoc = await Firestore.instance
                .collection("users")
                .where("email", isEqualTo: _email.text)
                .getDocuments();

            if (userDoc.documents.length > 0) {
              Alert(
                context: context,
                title: "User exits",
                desc:
                    "A user already exist for this email address! try again !!",
                type: AlertType.error,
              ).show();
              setState(() {
                _isSigningIn = false;
              });
              return;
            }
            if ((_idfield.text.length == 10 &&
                    _isNumeric(_idfield.text.substring(0, 9)) &&
                    _idfield.text.toString().toLowerCase().endsWith("v")) ||
                (_idfield.text.length == 12 &&
                    _isNumeric(_idfield.text.substring(0, 9)))) {
              FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: _email.text, password: _password.text)
                  .then((res) {
                // FirebaseAuth.instance
                //     .signInWithEmailAndPassword(
                //         email: _email.text, password: _password.text)
                //     .then((result) {
                FirebaseAuth.instance.currentUser().then((user) {
                  Logger().i(user.uid);
                  Firestore.instance
                      .collection("users")
                      .document(user.uid)
                      .setData({
                    "First Name": _firstName.text,
                    "Last Name": _lastName.text,
                    "id": _idfield.text,
                    "email": _email.text,
                    "userType": "Customer",
                    "phoneNumber": widget.userDoc
                  }).then((_) async {
                    setState(() {
                      _isSigningIn = false;
                    });

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VehiclePage(userDoc: user.uid)));
                  }).catchError((err) {
                    setState(() {
                      _isSigningIn = false;
                    });
                    print(err);
                  });
                  // });
                });
              });

              //  Logger().i(users);

            } else {
              Alert(
                context: context,
                title: "ID Length is invalied",
                desc: "Check your ID card numbers !!",
                type: AlertType.error,
              ).show();
              setState(() {
                _isSigningIn = false;
              });
              return;
            }
          } else {
            setState(() {
              _isSigningIn = false;
            });
          }
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
          margin: EdgeInsets.all(28.0),
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    _isSigningIn
                        ? CircularProgressIndicator( backgroundColor: Colors.cyan,
                  strokeWidth: 8,)
                        : SizedBox.shrink(),
                    Image.asset(
                      "assets/logo.jpg",
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 15.0),
                    fname,
                    SizedBox(
                      height: 15.0,
                    ),
                    lName,
                    SizedBox(
                      height: 15.0,
                    ),
                    idField,
                    SizedBox(height: 15.0),
                    email,
                    SizedBox(
                      height: 15.0,
                    ),
                    passwordField,
                    SizedBox(height: 15.0),
                    confermpasswordField,
                    SizedBox(
                      height: 15.0,
                    ),
                    nextButon,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }
}
