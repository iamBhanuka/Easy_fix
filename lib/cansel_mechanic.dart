import 'package:flutter/material.dart';
import 'canseldetails.dart';

class CanselMechanicPage extends StatefulWidget {
  String documentID;
  CanselMechanicPage({this.documentID}): super();

  final String title = "Why Are You Cansel The Mechanic";

  @override
  CanselMechanicPageState createState() => CanselMechanicPageState();
}

class CanselMechanicPageState extends State<CanselMechanicPage> {
  //
  List<CanselDetails> users;
  CanselDetails selectedUser;
  int selectedRadio;
  int selectedRadioTile;

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    selectedRadioTile = 0;
    users = CanselDetails.getUsers();
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
            print("Current User ${currentUser.canselDetail}");
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: Text("Select One",
            style: TextStyle(fontSize: 25.0),
          ),
          ),
          Column(
            children: createRadioListUsers(),
          ),
         
        ],
      ),
    );
  }
}
