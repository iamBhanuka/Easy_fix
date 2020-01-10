import 'package:flutter/material.dart';

class MechanicPage extends StatefulWidget{
  String phoneNumber;
  MechanicPage({this.phoneNumber});
  @override
  _MechanicPageState createState() => _MechanicPageState();
}

class _MechanicPageState extends State<MechanicPage>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Help",
        style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}