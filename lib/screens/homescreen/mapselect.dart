import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart' as a;
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app2020/services/authservice.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
FirebaseUser user;
TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
List<Marker> allMarkers = [];
List<Marker> myMarker = [];
LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
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

class _MapS extends State<MapS> {

  void _onMapCreated(GoogleMapController _cntlr)
  {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 15),
        ),
      );
    });
  }

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
    allMarkers.add(Marker(
        markerId: MarkerId('myMarker'),
        draggable: true,
        onTap: () {
          print('Marker Tapped');
        },
        position: LatLng(40.7128, -74.0060)));
  }

  initUser() async {
    user = await auth.currentUser();
    print(user.email);
    setState(() {});
    //print(user.uid);
  }

  @override
  Widget build(BuildContext context) {

    final savemap = Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.purple,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.6,
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        onPressed: () {

            _auth.updateMap(lat, long);
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
              initialCameraPosition: CameraPosition(target: _initialcameraposition),
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

  movetoBoston() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(42.3601, -71.0589), zoom: 14.0, bearing: 45.0, tilt: 45.0),
    ));
  }

  movetoNewYork() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 12.0),
    ));
  }

  movetoMy() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(_currentPosition.latitude, _currentPosition.longitude), zoom: 12.0),
    ));
  }
}
