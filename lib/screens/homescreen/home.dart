import 'dart:async';
import 'package:app2020/screens/authenticate/sign_in.dart';
import 'package:app2020/screens/homescreen/request.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app2020/services/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as a;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:geodesy/geodesy.dart' as d;

var document;
var mechdocument;
String name;
String bname;
String pnumber;
final FirebaseAuth auth = FirebaseAuth.instance;
FirebaseUser user;
String uemail;
final AuthService _auth = AuthService();
d.Geodesy geodesy = d.Geodesy();
a.Position _currentPosition;

_getCurrentLocation() {
  geolocator
      .getCurrentPosition(desiredAccuracy: a.LocationAccuracy.best)
      .then((a.Position position) {
    _currentPosition = position;

  }).catchError((e) {
    print(e);
  });
}


Location location = Location();//explicit reference to the Location class
Future _checkGps() async {
  if (!await location.serviceEnabled()) {
    location.requestService();
  }
}

class Init {
  static Future initialize() async {
    await _registerServices();
    await _loadSettings();
  }

  static _registerServices() async {
    //TODO register services
    user = await auth.currentUser();
    uemail = user.email;
    document = await Firestore.instance.collection('CLIENTDATA').document(user.uid).get();
    name = document.data['Name'].toString();
    bname = document.data['Bike Name'].toString();
    pnumber = document.data['Phone Number'].toString();
  }

  static _loadSettings() async {
    //TODO load settings
  }
}

class InitializationApp extends StatelessWidget {

  final Future _initFuture = Init.initialize();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Initialization',
      home: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            return Home();
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


class Home extends StatefulWidget {
  final appTitle = 'Rider Pocket Mechanic';

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  List<Marker> myMarker = [];
  String userid;
  String role;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  GoogleMapController _controller;
  a.Position ps;

  @override
  void initState() {
    super.initState();
    initUser();
    setState(() {});
  }

