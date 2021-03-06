// import 'dart:async';
// import 'package:app2020/screens/authenticate/msign_in.dart';
// import 'package:app2020/screens/homescreen/mrequest.dart';
// import 'package:app2020/screens/mapscreen/mapselect.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:app2020/services/authservice.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
//
// String userid;
// String role;
// String name;
// String gname;
// String pnumber;
// String email;
// double lat;
// double long;
// var document;
// final FirebaseAuth auth = FirebaseAuth.instance;
// FirebaseUser user;
// final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
// String _currentAddress;
// final AuthService _auth = AuthService();
//
// class Bermula extends StatelessWidget {
//
//   final Future _initFuture = Init.initialize();
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Initialization',
//       home: FutureBuilder(
//         future: _initFuture,
//         builder: (context, snapshot){
//           if (snapshot.connectionState == ConnectionState.done){
//             return MHome();
//           } else {
//             return SplashScreen();
//           }
//         },
//       ),
//     );
//   }
// }
//
// class Init {
//   static Future initialize() async {
//     await _registerServices();
//     await _loadSettings();
//   }
//
//   static _registerServices() async {
//     //TODO register services
//   }
//
//   static _loadSettings() async {
//     //TODO load settings
//   }
// }
//
// class SplashScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return SplashScreenState();
//   }
// }
//
// class SplashScreenState extends State<SplashScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(
//             image: AssetImage('assets/mg.jpg'), fit: BoxFit.cover),
//       ),
//       child: Center(
//         child: CircularProgressIndicator(
//           valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
//         ),
//       ),
//     );
//   }
// }
//
//
// class MHome extends StatefulWidget {
//   final appTitle = 'SECURIDE';
//
//   @override
//   _MHome createState() => _MHome();
// }
//
//
// class _MHome extends State<MHome> {
//   TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
//
//   @override
//   void initState() {
//     super.initState();
//     initUser();
//     _getAddressFromLatLng();
//     setState(() {});
//   }
//
//   initUser() async {
//     user = await auth.currentUser();
//   }
//
//   _getAddressFromLatLng() async {
//     try {
//       List<Placemark> p = await geolocator.placemarkFromCoordinates(lat, long);
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
//   Future<bool> _onBackPressed() {
//     return showDialog(
//       context: context,
//       builder: (context) => new AlertDialog(
//         title: new Text('Are you sure?'),
//         content: new Text('Do you want to exit the App'),
//         actions: <Widget>[
//           new GestureDetector(
//             onTap: () => Navigator.of(context).pop(false),
//             child: Text("NO"),
//           ),
//           SizedBox(height: 16),
//           new GestureDetector(
//             onTap: () {
//               auth.signOut();
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                   builder: (BuildContext context) => MSignIn(),
//                 ),
//                     (route) => false,
//               );
//             },
//             child: Text("YES"),
//           ),
//         ],
//       ),
//     ) ??
//         false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final shome = Material(
//       elevation: 5.0,
//       borderRadius: BorderRadius.circular(15.0),
//       color: Color(0xff01A0C7),
//       child: MaterialButton(
//         minWidth: MediaQuery.of(context).size.width,
//         padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//         onPressed: () async {
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(
//               builder: (BuildContext context) => MHome(),
//             ),
//                 (route) => false,
//           );
//         },
//         child: Text("Home",
//             textAlign: TextAlign.center,
//             style: style.copyWith(
//                 color: Colors.white, fontWeight: FontWeight.bold)),
//       ),
//     );
//
//     final mreq = Material(
//       elevation: 5.0,
//       borderRadius: BorderRadius.circular(15.0),
//       color: Color(0xff01A0C7),
//       child: MaterialButton(
//         minWidth: MediaQuery.of(context).size.width,
//         padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => Mrsplash()),
//           );
//         },
//         child: Text("Customer Request",
//             textAlign: TextAlign.center,
//             style: style.copyWith(
//                 color: Colors.white, fontWeight: FontWeight.bold)),
//       ),
//     );
//
//     final update = Material(
//       elevation: 5.0,
//       borderRadius: BorderRadius.circular(30.0),
//       color: Color(0xff01A0C7),
//       child: MaterialButton(
//         minWidth: MediaQuery.of(context).size.width * 0.6,
//         padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//         onPressed: () async {
//         },
//         child: Text("Update profile",
//             textAlign: TextAlign.center,
//             style: style.copyWith(
//                 color: Colors.white, fontWeight: FontWeight.bold)),
//       ),
//     );
//
//     final updmap = Material(
//       elevation: 5.0,
//       borderRadius: BorderRadius.circular(30.0),
//       color: Colors.lightGreen,
//       child: MaterialButton(
//         minWidth: MediaQuery.of(context).size.width * 0.6,
//         padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//         onPressed: () async {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => MapSplash()),
//           );
//         },
//         child: Text("Update Map",
//             textAlign: TextAlign.center,
//             style: style.copyWith(
//                 color: Colors.white, fontWeight: FontWeight.bold)),
//       ),
//     );
//
//     final logout = Material(
//       elevation: 5.0,
//       borderRadius: BorderRadius.circular(15.0),
//       color: Colors.red,
//       child: MaterialButton(
//         minWidth: MediaQuery.of(context).size.width * 0.3,
//         padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//         onPressed: () async {
//           dynamic result = await _auth.signOut();
//           if (result == null) {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(
//                 builder: (BuildContext context) => MSignIn(),
//               ),
//                   (route) => false,
//             );
//           }
//         },
//         child: Text("Logout",
//             textAlign: TextAlign.center,
//             style: style.copyWith(
//                 color: Colors.white, fontWeight: FontWeight.bold)),
//       ),
//     );
//
//     return WillPopScope(
//       onWillPop: _onBackPressed,
//       child: Scaffold(
//           resizeToAvoidBottomPadding: false,
//           backgroundColor: Colors.blueGrey,
//           appBar: AppBar(
//             title: Text("Rider Pocket Mechanic"),
//             backgroundColor: Colors.indigo,
//           ),
//           body: Column(
//             children: [
//               Card(
//                 color: Colors.grey,
//                 child: ListTile(
//                   title: Text(
//                     "YOUR GARAGE",
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   SizedBox(
//                     height: 50.0,
//                   ),
//                   Text(
//                     gname,
//                     style: TextStyle(
//                       fontFamily: 'Pacifico',
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18.0,
//                       color: Colors.white,
//                     ),
//                   ),
//                   Text(
//                     name,
//                     style: TextStyle(
//                       fontFamily: 'SourceSansPro',
//                       fontSize: 18.0,
//                       letterSpacing: 2.5,
//                       color: Colors.blue.shade50,
//                     ),
//                   ),
//                   Container(
//                     width: 200.0,
//                     margin: EdgeInsets.symmetric(vertical: 8.0),
//                     child: Divider(
//                       color: Colors.white,
//                     ),
//                   ),
//                   Card(
//                     margin:
//                     EdgeInsets.symmetric(horizontal: 48.0, vertical: 8.0),
//                     child: ListTile(
//                       leading: Icon(
//                         Icons.phone,
//                         color: Colors.teal.shade400,
//                       ),
//                       title: Text(
//                         pnumber,
//                         style: TextStyle(
//                           color: Colors.teal.shade400,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Card(
//                     margin:
//                     EdgeInsets.symmetric(horizontal: 48.0, vertical: 8.0),
//                     child: ListTile(
//                       leading: Icon(
//                         Icons.email,
//                         color: Colors.teal.shade400,
//                       ),
//                       title: Text(
//                         user.email,
//                         style: TextStyle(
//                           color: Colors.teal.shade400,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Card(
//                     margin:
//                     EdgeInsets.symmetric(horizontal: 48.0, vertical: 8.0),
//                     child: ListTile(
//                       leading: Icon(
//                         Icons.add_location_sharp,
//                         color: Colors.teal.shade400,
//                       ),
//                       title: Text(
//                         _currentAddress,
//                         style: TextStyle(
//                           color: Colors.teal.shade400,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 25.0,
//                   ),
//                   updmap,
//                   SizedBox(
//                     height: 25.0,
//                   ),
//                   update
//                 ],
//               ),
//             ],
//           ),
//           drawer: Theme(
//             data: Theme.of(context).copyWith(
//               canvasColor: Colors
//                   .indigo, //This will change the drawer background to blue.
//               //other styles
//             ),
//             child: Drawer(
//               child: ListView(
//                 padding: EdgeInsets.zero,
//                 children: <Widget>[
//                   UserAccountsDrawerHeader(
//                     accountName: null,
//                     accountEmail: Text("Login As : " + "${user?.email}"),
//                     currentAccountPicture: Image.asset(
//                       "assets/logo.png",
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                   ListTile(
//                     title: shome,
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                   ListTile(
//                     title: mreq,
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                   ListTile(
//                     title: logout,
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           )),
//     );
//   }
// }
