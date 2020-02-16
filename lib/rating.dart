import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_fix/home1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RatePage extends StatefulWidget {
  String documentID;
  String userId;
  RatePage({this.documentID,this.userId});
  @override
  _RatePageState createState() => _RatePageState();
}

class _RatePageState extends State<RatePage> {
  var _ratingController = TextEditingController();
  double _rating;

  int _ratingBarMode = 1;

  bool _isVertical = false;
  IconData _selectedIcon;

  @override
  void initState() {
    _ratingController.text = "3.0";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Rating Mechanic'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: StreamBuilder(
                      stream: Firestore.instance
                          .collection("users")
                          .document(widget.documentID)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(
                        height: 40.0,
                      ),
                      _heading('Rate Me'),
                      _ratingBar(_ratingBarMode),
                      SizedBox(
                        height: 20.0,
                      ),
                      _rating != null
                          ? Text(
                              "Rating: $_rating",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : Container(),
                      SizedBox(
                        height: 40.0,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(
                              color: Color(0xff476cfb),
                              onPressed: () {
                                Firestore.instance.collection("users").document(widget.documentID).updateData({
                                  "rate": FieldValue.arrayUnion([_rating])
                                });
                                
                                
                                Alert(
                                  context: context,
                                  type: AlertType.success,
                                  title: "Thank You",
                                  desc: "Thaks for being with us.....!!",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "Thank You",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        HomePage(userDoc: widget.userId,)));
                                      },
                                      color: Color.fromRGBO(0, 179, 134, 1.0),
                                      radius: BorderRadius.circular(0.0),
                                    ),
                                  ],
                                ).show();
                                setState(() {});
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ratingBar(int mode) {
    switch (mode) {
      case 1:
        return RatingBar(
          initialRating: 1,
          minRating: 1,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          unratedColor: Colors.blueAccent.withAlpha(50),
          itemCount: 5,
          itemSize: 50.0,
          itemPadding: EdgeInsets.symmetric(horizontal: 5.0),
          itemBuilder: (context, _) => Icon(
            _selectedIcon ?? Icons.star,
            color: Colors.blueAccent,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
        );

      default:
        return Container();
    }
  }

  Widget _heading(String text) => Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 24.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      );
}
