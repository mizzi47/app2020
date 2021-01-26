import 'file:///C:/Users/mizi/AndroidStudioProjects/app2020/lib/screens/authenticate/mregister.dart';
import 'file:///C:/Users/mizi/AndroidStudioProjects/app2020/lib/screens/wrapper/MWrapper.dart';
import 'package:app2020/screens/homescreen/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app2020/services/authservice.dart';

class MSignIn extends StatefulWidget {
  final Function toggleView;

  MSignIn({this.toggleView});
  @override
  _MSignInState createState() => _MSignInState();
}

class _MSignInState extends State<MSignIn> {

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final AuthService _auth = AuthService();
  final formkey = GlobalKey<FormState>();
  TextEditingController email = new TextEditingController();
  TextEditingController pw = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController bname = new TextEditingController();

  @override

  Widget build(BuildContext context) {
    // String email="";
    //  String pw="";
    final registButton = Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.purple,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.6,
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MRegister()),
          ); //signup screen
        },
        child: Text("Register",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    showAlertDialog(BuildContext context){
      AlertDialog alert=AlertDialog(
        content: new Row(
          children: [
            CircularProgressIndicator(),
            Container(margin: EdgeInsets.only(left: 5),child:Text("Loading" )),
          ],),
      );
      showDialog(barrierDismissible: false,
        context:context,
        builder:(BuildContext context){
          return alert;
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/mg.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 150,
                  height: 150,
                  child: Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 25.0),
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: email,
                        obscureText: false,
                        style: style,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 25.0),
                      TextFormField(
                        controller: pw,
                        obscureText: true,
                        style: style,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Color(0xff01A0C7),
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () async {
                      showAlertDialog(context);
                      if (formkey.currentState.validate()) {
                        dynamic result = await _auth.signInUser(email.text, pw.text);
                        if (result == null) {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Invalid email/password'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text('Email or password is not match'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        else if(result!= null){
                          // print("sdsds useruid  "+result.uid);
                          var document = await Firestore.instance.collection('USER')
                              .document(result.uid)
                              .get();
                          if(document!=null){
                            String role = document.data['role'].toString();
                            if(role == 'mech'){
                              Navigator.pop(context);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => MWrapper(),
                                ),
                                    (route) => false,
                              );
                            }
                            else if(role == 'user'){
                              await _auth.signOut();
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                barrierDismissible: false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Invalid email/password'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text('Email or password is not match'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        }
                      }
                    },
                    child: Text("Login",
                        textAlign: TextAlign.center,
                        style: style.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                registButton,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
