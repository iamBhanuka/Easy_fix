import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:io';

class YourProfilePage extends StatefulWidget {
  String userDoc;
  YourProfilePage({this.userDoc});
  @override
  _YourProfilePageState createState() => _YourProfilePageState();
}

class _YourProfilePageState extends State<YourProfilePage> {
  bool _isSigningIn = false;
  File _image;
  @override
  Widget build(BuildContext context) {



    Future getImage() async{
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print("image path $_image");
      });
    }

    Future uploadPic(BuildContext context)async{
      String fileName = basename(_image.path);
      StorageReference fireebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = fireebaseStorageRef.putFile(_image);

      uploadTask.events.listen((event) {
        print(event.type.toString());
      });
      print('Upload task ${uploadTask.isComplete}');
      uploadTask.onComplete.then((snap) {
        return fireebaseStorageRef.getDownloadURL().then((url) {
          print(widget.userDoc);
          Firestore.instance
                .collection("users")
                .document(widget.userDoc)
                .updateData({
              "Photo": url,
        
            }).then((_) {
              setState(() {
                _isSigningIn = false;
              });
            });         
          print(url);
        });
      });
     

      setState(() {
        print("Profile picture uploaded");
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your Profile picture uploaded"),));

      });
    }

    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Builder(
        builder: (context) => Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Color(0xff476cfb),
                      child: ClipOval(
                        child:SizedBox(
                          width: 180.0,
                          height: 180.0,
                          child:(_image !=null)?Image.file(_image,fit: BoxFit.fill,)
                          :Image.asset(
                            "assets/aaa.png",
                          fit: BoxFit.fill,
                          ),
                        ) ,),
                    ),
                  ),
                  Padding(
                    padding:EdgeInsets.only(top: 70.0),
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.camera,
                        size: 30.0,
                      ),
                      onPressed: (){
                        getImage();
                      },
                    ),
                    )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: Color(0xff476cfb),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    elevation: 4.0,
                    splashColor: Colors.blueGrey,
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                  RaisedButton(
                    color: Color(0xff476cfb),
                    onPressed: (){
                       uploadPic(context);
                    },
                    elevation: 4.0,
                    splashColor: Colors.blueGrey,
                    child: Text(
                      "Submite",
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  )
                ],)
            ],
          ),
        ),
      ),
    );
  }
}
