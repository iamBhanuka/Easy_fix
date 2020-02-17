import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_fix/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_fix/home1.dart';
import 'package:logger/logger.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:crypto/crypto.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _editingController1 = TextEditingController();
  TextEditingController _editingController2 = TextEditingController();
  bool _isSigningIn = false;
  bool _showPassword = false;
  String _email;
  String _password;

  var formkey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final phoneField = TextFormField(
      // key: formkey,
      keyboardType: TextInputType.emailAddress,
      obscureText: false,
      style: style,
      controller: _editingController1,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email Address",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: (value) => value.isEmpty ? 'Email can\'t be Empty' : null,
      onChanged: (val) {
        setState(() {
          _email = val;
        });
      },
    );

    final passwordField = TextFormField(
      // key: formkey,
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
      validator: (value) => value.isEmpty ? 'Password can\'t be Empty' : null,
      onChanged: (val) {
        setState(() {
          _password = val;
        });
      },
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
              .collection("users")
              .where("email", isEqualTo: _editingController1.text)
              .getDocuments();

          if (formkey.currentState.validate()) {
            // FirebaseUser user = (await FirebaseAuth.instance
            //     .signInWithEmailAndPassword(
            //         email: _email, password: _password)) as FirebaseUser;

            if (userDoc.documents.length > 0) {
              if (userDoc.documents.first.data['usertype'] != "Customer") {
                Alert(
                  context: context,
                  title: "Your are not Customer !",
                  desc: "Please Create a EasyFix Customer Account !",
                  type: AlertType.error,
                ).show();
                setState(() {
                  _isSigningIn = false;
                });
                return;
              } else {
                if (_email != null && _password != null) {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _email, password: _password)
                      .then((res) {
                    Logger().i(res);

                    Logger().i(FirebaseAuth.instance.currentUser().then((user) {
                      Logger().i(user.uid);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomePage(userDoc: user.uid)));
                    }));
                  }).catchError((error) {
                    Alert(
                      context: context,
                      title: "Invalid",
                      desc: "Your Password And Email Didn't Match!",
                      type: AlertType.error,
                    ).show();
                  });
                } else {
                  Alert(
                      context: context,
                      title: "Empty Email and Password!",
                      desc: "Fill the Email and Password Field!",
                      type: AlertType.error,
                    );
                  
                }
              }
            } else {
              Alert(
                context: context,
                title: "You are not registered!",
                desc: "Please Register as EasyFix Customer!",
                type: AlertType.error,
              ).show();
              setState(() {
                _isSigningIn = false;
              });
              return;
            }
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
          child: Form(
            key: formkey,
            child: ListView(children: <Widget>[
              Column(
                children: <Widget>[
                  _isSigningIn ? CircularProgressIndicator(
                     backgroundColor: Colors.cyan,
                  strokeWidth: 8,
                  ) : SizedBox.shrink(),
                  SizedBox(height: 10.0,),
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
      ),
    );
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}
