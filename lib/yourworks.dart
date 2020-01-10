import 'package:flutter/material.dart';

class WorksPage extends StatefulWidget{
  @override
  _WorksPageState createState() => _WorksPageState();
}

class _WorksPageState extends State<WorksPage>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Your Works",
        style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}