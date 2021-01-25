import 'package:geolocator/geolocator.dart' as a;
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapS extends StatefulWidget {
  @override
  _MapS createState() => _MapS();
}

class _MapS extends State<MapS> {
  List<Marker> allMarkers = [];
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  Location _location = Location();
  final a.Geolocator geolocator = a.Geolocator()..forceAndroidLocationManager;
  a.Position _currentPosition;
  String _currentAddress;

  GoogleMapController _controller;
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
    _getCurrentLocation();
    allMarkers.add(Marker(
        markerId: MarkerId('myMarker'),
        draggable: true,
        onTap: () {
          print('Marker Tapped');
        },
        position: LatLng(40.7128, -74.0060)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps'),
      ),
      body: Stack(
          children: [Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: _initialcameraposition),
              markers: Set.from(allMarkers),
              onMapCreated: mapCreated,
            ),
          ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                // onTap: movetoMy,
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.green
                  ),
                  child: Icon(Icons.where_to_vote, color: Colors.white),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                // onTap: movetoNewYork,
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.red
                  ),
                  child: Icon(Icons.backspace, color: Colors.white),
                ),
              ),
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