  initUser() async {
    user = await auth.currentUser();
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  goreq(String mid) async {
    print(user.uid);
    print(mid);
    await _auth.reqMech(mid);
    await _auth.addToMech(mid, name, bname, pnumber);
  }

  calcDistance(double alat, double along, double blat, double blong){
    d.LatLng aa = d.LatLng(alat, along);
    d.LatLng bb = d.LatLng(blat, blong);
    num distance = geodesy.distanceBetweenTwoGeoPoints(aa, bb);
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
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;


    showAlertDialog(BuildContext context) {
      AlertDialog alert = AlertDialog(
        content: new Row(
          children: [
            CircularProgressIndicator(),
            Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
          ],
        ),
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

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

    fetchMech() {
      return Firestore.instance.collection("MECHDATA").snapshots();
    }

    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
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
                  child: Text('Mechanics List',
                      textAlign: TextAlign.center, style: style)),
              SizedBox(height: 20.0),
              Expanded(
                child: Container(
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
                                          margin: new EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 6.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    64, 75, 96, .9)),
                                            child: ListTile(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 10.0),
                                              leading: Container(
                                                padding: EdgeInsets.only(
                                                    right: 12.0),
                                                decoration: new BoxDecoration(
                                                    border: new Border(
                                                        right: new BorderSide(
                                                            width: 1.0,
                                                            color: Colors
                                                                .white24))),
                                                child: Icon(
                                                    Icons.water_damage_sharp,
                                                    color: Colors.white),
                                              ),
                                              title: Text(
                                                snapshot.data.documents[i]
                                                    ["Garage Name"],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                              subtitle: Row(
                                                children: <Widget>[
                                                  Icon(
                                                      Icons
                                                          .account_circle_rounded,
                                                      color:
                                                          Colors.yellowAccent),
                                                  Text(
                                                      snapshot.data.documents[i]
                                                          ["Name"],
                                                      style: TextStyle(
                                                          color: Colors.white))
                                                ],
                                              ),
                                              trailing: IconButton(
                                                  icon: Icon(
                                                      Icons
                                                          .keyboard_arrow_right,
                                                      color: Colors.white,
                                                      size: 30.0),
                                                  onPressed: () async{
                                                    myMarker.add(Marker(
                                                        markerId: MarkerId(snapshot
                                                                .data
                                                                .documents[i]
                                                            ["Garage Name"]),
                                                        draggable: true,
                                                        onTap: () {},
                                                        position: LatLng(
                                                            snapshot.data
                                                                    .documents[
                                                                i]["latitude"],
                                                            snapshot.data
                                                                    .documents[i]
                                                                [
                                                                "longtitude"])));
                                                    _serviceEnabled = await location.serviceEnabled();
                                                    if (!_serviceEnabled) {
                                                      _serviceEnabled = await location.requestService();

                                                      if (!_serviceEnabled) {
                                                        return Home();
                                                      }
                                                    }
                                                    _getCurrentLocation();
                                                    d.LatLng aa = d.LatLng(_currentPosition.latitude, _currentPosition.longitude);
                                                    d.LatLng bb = d.LatLng(snapshot.data.documents[i]["latitude"],  snapshot.data.documents[i]["longtitude"]);
                                                    print(aa);
                                                    print(bb);
                                                    num distance = geodesy.distanceBetweenTwoGeoPoints(aa, bb);
                                                    print(distance);
                                                    distance = distance/1000;
                                                    distance = num.parse((distance).toStringAsFixed(2));
                                                    showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      // user must tap button!
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(snapshot
                                                                  .data
                                                                  .documents[i]
                                                              ["Garage Name"]),
                                                          content: SingleChildScrollView(
                                                            child: ListBody(
                                                              children: <Widget>[
                                                                Container(
                                                                    decoration: BoxDecoration(
                                                                      color: Theme.of(context).canvasColor,
                                                                    ),
                                                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                                    child: Column(
                                                                      children: <Widget>[
                                                                        Row(
                                                                          children: <Widget>[
                                                                            Icon(Icons.alt_route_sharp),
                                                                            SizedBox(
                                                                              width: 8,
                                                                            ),
                                                                            Expanded(
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    'DISTANCE: ' + distance.toString()+" KM",
                                                                                    style: Theme.of(context).textTheme.caption,
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 8,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    )),
                                                                Container(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.5,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  child:
                                                                      GoogleMap(
                                                                    initialCameraPosition: CameraPosition(
                                                                        target: LatLng(
                                                                            snapshot.data.documents[i][
                                                                                "latitude"],
                                                                            snapshot.data.documents[i][
                                                                                "longtitude"]),
                                                                        zoom:
                                                                            15.0),
                                                                    onMapCreated:
                                                                        mapCreated,
                                                                    markers: Set
                                                                        .from(
                                                                            myMarker),
                                                                  ),
                                                                ),
                                                                Material(
                                                                  elevation:
                                                                      5.0,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15.0),
                                                                  color: Color(
                                                                      0xff01A0C7),
                                                                  child:
                                                                      MaterialButton(
                                                                    minWidth: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.1,
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            20.0,
                                                                            15.0,
                                                                            20.0,
                                                                            15.0),
                                                                    onPressed:
                                                                        () async {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false,
                                                                        // user must tap button!
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Text('Are You Sure?'),
                                                                            content:
                                                                                SingleChildScrollView(
                                                                              child: ListBody(
                                                                                children: <Widget>[
                                                                                  Text('You to request for this mechanic?'),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            actions: <Widget>[
                                                                              TextButton(
                                                                                child: Text('RequestNow!'),
                                                                                onPressed: () {
                                                                                  showAlertDialog(context);
                                                                                  goreq(snapshot.data.documents[i].documentID);
                                                                                  Navigator.pop(context);
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    barrierDismissible: false,
                                                                                    // user must tap button!
                                                                                    builder: (BuildContext context) {
                                                                                      return AlertDialog(
                                                                                        title: Text('Success!'),
                                                                                        content: SingleChildScrollView(
                                                                                          child: ListBody(
                                                                                            children: <Widget>[
                                                                                              Text('Your request have been submitted'),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        actions: <Widget>[
                                                                                          TextButton(
                                                                                            child: Text('OK'),
                                                                                            onPressed: () {
                                                                                              Navigator.of(context).pop();
                                                                                              Navigator.of(context).pop();
                                                                                            },
                                                                                          ),
                                                                                        ],
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                },
                                                                              ),
                                                                              TextButton(
                                                                                child: Text('No'),
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child: Text(
                                                                        "Request",
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        style: style.copyWith(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold)),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            Align(
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                              child: TextButton(
                                                                child: Text(
                                                                    'Back'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                              child: TextButton(
                                                                child: Text(
                                                                    'Call'),
                                                                onPressed: () {
                                                                  // Navigator.of(context).pop();
                                                                  UrlLauncher.launch('tel:' +
                                                                      snapshot
                                                                          .data
                                                                          .documents[i]["Phone Number"]);
                                                                },
                                                              ),
                                                            ),
                                                            TextButton(
                                                              child:
                                                                  Text('Route'),
                                                              onPressed:
                                                                  () async {
                                                                final availableMaps =
                                                                    await MapLauncher
                                                                        .installedMaps;
                                                                print(
                                                                    availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

                                                                await availableMaps
                                                                    .first
                                                                    .showMarker(
                                                                  coords: Coords(
                                                                      snapshot.data
                                                                              .documents[i]
                                                                          [
                                                                          "latitude"],
                                                                      snapshot
                                                                          .data
                                                                          .documents[i]["longtitude"]),
                                                                  title: snapshot
                                                                          .data
                                                                          .documents[i]
                                                                      [
                                                                      "Garage Name"],
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
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
