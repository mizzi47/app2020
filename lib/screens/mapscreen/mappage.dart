import 'package:geolocator/geolocator.dart' as a;
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapP extends StatefulWidget {
  @override
  _MapP createState() => _MapP();
}

class _MapP extends State<MapP> {
  List<Marker> allMarkers = [];
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  Location _location = Location();
  final a.Geolocator geolocator = a.Geolocator()..forceAndroidLocationManager;
  a.Position _currentPosition;
  String _currentAddress;

  GoogleMapController _controller;

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
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
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            initialCameraPosition:
                CameraPosition(target: _initialcameraposition),
            markers: Set.from(allMarkers),
            onMapCreated: mapCreated,
          ),
        ),
        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: InkWell(
        //     onTap: movetoMy,
        //     child: Container(
        //       height: 40.0,
        //       width: 40.0,
        //       decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(20.0),
        //           color: Colors.green),
        //       child: Icon(Icons.forward, color: Colors.white),
        //     ),
        //   ),
        // ),
        // Align(
        //   alignment: Alignment.bottomRight,
        //   child: InkWell(
        //     onTap: movetoNewYork,
        //     child: Container(
        //       height: 40.0,
        //       width: 40.0,
        //       decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(20.0), color: Colors.red),
        //       child: Icon(Icons.backspace, color: Colors.white),
        //     ),
        //   ),
        // )
      ]),
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  movetoMy() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
          zoom: 20.0),
    ));
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
//
// class MapP extends StatefulWidget {
//   @override
//   _MapP createState() => _MapP();
// }
//
// class _MapP extends State<MapP> {
//   final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
//   Position _currentPosition;
//   String _currentAddress;
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//   _getCurrentLocation() {
//     geolocator
//         .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//         .then((Position position) {
//       setState(() {
//         _currentPosition = position;
//       });
//
//       _getAddressFromLatLng();
//     }).catchError((e) {
//       print(e);
//     });
//   }
//
//   _getAddressFromLatLng() async {
//     try {
//       List<Placemark> p = await geolocator.placemarkFromCoordinates(
//           _currentPosition.latitude, _currentPosition.longitude);
//
//       Placemark place = p[0];
//
//       setState(() {
//         _currentAddress =
//         "${place.locality}, ${place.postalCode}, ${place.country}";
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("DASHBOARD"),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).canvasColor,
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: Column(
//                   children: <Widget>[
//                     Row(
//                       children: <Widget>[
//                         Icon(Icons.location_on),
//                         SizedBox(
//                           width: 8,
//                         ),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Text(
//                                 'Location',
//                                 style: Theme.of(context).textTheme.caption,
//                               ),
//                               if (_currentPosition != null &&
//                                   _currentAddress != null)
//                                 Text(_currentAddress,
//                                     style:
//                                     Theme.of(context).textTheme.bodyText2),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           width: 8,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
// }
