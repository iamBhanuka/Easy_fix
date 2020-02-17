import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  final _currentPasswordTEController = TextEditingController();
  final _newPasswordTEController = TextEditingController();
  final _againPasswordTEController = TextEditingController();

  bool _changing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            _changing ? LinearProgressIndicator() : SizedBox.shrink(),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
              style: style,
              controller: _currentPasswordTEController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Current Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0))),
            ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
              style: style,
              controller: _newPasswordTEController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "New Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0))),
            ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
              style: style,
              controller: _againPasswordTEController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Password again",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0))),
            ),
            SizedBox(
              height: 15.0,
            ),
            Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30.0),
              color: Color(0xff01A0C7),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: changePassword,
                child: Text(
                  "Chnage Password",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void changePassword() async {
    if (_againPasswordTEController.text != _newPasswordTEController.text) {
      Alert(
          context: context,
          title: "Passwords are not matching!",
          desc: "Please Check your password!",
          type: AlertType.error,
          buttons: [
            DialogButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                })
          ]).show();
      return;
    }
    setState(() {
      _changing = true;
    });
    var user = await FirebaseAuth.instance.currentUser();
    user
        .reauthenticateWithCredential(EmailAuthProvider.getCredential(
            email: user.email, password: _currentPasswordTEController.text))
        .then((value) async {
      await user.updatePassword(_newPasswordTEController.text);
      setState(() {
        _changing = false;
      });
      Alert(
          context: context,
          title: "Password changed!",
          desc: "Your Password Change Sucsessfuly!",
          type: AlertType.success,
          buttons: [
            DialogButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                })
          ]).show();
    }).catchError((e) {
      Alert(
          context: context,
          title: "Current password is not match!",
          desc: "Your Current password is Incorect!",
          type: AlertType.error,
          buttons: [
            DialogButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                })
          ]).show();
      setState(() {
        _changing = false;
      });
    });
  }
}
