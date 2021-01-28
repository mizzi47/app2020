import 'file:///C:/Users/mizi/AndroidStudioProjects/app2020/lib/screens/wrapper/MWrapper.dart';
import 'file:///C:/Users/mizi/AndroidStudioProjects/app2020/lib/screens/wrapper/Wrapper.dart';
import 'package:app2020/models/user.dart';
import 'package:app2020/screens/authenticate/backupsign.dart';
import 'package:app2020/screens/homescreen/backuphome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

var document;
var mechdocument;
String role;
final FirebaseAuth auth = FirebaseAuth.instance;
FirebaseUser user;


class Init {
  static Future initialize() async {
    await _registerServices();
    await _loadSettings();
  }

  static _registerServices() async {
    //TODO register services
  }

  static _loadSettings() async {
      user = await auth.currentUser();
      document = await Firestore.instance.collection('USER').document(user.uid).get();
      role = document.data['role'].toString();
  }

}

class InitRoot extends StatelessWidget {


  final Future _initFuture = Init.initialize();

  @override
  Widget build(BuildContext context) {
    final muser = Provider.of<User>(context);
    if(muser == null){
      return Root();
    }
    else{
      return MaterialApp(
        title: 'Initialization',
        home: FutureBuilder(
          future: _initFuture,
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.done){
              if(role == "mech"){
                print(role);
                return MWrapper();
              }
              else{
                print(role);
                return Wrapper();
              }
            } else {
              return SplashScreen();
            }
          },
        ),
      );

    }
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/mg.jpg'), fit: BoxFit.cover),
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
        ),
      ),
    );
  }
}


// ignore: must_be_immutable
class Root extends StatelessWidget {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
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
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.blueAccent,
                          // color: Color(0xff01A0C7),
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            padding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.teal,
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            padding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
