import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart' as a;
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app2020/services/authservice.dart';
import 'package:app2020/screens/homescreen/mhome.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
FirebaseUser user;
TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
List<Marker> allMarkers = [];
List<Marker> myMarker = [];
Location _location = Location();
final a.Geolocator geolocator = a.Geolocator()..forceAndroidLocationManager;
a.Position _currentPosition;
String _currentAddress;
final AuthService _auth = AuthService();
GoogleMapController _controller;
double lat;
double long;

class MapS extends StatefulWidget {
  @override
  _MapS createState() => _MapS();
}

class MapSplash extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<MapSplash> {
  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: a.LocationAccuracy.best)
        .then((a.Position position) {
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
      List<a.Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      a.Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }


  @override
  void initState() {
    super.initState();
    loadData();
    _getCurrentLocation();
    setState(() {});
  }


  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 5), onDoneLoading);

  }

  onDoneLoading() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MapS()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/map.png'),
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




class _MapS extends State<MapS> {

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: a.LocationAccuracy.best)
        .then((a.Position position) {
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
      List<a.Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      a.Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initUser();
    _getCurrentLocation();
    setState(() {});
  }

  initUser() async {
    user = await auth.currentUser();
  }


  @override
  Widget build(BuildContext context) {

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


    final savemap = Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.purple,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.6,
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        onPressed: () async {
          showAlertDialog(context);
            await _auth.updateMap(lat, long);
            Navigator.pop(context);
            showDialog(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Success'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('Location have been saved!'),
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
        },
        child: Text("Save Location",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );


    return Scaffold(
      appBar: AppBar(
        title: Text('Maps'),
      ),
      body: Stack(
          children: [Container(
            height: MediaQuery.of(context).size.height*0.8,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target:LatLng(_currentPosition.latitude, _currentPosition.longitude), zoom: 12.0),
              markers: Set.from(myMarker),
              onMapCreated: mapCreated,
              onTap: _handleTap,
            ),
          ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                child: Container(
                  height: 40.0,
                  width: 200.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.green
                  ),
                  child: savemap
                ),
              ),
            ),
            SizedBox(
              height: 25.0,
            )
          ]
      ),
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  _handleTap(LatLng tappedPoint){
    print(tappedPoint);
    setState(() {
        myMarker = [];
        myMarker.add(Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          draggable: true,
        ));
    });
    lat = tappedPoint.latitude;
    long = tappedPoint.longitude;
    print(lat);
    print(long);
  }

}
