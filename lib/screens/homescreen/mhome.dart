import 'package:app2020/models/user.dart';
import 'package:app2020/screens/authenticate/msign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app2020/services/authservice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app2020/connect.dart';

class MHome extends StatefulWidget {
  final appTitle = 'SECURIDE';

  @override
  _MHome createState() => _MHome();
}

class _MHome extends State<MHome> {
  String userid;
  String role;
  String email;
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;
  Future<FirebaseUser> testuser = FirebaseAuth.instance.currentUser();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    user = await auth.currentUser();
    setState(() {});
    //print(user.uid);
  }

  @override
  Widget build(BuildContext context) {

    final shome = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => MHome(),
            ),
                (route) => false,
          );
        },
        child: Text("Home",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final edit = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {},
        child: Text("Customer Request",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final logout = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.red,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.3,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          dynamic result = await _auth.signOut();
          if(result == null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => MSignIn(),
              ),
                  (route) => false,
            );
          }
        },
        child: Text("Logout",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text("Securide"),
          backgroundColor: Colors.indigo,
        ),
        body: Column(
          children: [
            Center(child: Text('Current Customer Request')),
          ],
        ),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors
                .indigo, //This will change the drawer background to blue.
            //other styles
          ),
          child: Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                    accountName: null,
                  accountEmail: Text("Login As : "+"${user?.email}"),
                  currentAccountPicture:
                  Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.contain,
                  ),
                    ),
                // DrawerHeader(
                //   decoration: BoxDecoration(
                //       color: Colors.purple,
                //       image: DecorationImage(
                //           image: AssetImage("assets/logo.png"),
                //           fit: BoxFit.cover)
                //   ),
                //
                // ),
                ListTile(
                  title: shome,
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                  // ...
                  // Then close the drawer
                ),
                ListTile(
                  title: edit,
                  onTap: () {
                    // Update the state of the app
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: logout,
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
