import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_fix/payment.dart';

class MechanicDetailsPage extends StatefulWidget {
  String documentID;
  MechanicDetailsPage({this.documentID});
  @override
  _MechanicDetailsPageState createState() => _MechanicDetailsPageState();
}

class _MechanicDetailsPageState extends State<MechanicDetailsPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.documentID);
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(
          "Mechanic Profile",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Builder(
        builder: (context) => Container(
            padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection("mechanic")
                              .document(widget.documentID)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              DocumentSnapshot doc = snapshot.data;
                              print(doc.data);
                              print(widget.documentID);
                              return Column(
                                children: <Widget>[
                                  ClipOval(
                                      child: doc.data["Photo"] == null
                                          ? ClipOval(
                                              child: Image.asset(
                                              'assets/aaa.png',
                                              width: 100,
                                              height: 100,
                                            ))
                                          : Image.network(
                                              doc.data["Photo"],
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            )),
                                  Text(
                                    doc.data["mechanic_name"],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 35.0),
                                  )
                                ],
                              );
                            } else {
                              return Column(
                                children: <Widget>[
                                  ClipOval(
                                      child: Image.asset(
                                    'assets/aaa.png',
                                    width: 100,
                                    height: 100,
                                  )),
                                  Text(
                                    'Bhanuka',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25.0),
                                  )
                                ],
                              );
                            }
                          },
                        ),
                      ]),
                  SizedBox(height: 40),
                  Container(
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance
                          .collection('mechanic')
                          .document(widget.documentID)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) return const Text('Loading....');
                        var data = snapshot.data;
                        return Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Specification :-',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 28.0),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      data['specification'],
                                      style: TextStyle(fontSize: 25.0),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Contact Number :-',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 28.0),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 8.0),
                                    child: InkWell(
                                      child: Text(
                                        data['telephone'],
                                        style: TextStyle(fontSize: 25.0),
                                      ),
                                      onTap: () async {
                                        await launch(
                                            'tel:${data['telephone']}');
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              margin: EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Address :-',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 22.0),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      data['address'],
                                      style: TextStyle(fontSize: 22.0),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 30,),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 100, 10, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          
                                children: <Widget>[
                                  RaisedButton(
                                    color: Color(0xff476cfb),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    elevation: 4.0,
                                    splashColor: Colors.blueGrey,
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                    ),
                                  ),
                                  RaisedButton(
                                    color: Color(0xff476cfb),
                                    onPressed: () {
                                      Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => PaymentPage()));
                                    },
                                    elevation: 4.0,
                                    splashColor: Colors.blueGrey,
                                    child: Text(
                                      "Payment",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                    ),
                                  ),
                                  RaisedButton(
                                    color: Color(0xff476cfb),
                                    onPressed: () {
                                      
                                    },
                                    elevation: 4.0,
                                    splashColor: Colors.blueGrey,
                                    child: Text(
                                      "Rate",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  )
                ])),
      ),
    );
  }
}
