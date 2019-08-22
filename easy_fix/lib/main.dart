import 'package:flutter/material.dart';
import 'package:famguard/ui/signup.dart';
void main(){
   runApp(MyApp());
   return;
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return new MaterialApp(
      home: new LoginPage(),
      theme: new ThemeData(
        primarySwatch: Colors.blue
        ),
    );
  } 
}

class LoginPage extends StatefulWidget{
  
@override
State createState() => new LoginPageState();
}
class LoginPageState extends State<LoginPage>{
  TextStyle style = TextStyle(fontFamily: 'Montserrat',fontSize: 20.0);
  @override
  Widget build(BuildContext context){
    final idField = TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0,15.0,20.0,15.0),
        hintText: "ID",
        

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final passwordField = TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0,15.0,20.0,15.0),
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final loginButon =Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: (){
          Navigator.of(context).pushNamed('/signup');
        },
        child: Text("Login",
        textAlign: TextAlign.center,
        style: style.copyWith(color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );

      final signupButon =Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: (){},
        child: Text("Signup",
        textAlign: TextAlign.center,
        style: style.copyWith(color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );


    return Scaffold(
        body: Center(
          child: Container(
            color: Colors.orange,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 155.0,
                     child: Image.asset(
                        "assets/logo.jpg",
                        fit: BoxFit.contain,
                      ),
                  ),
                  SizedBox(height: 45.0),
                  idField,
                  SizedBox(height: 25.0),
                  passwordField,
                  SizedBox(height: 35.0),
                  loginButon,
                  SizedBox(height: 15.0,),
                  signupButon,
                  SizedBox(height: 05.0,)

                ],
              ),
              ),
            ),
          ),
        );
  }
}
