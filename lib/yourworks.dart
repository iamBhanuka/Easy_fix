import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          switch (snapshots.connectionState) {
            case ConnectionState.waiting:
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case ConnectionState.done:
              if (snapshots.hasData) {
                print(snapshots.data.documents.length);
                return ListView(
                  children: snapshots.data.documents
                      .map(
                        (doc) => ListTile(
                          leading: Icon(FontAwesomeIcons.cogs),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(doc.data["name"]),
                              Text(doc.data["Current_Phone"]),
                              Text(doc.data["Vehicle_Type"]),
                              Text(doc.data["vehicle_Number"]),
                              Text(doc.data["Trouble"]),
                            ],
                          ),
                          trailing: FutureBuilder(builder: (context,AsyncSnapshot<DocumentSnapshot> msnp){
                            switch(msnp.connectionState){
                              case ConnectionState.waiting:return CircularProgressIndicator();
                              case ConnectionState.done:
                              if(msnp.hasData){
                                return Column(
                                  children: <Widget>[
                                    Text(msnp.data.data["Name"] != null ? msnp.data.data["Name"] : ""),
                                    Text(msnp.data.data["number"] != null ? msnp.data.data["number"] : ""),
                                  ],
                                );
                              }else{
                                  return Container();
                              }
                              break;
                              default: return Container();
                            }
                          },future: Firestore.instance.collection("users").document(doc.data["machenic"]).get(),),
                        ),
                      )
                      .toList(),
                );
              } else {
                return Container(
                  child: Text("No data found!"),
                );
              }
              break;
            default:
              return Container(
                child: Text("Something went wrong!"),
              );
          }
        },
        future: Firestore.instance
            .collection("mechanic_request")
            .where("customer", isEqualTo: widget.userDoc)
            .where("state", isEqualTo: 3)
            .getDocuments(),
      ),
    );
  }
}
