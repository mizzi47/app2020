import 'dart:async';
import 'package:app2020/screens/authenticate/sign_in.dart';
import 'package:app2020/screens/homescreen/home.dart';
import 'package:app2020/screens/homescreen/profile.dart';
import 'package:app2020/screens/homescreen/update.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app2020/services/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';

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

class Crequest extends StatefulWidget {
  final appTitle = 'Rider Pocket Mechanic';

  @override
  _Crequest createState() => _Crequest();
}

class Init {
  static Future initialize() async {
    await _registerServices();
    await _loadSettings();
  }

  static _registerServices() async {
    //TODO register services
    name = "";
    gname = "";
    pnumber = "";
    lat = null;
    long = null;
    user = await auth.currentUser();
    document = await Firestore.instance.collection('CLIENTDATA').document(user.uid).get();
    if (document.data['request'] == null) {
      reqId = "no";
    } else {
      reqId = document.data['request'].toString();
      status = document.data['status'].toString();
      mechdocument = await Firestore.instance.collection('MECHDATA').document(reqId).get();
      name = mechdocument.data['Name'].toString();
      gname = mechdocument.data['Garage Name'].toString();
      pnumber = mechdocument.data['Phone Number'].toString();
      lat = mechdocument.data['latitude'];
      long = mechdocument.data['longtitude'];
    }
    print(name + "ssd");
  }

  static _loadSettings() async {
    //TODO load settings
  }
}

class InitRequest extends StatelessWidget {

  final Future _initFuture = Init.initialize();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Initialization',
      home: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            return Crequest();
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
            image: AssetImage('assets/bg2.jpg'), fit: BoxFit.cover),
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
        ),
      ),
    );
  }
}

class _Crequest extends State<Crequest> {
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
    print(name + "crequestinit");
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
      borderRadius: BorderRadius.circular(10.0),
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

    final logout = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
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
      borderRadius: BorderRadius.circular(10.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.3,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => InitRequest(),
            ),
                (route) => false,
          );
        },
        child: Text("Current Request",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final update = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.3,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Update(),
            ),
                (route) => false,
          );
        },
        child: Text("Update Profile",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final view = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.3,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => InitializationView(),
            ),
                (route) => false,
          );
        },
        child: Text("View Profile",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final getlocation = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.lightGreen,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.3,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          final availableMaps = await MapLauncher.installedMaps;
          print(
              availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]
          await availableMaps.first.showMarker(
            coords: Coords(lat, long),
            title: gname,
          );
        },
        child: Text("Get Location",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final cancel = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.redAccent,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.3,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          Firestore.instance.collection('CLIENTDATA').document(user.uid).updateData({'request': FieldValue.delete(), 'status': FieldValue.delete()});
          Firestore.instance.collection('MECHDATA').document(reqId).collection('request').document(user.uid).delete();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => InitRequest(),
            ),
                (route) => false,
          );
        },
        child: Text("Cancel Request",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    Size size = MediaQuery.of(context).size;

    Widget _buildChild() {
      if (reqId == "no") {
        print(reqId + "widget");
        return new Container(
            color: Colors.black12,
            child: Column(children: [
              SizedBox(height: 15.0),
              Center(
                  child: Text('YOUR REQUEST',
                      textAlign: TextAlign.center, style: style)),
            ]));
      } else if (reqId != null) {
        print(reqId + "111");
        print(reqId + "222");
        print(reqId + "333");
        return Container(
          color: Colors.black12,
          child: Column(
            children: [
              SizedBox(height: 15.0),
              Center(
                  child: Text('YOUR REQUEST',
                      textAlign: TextAlign.center, style: style)),
              SizedBox(height: 20.0),
              Container(
                color: Colors.black38,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 25.0,
                    ),
                    Text(
                      '${gname}',
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${name}',
                      style: TextStyle(
                        fontFamily: 'SourceSansPro',
                        fontSize: 18.0,
                        letterSpacing: 2.5,
                        color: Colors.blue.shade50,
                      ),
                    ),
                    Container(
                      width: 200.0,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(
                        color: Colors.white,
                      ),
                    ),
                    Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 48.0, vertical: 8.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.phone,
                          color: Colors.teal.shade400,
                        ),
                        title: Text(
                          '${pnumber}',
                          style: TextStyle(
                            color: Colors.teal.shade400,
                          ),
                        ),
                      ),
                    ),
                    Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 48.0, vertical: 8.0),
                      child: ListTile(
                        leading: Text(
                          "STATUS: " + status,
                          style: TextStyle(
                            color: Colors.teal.shade400,
                          ),
                        ),
                      ),
                    ),
                    getlocation,
                    cancel,
                    SizedBox(height: 15.0)
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Rider Pocket Mechanic"),
          backgroundColor: Colors.blueGrey,
        ),
        body: _buildChild(),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.blueGrey,
          ),
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.black38,
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Image.asset(
                      "assets/logo.png",
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  accountName: null,
                  accountEmail: Text("Login As : " + "${user?.email}"),
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
                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  title: request,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: view,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: update,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: logout,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
