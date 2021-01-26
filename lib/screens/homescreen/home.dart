import 'dart:async';
import 'package:app2020/screens/authenticate/sign_in.dart';
import 'file:///C:/Users/mizi/AndroidStudioProjects/app2020/lib/screens/mapscreen/mappage.dart';
import 'package:app2020/screens/homescreen/mhome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app2020/services/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';

var document;
String name;
final FirebaseAuth auth = FirebaseAuth.instance;
FirebaseUser user;
String uemail;
final AuthService _auth = AuthService();

class Home extends StatefulWidget {
  final appTitle = 'Rider Pocket Mechanic';
  @override
  _Home createState() => _Home();
}

class SplashScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {

  initUser() async {
    user = await auth.currentUser();
    print("init  "+user.uid);
    print("init  "+user.email);
    uemail = user.email;
    print("uEmail  "+uemail);
    document = await Firestore.instance.collection('CLIENTDATA')
        .document(user.uid)
        .get();
    name = document.data['Name'].toString();
  }

  @override
  void initState() {
    super.initState();
    initUser();
    loadData();
    setState(() {});
  }


  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 5), onDoneLoading);

  }

  onDoneLoading() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/bg2.jpg'),
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

class _Home extends State<Home> {
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
  }

  showAlertDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5),child:Text("Loading" )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
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
          print(uemail);
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

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Card(
                                      elevation: 8.0,
                                      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                      child: Container(
                                        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                                        child: ListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                            leading: Container(
                                              padding: EdgeInsets.only(right: 12.0),
                                              decoration: new BoxDecoration(
                                                  border: new Border(
                                                      right: new BorderSide(width: 1.0, color: Colors.white24))),
                                              child: Icon(Icons.water_damage_sharp, color: Colors.white),
                                            ),
                                            title: Text(
                                              snapshot.data.documents[i]["Garage Name"],
                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                            subtitle: Row(
                                              children: <Widget>[
                                                Icon(Icons.account_circle_rounded, color: Colors.yellowAccent),
                                                Text(snapshot.data.documents[i]["Name"], style: TextStyle(color: Colors.white))
                                              ],
                                            ),
                                            trailing:
                                            IconButton(icon: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
                                            onPressed: (){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => MapP()),
                                              );
                                              // myMarker.add(Marker(
                                              //     markerId: MarkerId(snapshot.data.documents[i]["Garage Name"]),
                                              //     draggable: true,
                                              //     onTap: () {
                                              //     },
                                              //     position: LatLng(snapshot.data.documents[i]["latitude"], snapshot.data.documents[i]["longtitude"])));
                                              // showDialog(
                                              //   context: context,
                                              //   barrierDismissible: false, // user must tap button!
                                              //   builder: (BuildContext context) {
                                              //     return AlertDialog(
                                              //       title: Text(snapshot.data.documents[i]["Garage Name"]),
                                              //       content: SingleChildScrollView(
                                              //         child: ListBody(
                                              //           children: <Widget>[
                                              //             Text(snapshot.data.documents[i]["latitude"].toString()),
                                              //             Text(snapshot.data.documents[i]["longtitude"].toString()),
                                              //             Container(
                                              //               height: MediaQuery.of(context).size.height*0.5,
                                              //               width: MediaQuery.of(context).size.width,
                                              //               child: GoogleMap(
                                              //                 initialCameraPosition: CameraPosition(target:LatLng(snapshot.data.documents[i]["latitude"], snapshot.data.documents[i]["longtitude"]), zoom: 15.0),
                                              //                 onMapCreated: mapCreated,
                                              //                 markers: Set.from(myMarker),
                                              //               ),
                                              //             ),
                                              //           ],
                                              //         ),
                                              //       ),
                                              //       actions: <Widget>[
                                              //         TextButton(
                                              //           child: Text('OK'),
                                              //           onPressed: () {
                                              //             Navigator.of(context).pop();
                                              //           },
                                              //         ),
                                              //         TextButton(
                                              //           child: Text('Route'),
                                              //           onPressed: () async{
                                              //             final availableMaps = await MapLauncher.installedMaps;
                                              //             print(availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]
                                              //
                                              //             await availableMaps.first.showMarker(
                                              //               coords: Coords(snapshot.data.documents[i]["latitude"], snapshot.data.documents[i]["longtitude"]),
                                              //               title: snapshot.data.documents[i]["Garage Name"],
                                              //             );
                                              //           },
                                              //         ),
                                              //       ],
                                              //     );
                                              //   },
                                              // );
                                            }
                                            ),

                                        ),
                                      ),

                                      // child: Container(
                                      //   color: Colors.white,
                                      //   width: 400,
                                      //   height: 100,
                                      //   child: Column(
                                      //     crossAxisAlignment: CrossAxisAlignment.center,
                                      //     children: [
                                      //       Row(
                                      //         children: [
                                      //           Text("Owner Name: "),
                                      //           Text(snapshot.data.documents[i]["Name"]),
                                      //         ],
                                      //       ),
                                      //       Row(
                                      //         children: [
                                      //           Text("Garage Name: "),
                                      //           Text(snapshot.data.documents[i]["Garage Name"]),
                                      //         ],
                                      //       ),
                                      //       Row(
                                      //         children: [
                                      //           Text("Phone Number: "),
                                      //           Text(snapshot.data.documents[i]["Phone Number"]),
                                      //           IconButton(
                                      //             icon: Icon(Icons.auto_awesome_motion),
                                      //             onPressed: (){
                                      //               // Navigator.push(
                                      //               //   context,
                                      //               //   MaterialPageRoute(
                                      //               //       builder: (context) =>
                                      //               //           StudentEdit(snapshot
                                      //               //               .data.documents[i])),
                                      //               // );
                                      //             },
                                      //           )
                                      //         ],
                                      //       ),
                                      //
                                      //     ],
                                      //   )
                                      // ),
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
