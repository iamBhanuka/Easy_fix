import 'package:flutter/material.dart';

class YourProfilePage extends StatefulWidget{
  @override
  _YourProfilePageState createState() => _YourProfilePageState();
}

class _YourProfilePageState extends State<YourProfilePage>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Profile",
        style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}