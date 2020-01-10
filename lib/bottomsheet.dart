
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_fix/requesst_machanic.dart';

class BottomsheetPage extends StatefulWidget{  
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String documentID ;
  BottomsheetPage({this.documentID});
  bool _isSigningIn = false;
  @override
  _BottomsheetPageState createState() => _BottomsheetPageState();
}
class _BottomsheetPageState extends State<BottomsheetPage>
{
  @override
  Widget build(BuildContext context) 
  {
    final requestButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
     onPressed: () {
            Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => RequestPage()));

        },
        child: Text(
          " Request",
          textAlign: TextAlign.center,
                  ),
      ),
    );

    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('markers').document(widget.documentID).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) 
      {
        if (!snapshot.hasData) return const Text('Loading...');
        var data = snapshot.data;
        return 
            Container(color: Colors.white70,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(data['name'],
                  style: TextStyle(fontSize: 20.0),),
                  Text(data['mechanic_name'],
                  style: TextStyle(fontSize: 20.0),),
                  Text(data['specification'],
                  style: TextStyle(fontSize: 20.0),),
                  
                  SizedBox(height: 0.8),
                  requestButon,
                  
                ],
                
                
              ),
            ),);
                        
      });
  }
}
//Container(child: Text(data['name']),);