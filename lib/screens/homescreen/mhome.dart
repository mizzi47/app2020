import 'dart:async';

import 'package:app2020/screens/authenticate/msign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app2020/services/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app2020/screens/homescreen/mappage.dart';

String userid;
String role;
String name;
String gname;
String pnumber;
String email;
var document;
final FirebaseAuth auth = FirebaseAuth.instance;
FirebaseUser user;
final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
Position _currentPosition;
String _currentAddress;


class MHome extends StatefulWidget {
  final appTitle = 'SECURIDE';

  @override
  _MHome createState() => _MHome();
}

class SplashScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  // String userid;
  // String role;
  // String name;
  // String gname;
  // String pnumber;
  // String email;
  // var document;
  // final FirebaseAuth auth = FirebaseAuth.instance;
  // FirebaseUser user;
  // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  // Position _currentPosition;
  // String _currentAddress;
  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }
  initUser() async {
    user = await auth.currentUser();
    document = await Firestore.instance.collection('MECHDATA')
        .document(user.uid)
        .get();
    _getCurrentLocation();
    name = document.data['Name'].toString();
    gname = document.data['Garage Name'].toString();
    pnumber = document.data['Phone Number'].toString();
    print(user.uid);
    print(name);
    print(pnumber);
    // _MHome().name = name;
    // _MHome().gname = gname;
    // _MHome().pnumber = pnumber;
    setState(() {});
    //print(user.uid);
  }

  @override
  void initState() {
    super.initState();
    initUser();
    loadData();
  }


  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 5), onDoneLoading);

  }

  onDoneLoading() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MHome()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/mg.jpg'),
            fit: BoxFit.cover
        ) ,
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
        ),
      ),
    );
  }
}

class _MHome extends State<MHome> {

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    initUser();
    _getCurrentLocation();
  }

  initUser() async {
    user = await auth.currentUser();
    print(name+"fddfd");
    setState(() {});
  }

    _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    final shome = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular( 15.0),
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
      borderRadius: BorderRadius.circular(15.0),
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

    final update = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.6,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async{
          print(_currentAddress);
          print(user.uid);
          print(user.email);
          var docs = await Firestore.instance.collection('MECHDATA')
              .document(user.uid)
              .get();
          if(docs == null){
            print("no");
          }
          else{
            print("yes");
            if(docs!=null){
              String role = docs.data['Name'].toString();
              print(role);
            }
          }
        },


        child: Text("Update profile",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final updmap = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.lightGreen,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.6,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async{
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MapP()),
          );
        },


        child: Text("Update profile",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final logout = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
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
      backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: Text("Rider Pocket Mechanic"),
          backgroundColor: Colors.indigo,
        ),
        body: Column(
          children: [
            Card(
              color: Colors.grey,
              child: ListTile(
                title: Text(
                  "YOUR GARAGE",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Column(

              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  gname,
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0,
                    color: Colors.white,
                  ),
                ),
                Text(
                  name,
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
                  margin: EdgeInsets.symmetric(horizontal: 48.0, vertical: 8.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: Colors.teal.shade400,
                    ),
                    title: Text(
                      pnumber,
                      style: TextStyle(
                        color: Colors.teal.shade400,
                      ),
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 48.0, vertical: 8.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.email,
                      color: Colors.teal.shade400,
                    ),
                    title: Text(
                      user.email,
                      style: TextStyle(
                        color: Colors.teal.shade400,
                      ),
                    ),
                  ),
                ),

                Card(
                  margin: EdgeInsets.symmetric(horizontal: 48.0, vertical: 8.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.add_location_sharp,
                      color: Colors.teal.shade400,
                    ),
                    title: Text(
                      _currentAddress,
                      style: TextStyle(
                        color: Colors.teal.shade400,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                updmap,
                SizedBox(
                  height: 25.0,
                ),
                update
              ],
            ),
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
