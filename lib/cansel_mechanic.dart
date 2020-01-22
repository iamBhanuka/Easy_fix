import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_fix/home1.dart';
import 'package:flutter/material.dart';
import 'canseldetails.dart';

class CanselMechanicPage extends StatefulWidget {
  String documentID;
  CanselMechanicPage({this.documentID});

  final String title = "Why Are You Cansel The Mechanic";

  @override
  CanselMechanicPageState createState() => CanselMechanicPageState();
}

class CanselMechanicPageState extends State<CanselMechanicPage> {

  String cancelTitle;
  String cancelData;
  //
  List<CanselDetails> users;
  CanselDetails selectedUser;
  int selectedRadio;
  int selectedRadioTile;
  bool _isSigningIn = false;

  static get style => null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedRadio = 0;
    selectedRadioTile = 0;
    users = CanselDetails.getUsers();
    print(users);
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  setSelectedUser(CanselDetails user) {
    setState(() {
      selectedUser = user;
    });
  }

  List<Widget> createRadioListUsers() {
    List<Widget> widgets = [];
    for (CanselDetails user in users) {
      widgets.add(
        RadioListTile(
          value: user,
          groupValue: selectedUser,
          title: Text(user.canselDetail),
          subtitle: Text(user.canselDetail2),
          onChanged: (currentUser) {
            setSelectedUser(currentUser);
          },
          selected: selectedUser == user,
          activeColor: Colors.green,
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
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
          Firestore.instance
              .collection("cansel_mechanic")
              .document(widget.documentID)
              .setData({
            "Cansel Details title": selectedUser.canselDetail,
            "Cansel Details data": selectedUser.canselDetail2,
          }).then((_) {
            setState(() {});
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          }).catchError((err) {
            setState(() {
              _isSigningIn = false;
            });
            print(err);
          });
        },
        child: Text(
          "Request",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Select One",
              style: TextStyle(fontSize: 25.0),
            ),
          ),
          Column(
            children: createRadioListUsers(),
          ),
          request,
          SizedBox(
            height: 20.0,
          )
        ],
      ),
    );
  }
}
