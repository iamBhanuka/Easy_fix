import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_fix/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SignupPage extends StatefulWidget {
  String phoneNumber;
  SignupPage({this.phoneNumber});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  var _formKey = GlobalKey<FormState>();

  TextEditingController _editingController1 = TextEditingController();
  TextEditingController _editingController2 = TextEditingController();
  TextEditingController _editingController3 = TextEditingController();
  TextEditingController _editingController4 = TextEditingController();
  TextEditingController _editingController5 = TextEditingController();
  TextEditingController _editingController6 = TextEditingController();

  bool _isSigningIn = false;

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
      controller: _editingController1,
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
      controller: _editingController2,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Last Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final idField = TextFormField(
      keyboardType: TextInputType.text,
      obscureText: false,
      style: style,
      validator: (value) {
        if (value.isEmpty) {
          return "ID Can't be Empty";
        }
                return null;

      },
      controller: _editingController3,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "ID",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      obscureText: false,
      style: style,
      controller: _editingController4,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      style: style,
      validator: (value) {
        if (value.isEmpty) {
          return "Password Can't be Empty";
        }
                return null;

      },
      controller: _editingController5,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final confermpasswordField = TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      style: style,
      validator: (value) {
        if (value.isEmpty) {
          return "You should Conferm Password";
        }
                return null;

      },
      controller: _editingController6,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Conferm Password",
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
        onPressed: () {
          setState(() {
            _isSigningIn = true;
          });

          if (_formKey.currentState.validate()) {
            if (_editingController5.text != _editingController6.text) {
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

            Firestore.instance
                .collection("Customers")
                .document(widget.phoneNumber)
                .setData({
              "First Name": _editingController1.text,
              "Last Name": _editingController2.text,
              "id": _editingController3.text,
              "Email": _editingController4.text,
              "pass": _editingController5.text,
              "conpass": _editingController6.text,
              "Type": "Customer"
            }).then((_) {
              setState(() {
                _isSigningIn = false;
              });

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          VehiclePage(phoneNumber: widget.phoneNumber)));
            }).catchError((err) {
              setState(() {
                _isSigningIn = false;
              });
              print(err);
            });
          
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
          child:Form(
            key: _formKey,
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  _isSigningIn ? LinearProgressIndicator() : SizedBox.shrink(),
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
}
