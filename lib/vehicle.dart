import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_fix/home1.dart';

class VehiclePage extends StatefulWidget {
  String phoneNumber;
  VehiclePage({this.phoneNumber});
  @override
  _VehiclePageState createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  bool _isSigningIn = false;
  bool _isChecked1 = false;
  bool _isChecked2 = false;

  void onChanged1(bool value) {
    setState(() {
      _isChecked1 = value;
    });
  }

  void onChanged2(bool value) {
    setState(() {
      _isChecked2 = value;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          var data = {"Hybride": _isChecked1, "Non Hybride": _isChecked2};

          print(data);
          print(widget.phoneNumber);
          Firestore.instance
              .collection("Customers")
              .document(widget.phoneNumber)
              .updateData(data)
              .then((uhu) {
            setState(() {
              _isSigningIn = false;
            });
            print("complite");
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                          phoneNumber: widget.phoneNumber,
                        )));
          }).catchError((err) {
            setState(() {
              _isSigningIn = false;
            });
            print(err);
          });
        },
        child: Text(
          "Resgister",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Vehicle Type", style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 100, 50, 50),
            child: ListView(
              children: <Widget>[
                _isSigningIn ? LinearProgressIndicator() : SizedBox.shrink(),
                Image.asset(
                  "assets/logo.jpg",
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 50.0),
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
                  height: 50.0,
                ),
                nextButon
              ],
            ),
          ),
        ),
      ),
    );
  }
}
