import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WorksPage extends StatefulWidget {
  String userDoc;
  WorksPage(this.userDoc);
  @override
  _WorksPageState createState() => _WorksPageState();
}

class _WorksPageState extends State<WorksPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(
          "Your Works",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return Container(
              child: CircularProgressIndicator(),
            );
          } else if (snapshots.connectionState == ConnectionState.done) {
            if (snapshots.hasData) {
              return ListView(
                children: snapshots.data.documents
                    .map((doc) => ListTile(
                          title: Text(doc.data["vehicle_Number"],),
          
                          
                        ))
                    .toList(),
              );
            } else {
              return Container(
                child: Text("no data"),
              );
            }
          } else {
            return Container();
          }
        },
        future: Firestore.instance
            .collection("request")
            .where("customer", isEqualTo: widget.userDoc)
            .where("complete", isEqualTo: true)
            .getDocuments(),
      ),
    );
  }
}
