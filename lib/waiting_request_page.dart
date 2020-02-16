import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_fix/mechanicDetails.dart';
import 'package:flutter/material.dart';

class WaitingRequest extends StatefulWidget {
  String requestDoc;
  WaitingRequest(this.requestDoc);
  @override
  _WaitingRequestState createState() => _WaitingRequestState();
}

class _WaitingRequestState extends State<WaitingRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data["state"] == false) {
              return Container(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container(
                child: Text("done"),
              );
          //     Routes.
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) =>
          //                 MechanicDetailsPage(documentID: widget.requestDoc)));
            }
          }
          return Container();
        },
        stream: Firestore.instance
            .collection("mechanic_request")
            .document(widget.requestDoc)
            .snapshots(),
      ),
    );
  }
}
