import 'dart:async';
import 'package:app2020/screens/authenticate/msign_in.dart';
import 'package:app2020/screens/authenticate/sign_in.dart';
import 'package:app2020/screens/homescreen/mhome.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app2020/services/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String name = "";
String uemail = "";
String gname = "";
String pnumber = "";
String status = "";
String reqId = "";
double lat = 0;
double long = 0;
var document;
var mechdocument;
final FirebaseAuth auth = FirebaseAuth.instance;
FirebaseUser user;
final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
final AuthService _auth = AuthService();

class Init {
  static Future initialize() async {
    await _registerServices();
    await _loadSettings();
  }

  static _registerServices() async {
    //TODO register services
    user = await auth.currentUser();
    document = await Firestore.instance.collection('MECHDATA').document(user.uid).get();
  }

  static _loadSettings() async {
    //TODO load settings
  }

}

class InitMrequest extends StatelessWidget {

  final Future _initFuture = Init.initialize();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Initialization',
      home: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            return Mrequest();
          } else {
            return SplashScreen();
          }
        },
      ),
    );
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



class Mrequest extends StatefulWidget {
  IconData ic = Icons.star_border;

  final appTitle = 'Rider Pocket Mechanic';

  @override
  _Mrequest createState() => _Mrequest();
}

class _Mrequest extends State<Mrequest> {
  List<Marker> myMarker = [];
  String userid;
  String role;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  GoogleMapController _controller;
  Position ps;

  @override
  void initState() {
    super.initState();
    initUser();
    setState(() {});
  }

