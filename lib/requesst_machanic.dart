import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_fix/home1.dart';
import 'package:flutter/material.dart';

class RequestPage extends StatefulWidget {
  String phoneNumber;
  RequestPage({this.phoneNumber});
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  var _formKey = GlobalKey<FormState>();

  TextEditingController _editingController1 = TextEditingController();
  TextEditingController _editingController2 = TextEditingController();

  String dropdownValue = 'Car';
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    final vehicleType = DropdownButton<String>(
        value: dropdownValue,
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: ["Car", "Van", "Bus", "Lorry", "Motor Bicycle"]
            .map(
              (value) => DropdownMenuItem(
                child: Text(value),
                value: value,
              ),
            )
            .toList());

    final trouble = TextFormField(
      keyboardType: TextInputType.text,
      style: style,
      validator: (value) {
        if (value.isEmpty) {
          return "fuck you";
        }
      },
      controller: _editingController2,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "ID",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final request = Material(
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
            Firestore.instance
                .collection("request")
                .document(widget.phoneNumber)
                .setData({
              "Vehicle Type": dropdownValue,
              "Phone": _editingController1.text,
              "Trouble": _editingController2.text,
            }).then((_) {
              setState(() {
                _isSigningIn = false;
              });
              print("complite");
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage(phoneNumber: widget.phoneNumber)));
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
          "Request",
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
            child: Form(
              key: _formKey,
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
                  vehicleType,
                  new TextFormField(
                      decoration: new InputDecoration(
                          labelText: "current phone number"),
                      validator: (value) =>
                          value.isEmpty ? 'Phone number can\t be empty' : null),
                  SizedBox(
                    height: 10.0,
                  ),
                  trouble,
                  SizedBox(
                    height: 10.0,
                  ),
                  request,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
