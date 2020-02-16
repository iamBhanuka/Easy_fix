import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_fix/home1.dart';
import 'package:easy_fix/mechanicDetails.dart';
import 'package:flutter/material.dart';

class WaitingRequest extends StatefulWidget {
  String requestDoc;
  String userId;
  WaitingRequest(this.requestDoc,this.userId);
  @override
  _WaitingRequestState createState() => _WaitingRequestState();
}

class _WaitingRequestState extends State<WaitingRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/logo.jpg",
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 40.0,
            ),
            StreamBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data["state"] == 0) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Please wait a Moment..!",
                            style: TextStyle(color: Colors.red, fontSize: 24.0),
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          CircularProgressIndicator(
                            backgroundColor: Colors.cyan,
                            strokeWidth: 8,
                          ),
                        ],
                      ),
                    );
                  }
                  if (snapshot.data["state"] == 1) {
                    // return Container(
                    //   child: Text("done"),
                    // );
                    return Center(
                      child: FlatButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.blueAccent,
                        child: Text("Mechanic is Redy for you Click here...."),
                        onPressed: _ifok,
                      ),
                    );
                  } else {
                    // return Container(
                    //   child: Text("Cansel"),
                    // );
                    return Center(
                      child: FlatButton(
                        color: Colors.red,
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.blueAccent,
                        child: Text("Mechanic Cansel the Request Click here to continue"),
                        onPressed: _ifcansel,
                      ),
                    );
                  }
                }
                return Container();
              },
              stream: Firestore.instance
                  .collection("mechanic_request")
                  .document(widget.requestDoc)
                  .snapshots(),
            ),
          ],
        ),
      ),
    );
  }

  void _ifok() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MechanicDetailsPage(documentID: widget.requestDoc,userId: widget.userId,)));
  }
   void _ifcansel() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomePage(userDoc: widget.userId)));
  }
}
