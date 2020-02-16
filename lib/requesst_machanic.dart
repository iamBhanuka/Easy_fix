import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_fix/home1.dart';
import 'package:easy_fix/waiting_request_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_fix/mechanicDetails.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RequestPage extends StatefulWidget {
  String userDoc;
  String documentID;
  RequestPage({this.documentID, this.userDoc});
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  var _formKey = GlobalKey<FormState>();

  TextEditingController _trouble = TextEditingController();
  TextEditingController _currentPhone = TextEditingController();
  TextEditingController _vehicleNumber = TextEditingController();
  TextEditingController _name = TextEditingController();

  String dropdownValue = 'Car';
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    final vehicleType = DropdownButton<String>(
        value: dropdownValue,
        icon: Icon(Icons.arrow_downward),
        iconSize: 35,
        elevation: 16,
        style: TextStyle(color: Colors.deepPurple),
        isExpanded: true,
        underline: Container(
          height: 0,
          color: Colors.white,
        ),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: ["Car", "Van", "Bus", "Lorry", "Motor Bicycle"]
            .map(
              (value) => DropdownMenuItem(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                value: value,
              ),
            )
            .toList());

    final trouble = TextFormField(
      keyboardType: TextInputType.text,
      style: style,
      validator: (value) {
        if (value.isEmpty) {
          return "Enter Trouble";
        }
      },
      controller: _trouble,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Trouble",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final vehiclenumber = TextFormField(
      keyboardType: TextInputType.text,
      style: style,
      validator: (value) {
        if (value.isEmpty) {
          return "Enter Vehicle Number";
        }
      },
      controller: _vehicleNumber,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Vehicle Number  EX:- PW-2635",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final cname = TextFormField(
      keyboardType: TextInputType.text,
      style: style,
      validator: (value) {
        if (value.isEmpty) {
          return "Enter Your Name";
        }
      },
      controller: _name,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter your name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final cNumber = TextFormField(
      keyboardType: TextInputType.number,
      style: style,
      validator: (value) {
        if (value.isEmpty) {
          return "Please Enter Current phone number";
        }
      },
      controller: _currentPhone,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Current phone number",
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

          String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
          RegExp regExp = new RegExp(patttern);
          if (!regExp.hasMatch(_currentPhone.text)) {
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

          if (_formKey.currentState.validate()) {
            Firestore.instance
                .collection("mechanic_request")
                .document(widget.documentID)
                .setData({
              "name":_name.text,
              "Vehicle_Type": dropdownValue,
              "Current_Phone": _currentPhone.text,
              "Trouble": _trouble.text,
              "vehicle_Number": _vehicleNumber.text,
              "complete": false,
              "state": false,
              "customer": widget.userDoc,
              "machenic": widget.documentID
            }).then((doc) {
              setState(() {
                _isSigningIn = false;
              });
              print("complite");
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WaitingRequest(widget.documentID)));
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

    final canselButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => HomePage()));
        },
        child: Text(
          "Cansel",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    print(widget.documentID);
    return new Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _isSigningIn
                        ? LinearProgressIndicator()
                        : SizedBox.shrink(),
                    Image.asset(
                      "assets/logo.jpg",
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 8.0),
                    cname,
                    SizedBox(
                      height: 10.0,
                    ),
                    vehicleType,
                    SizedBox(
                      height: 10.0,
                    ),
                    trouble,
                    SizedBox(
                      height: 10.0,
                    ),
                    cNumber,
                    SizedBox(
                      height: 10.0,
                    ),
                    vehiclenumber,
                    SizedBox(
                      height: 20.0,
                    ),
                    request,
                    SizedBox(
                      height: 20.00,
                    ),
                    canselButon,

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