  initUser() async {
    user = await auth.currentUser();
    print(name + "MR INIT UID" + user.uid);
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  cancelreq(String uid) async {
    await _auth.reqMech(uid);
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit the App'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () {
              auth.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SignIn(),
                ),
                    (route) => false,
              );
            },
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
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

    final logout = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.red,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.3,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          dynamic result = await _auth.signOut();
          if (result == null) {
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

    final mreq = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => InitMrequest(),
            ),
                (route) => false,
          );
        },
        child: Text("Customer Request",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final history = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
        },
        child: Text("History",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );



    Size size = MediaQuery.of(context).size;


    fetchClient() {
      return Firestore.instance.collection("MECHDATA").document(user.uid).collection("request").snapshots();
    }

    openAlertBox() {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: EdgeInsets.only(top: 10.0),
              content: Container(
                width: 300.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Rate",
                          style: TextStyle(fontSize: 24.0),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.star_border, color:Color(0xff00bfa5)),
                              onPressed: () {
                                setState(() {
                                  Icon(Icons.star, color: Color(0xff00bfa5));
                                });
                              },
                            ),
                            Icon(
                              Icons.star_border,
                              color: Color(0xff00bfa5),
                              size: 30.0,

                            ),
                            Icon(
                              Icons.star_border,
                              color: Color(0xff00bfa5),
                              size: 30.0,
                            ),
                            Icon(
                              Icons.star_border,
                              color: Color(0xff00bfa5),
                              size: 30.0,
                            ),
                            Icon(
                              Icons.star_border,
                              color: Color(0xff00bfa5),
                              size: 30.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Add Review",
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          color: Color(0xff00bfa5),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(32.0),
                              bottomRight: Radius.circular(32.0)),
                        ),
                        child: Text(
                          "Rate Product",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }


    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Rider Pocket Mechanic"),
          backgroundColor: Colors.blueGrey,
        ),
        body: Container(
          color: Colors.black12,
          child: Column(
            children: [
              SizedBox(height: 15.0),
              Center(
                  child: Text('Customer Requests',
                      textAlign: TextAlign.center, style: style)),
              SizedBox(height: 20.0),
              Expanded(
                child: Container(
                  height: size.height * 0.8,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: fetchClient(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        print("buildchild");
                        return new Container(
                          child: Text(" No data "),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int i,) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    decoration:
                                    BoxDecoration(color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Card(
                                            elevation: 8.0,
                                            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                            child: Container(
                                              decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                                              child: ListTile(
                                                contentPadding:
                                                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                                leading: Container(
                                                  padding: EdgeInsets.only(right: 12.0),
                                                  decoration: new BoxDecoration(
                                                      border: new Border(
                                                          right: new BorderSide(width: 1.0, color: Colors.white24))),
                                                  child: Icon(Icons.accessibility_new_rounded, color: Colors.white),
                                                ),
                                                title: Text(snapshot.data.documents[i]["Name"], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                ),
                                                subtitle: Row(
                                                  children: <Widget>[
                                                    Icon(Icons.agriculture_outlined, color: Colors.yellowAccent),
                                                    Text(snapshot.data.documents[i]["Bike Name"], style: TextStyle(color: Colors.white))
                                                  ],
                                                ),
                                                trailing: IconButton(
                                                    icon: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible: false, // user must tap button!
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text('Accept Request'),
                                                            content: SingleChildScrollView(
                                                              child: ListBody(
                                                                children: <Widget>[
                                                                  Text('REQUEST HANDLING'),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                style: TextButton.styleFrom(
                                                                  primary: Colors.blue,
                                                                ),
                                                                child: Text('Cancel'),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),


                                                              TextButton(
                                                                style: TextButton.styleFrom(
                                                                  primary: Colors.red,
                                                                ),
                                                                child: Text('DECLINE'),

                                                                onPressed: () {
                                                                  showDialog(
                                                                    context: context,
                                                                    barrierDismissible: false, // user must tap button!
                                                                    builder: (BuildContext context) {
                                                                      return AlertDialog(
                                                                        title: Text('DECLINE?'),
                                                                        content: SingleChildScrollView(
                                                                          child: ListBody(
                                                                            children: <Widget>[
                                                                              Text('Are you sure to decline this request?'),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        actions: <Widget>[
                                                                          TextButton(
                                                                            style: TextButton.styleFrom(
                                                                              primary: Colors.blue,
                                                                            ),
                                                                            child: Text('Cancel'),
                                                                            onPressed: () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                          TextButton(
                                                                            style: TextButton.styleFrom(
                                                                              primary: Colors.red,
                                                                            ),
                                                                            child: Text('CONFIRM'),

                                                                            onPressed: () async {
                                                                              print(user.uid);
                                                                              Firestore.instance.collection('CLIENTDATA').document(snapshot.data.documents[i].documentID).updateData({'request': FieldValue.delete(),'status': FieldValue.delete() });
                                                                              Firestore.instance.collection('MECHDATA').document(user.uid).collection('request').document(snapshot.data.documents[i].documentID).delete();
                                                                              Navigator.pushAndRemoveUntil(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                  builder: (BuildContext context) => InitMrequest(),
                                                                                ),
                                                                                    (route) => false,
                                                                              );
                                                                            },
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                              TextButton(
                                                                style: TextButton.styleFrom(
                                                                  primary: Colors.green,
                                                                ),
                                                                child: Text('ACCEPT'),
                                                                onPressed: () {
                                                                  showDialog(
                                                                    context: context,
                                                                    barrierDismissible: false, // user must tap button!
                                                                    builder: (BuildContext context) {
                                                                      return AlertDialog(
                                                                        title: Text('ACCEPT?'),
                                                                        content: SingleChildScrollView(
                                                                          child: ListBody(
                                                                            children: <Widget>[
                                                                              Text('Are you sure to accept this request?'),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        actions: <Widget>[
                                                                          TextButton(
                                                                            style: TextButton.styleFrom(
                                                                              primary: Colors.blue,
                                                                            ),
                                                                            child: Text('Cancel'),
                                                                            onPressed: () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                          TextButton(
                                                                            style: TextButton.styleFrom(
                                                                              primary: Colors.green,
                                                                            ),
                                                                            child: Text('CONFIRM'),

                                                                            onPressed: () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors
                  .indigo, //This will change the drawer background to blue.
              //other styles
            ),
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: null,
                    accountEmail: Text("Login As : " + "${user?.email}"),
                    currentAccountPicture: Image.asset(
                      "assets/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  ListTile(
                    title: shome,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: mreq,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: logout,
                    onTap: () {
                    },
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
