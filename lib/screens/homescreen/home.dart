import 'package:app2020/models/user.dart';
import 'package:app2020/screens/authenticate/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app2020/services/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app2020/connect.dart';
import 'package:provider/provider.dart';

import '../Wrapper.dart';


class Home extends StatefulWidget {
  final appTitle = 'SECURIDE';

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  String userid;
  String role;
  String email;
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;
  Future<FirebaseUser> testuser = FirebaseAuth.instance.currentUser();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final AuthService _auth = AuthService();
  // final FirebaseUser user = await _auth.currentUser();


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
              builder: (BuildContext context) => Home(),
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


    final btc = Material(
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
              builder: (BuildContext context) => connect(),
            ),
                (route) => false,
          );
        },
        child: Text("ArduinoConnect",
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
              builder: (BuildContext context) => SignIn(),
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

    final request = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.3,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
        },
        child: Text("Request",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    fetchMech() {
      return   Firestore.instance
          .collection("MECHDATA")
          .snapshots();
    }


    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Securide"),
          backgroundColor: Colors.blueGrey,
        ),
        body:Container(
          color: Colors.black12,
        child: Column(
          children: [
            SizedBox(height: 15.0),
            Center(child: Text('Mechanics List', textAlign: TextAlign.center,
                style: style)),
            // RaisedButton(
            //     child: Text("Logout"),
            //     onPressed: () async {
            //         getData();
            //     }
            // ),
            SizedBox(height: 20.0),
            Container(
              height: size.height * 0.8,
              child: StreamBuilder<QuerySnapshot>(
                stream: fetchMech(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return new Container(
                      child: Text(" No data"),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int i) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white
                              ),
                              width: size.width*1,
                              height: size.height*0.2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20), // if you need this
                                        side: BorderSide(
                                          color: Colors.grey.withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: Container(
                                        color: Colors.white,
                                        width: 400,
                                        height: 100,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Text("Owner Name: "),
                                                Text(snapshot.data.documents[i]["Name"]),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text("Garage Name: "),
                                                Text(snapshot.data.documents[i]["Garage Name"]),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text("Phone Number: "),
                                                Text(snapshot.data.documents[i]["Phone Number"]),
                                                IconButton(
                                                  icon: Icon(Icons.auto_awesome_motion),
                                                  onPressed: (){
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //       builder: (context) =>
                                                    //           StudentEdit(snapshot
                                                    //               .data.documents[i])),
                                                    // );
                                                  },
                                                )
                                              ],
                                            ),

                                          ],
                                        )
                                      ),
                                    ),

                                    // Row(
                                    //   children: [
                                    //     IconButton(
                                    //         icon: Icon(Icons.edit),
                                    //         onPressed: () {
                                    //           Navigator.push(
                                    //             context,
                                    //             MaterialPageRoute(
                                    //                 builder: (context) =>
                                    //                     StudentUpdate(snapshot
                                    //                         .data.docs[i])),
                                    //           );
                                    //         }),
                                    //     IconButton(
                                    //       icon: Icon(Icons.delete),
                                    //       onPressed: (){
                                    //         deleteStudent(i);
                                    //       },
                                    //     )                                      ],
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                },
              ),
            )
          ],
        ),
        ),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors
                .blueGrey, //This will change the drawer background to blue.
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
                  decoration: BoxDecoration(
                    color: Colors.red,
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Image.asset("assets/logo.png", fit: BoxFit.fitHeight,),
                  ),
                  accountName: null,
                  accountEmail: Text("Login As : "+"${user?.email}"),
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
                  title: btc,
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                  },
                ),
                ListTile(
                  title: request,
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                  },
                ),
                ListTile(

                  title: logout,
                  onTap: () {
                    // Update the state of the app
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
        );
  }
}
