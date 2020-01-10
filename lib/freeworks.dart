import 'package:flutter/material.dart';

class FreeWorkPage extends StatefulWidget{
  @override
  _FreeWorkPageState createState() => _FreeWorkPageState();
}

class _FreeWorkPageState extends State<FreeWorkPage>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Free Works",
        style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}