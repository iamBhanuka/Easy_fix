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

  TextEditingController _editingController1 = TextEditingController();
  TextEditingController _editingController2 = TextEditingController();
  TextEditingController _editingController3 = TextEditingController();
  TextEditingController _editingController4 = TextEditingController();
  TextEditingController _editingController5 = TextEditingController();
  TextEditingController _editingController6 = TextEditingController();

  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    final fname = TextField(
      keyboardType: TextInputType.text,
      style: style,
      controller: _editingController1,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "First Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final lName = TextField(
      keyboardType: TextInputType.text,
      obscureText: false,
      style: style,
      controller: _editingController2,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Last Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final idField = TextField(
      keyboardType: TextInputType.text,
      obscureText: false,
      style: style,
      controller: _editingController3,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "ID",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final email = TextField(
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

    final passwordField = TextField(
      keyboardType: TextInputType.text,
      obscureText: true,
      style: style,
      controller: _editingController5,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final confermpasswordField = TextField(
      keyboardType: TextInputType.text,
      obscureText: true,
      style: style,
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

          if (_editingController5.text != _editingController6.text) {
            Alert(
              context: context,
              title: "Password is not match",
              desc: "A user already exist for this phone number!",
              type: AlertType.error,
            ).show();
            setState(() {
              _isSigningIn = false;
            });
            return;
          }

          Firestore.instance
              .collection("users")
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
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _isSigningIn ? LinearProgressIndicator() : SizedBox.shrink(),
              Image.asset(
                "assets/logo.jpg",
                fit: BoxFit.contain,
              ),
              SizedBox(height: 8.0),
              fname,
              SizedBox(
                height: 10.0,
              ),
              lName,
              SizedBox(
                height: 10.0,
              ),
              idField,
              SizedBox(height: 8.0),
              email,
              SizedBox(
                height: 10.0,
              ),
              passwordField,
              SizedBox(height: 8.0),
              confermpasswordField,
              SizedBox(
                height: 10.0,
              ),
              nextButon,
            ],
          ),
        ),
      ),
    );
  }
}
