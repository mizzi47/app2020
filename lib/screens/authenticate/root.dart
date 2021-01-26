// import 'file:///C:/Users/mizi/AndroidStudioProjects/app2020/lib/screens/authenticate/register.dart';
// import 'package:app2020/screens/homescreen/home.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'file:///C:/Users/mizi/AndroidStudioProjects/app2020/lib/screens/wrapper/MWrapper.dart';
import 'file:///C:/Users/mizi/AndroidStudioProjects/app2020/lib/screens/wrapper/Wrapper.dart';
import 'package:flutter/material.dart';
import 'package:app2020/services/authservice.dart';
import 'package:app2020/screens/authenticate/sign_in.dart';
import 'package:app2020/screens/authenticate/msign_in.dart';

class Root extends StatelessWidget{
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final AuthService _auth = AuthService();
  final formkey = GlobalKey<FormState>();
  TextEditingController email = new TextEditingController();
  TextEditingController pw = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController bname = new TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg2.jpg"),
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
                  width: 200,
                  height: 200,
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
                      SizedBox(height: 25.0),
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0xff01A0C7),
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Wrapper(),
                              ),
                                  (route) => false,
                            );
                          },
                          child: Text("Customer",
                              textAlign: TextAlign.center,
                              style: style.copyWith(
                                  color: Colors.white, fontWeight: FontWeight.bold)),
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
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => MWrapper(),
                              ),
                                  (route) => false,
                            );
                            },
                          child: Text("Mechanic",
                              textAlign: TextAlign.center,
                              style: style.copyWith(
                                  color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
              ],
            ),
          ),
            ]
        ),
      ),
    ),
    ),
    );
  }
}
