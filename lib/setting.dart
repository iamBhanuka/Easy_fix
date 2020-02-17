import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_fix/vehicle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SettingPage extends StatefulWidget {
  final String userDoc;
  SettingPage({this.userDoc});
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  var _formKey = GlobalKey<FormState>();

  TextEditingController _firstNameTEController = TextEditingController();
  TextEditingController _phoneNumberTEController = TextEditingController();
  TextEditingController _idFieldTEController = TextEditingController();
  TextEditingController _emailTEController = TextEditingController();

  bool _isSigningIn = false;
  bool _gotData = false;
  bool _isChecked1 = false;
  bool _isChecked2 = false;

  @override
  void initState() {
    super.initState();
    initForm();
  }

  @override
  Widget build(BuildContext context) {
    final fnameWidget = TextFormField(
      keyboardType: TextInputType.text,
      style: style,
      validator: (value) {
        if (value.isEmpty) {
          return "Name Can't be Empty";
        }
        return null;
      },
      controller: _firstNameTEController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Your Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final phoneNumberWidget = TextFormField(
      keyboardType: TextInputType.phone,
      style: style,
      validator: (value) {
        if (value.isEmpty) {
          return "Phone number can't be empty!";
        }
        return null;
      },
      controller: _phoneNumberTEController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Phone number",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final idFieldWidget = TextFormField(
      keyboardType: TextInputType.text,
      style: style,
      controller: _idFieldTEController,
      validator: (value) {
        if (value.isEmpty) {
          return "NIC Can't be Empty";
        }
        return null;
      },
      enabled: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "NIC",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final emailWidget = TextFormField(
      keyboardType: TextInputType.emailAddress,
      enabled: false,
      style: style,
      controller: _emailTEController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final nextButonWidget = Material(
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
            Firestore.instance
                .collection("users")
                .document(widget.userDoc)
                .updateData({
              "Name": _firstNameTEController.text,
              "number": _phoneNumberTEController.text,
              "Hybride": _isChecked1,
              "Non Hybride": _isChecked2
            }).then((_) async {
              setState(() {
                _isSigningIn = false;
              });
              await Alert(
                  context: context,
                  title: "Updated!",
                  desc: "Your Changes is sucsessfuly updated!",
                  type: AlertType.success,
                  buttons: [
                    DialogButton(
                        child: Text("Ok"),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ]).show();
              Navigator.pop(context);
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
          "Update",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return new Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: _gotData
              ? Container(
                  margin: EdgeInsets.all(28.0),
                  color: Colors.white,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _isSigningIn
                            ? LinearProgressIndicator()
                            : SizedBox.shrink(),
                        Image.asset(
                          "assets/logo.jpg",
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 15.0),
                        fnameWidget,
                        SizedBox(
                          height: 15.0,
                        ),
                        phoneNumberWidget,
                        SizedBox(
                          height: 15.0,
                        ),
                        idFieldWidget,
                        SizedBox(height: 15.0),
                        emailWidget,
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text("Hybrid Vehicle",
                                style: TextStyle(fontSize: 30.0),
                                textAlign: TextAlign.center),
                            new Checkbox(
                              value: _isChecked1,
                              activeColor: Colors.red,
                              onChanged: (bool value) {
                                onChanged1(value);
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              "Normal Vehicle",
                              style: TextStyle(fontSize: 28.0),
                              textAlign: TextAlign.center,
                            ),
                            new Checkbox(
                              value: _isChecked2,
                              activeColor: Colors.red,
                              onChanged: (bool value) {
                                onChanged2(value);
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        nextButonWidget,
                        SizedBox(
                          height: 35.0,
                        ),
                      ],
                    ),
                  ),
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> initForm() async {
    print("calling");
    var user = await Firestore.instance
        .collection("users")
        .document(widget.userDoc)
        .get();

    if (user.exists) {
      _emailTEController.text = user.data["email"];
      _idFieldTEController.text = user.data["nic"];
      _phoneNumberTEController.text = user.data["number"];
      _firstNameTEController.text = user.data["Name"];
      _isChecked1 = user.data["Hybride"];
      _isChecked2 = user.data["Non Hybride"];
    }
    setState(() {
      _gotData = true;
    });
  }

  void onChanged2(bool value) {
    setState(() {
      _isChecked2 = value;
    });
  }

  void onChanged1(bool value) {
    setState(() {
      _isChecked1 = value;
    });
  }
}
