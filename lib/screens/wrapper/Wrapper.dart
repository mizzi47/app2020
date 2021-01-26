import 'package:app2020/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:app2020/models/user.dart';
import 'package:app2020/screens/homescreen/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    if(user == null){
      return SignIn();
    } else {
      // print(user.uid);
      return SplashScreen();
    }

    //return Authenticate();
  }
}

// class Wrapper extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//
//     final user = Provider.of<User>(context);
//
//     if(user == null){
//       return Authenticate();
//     } else {
//       return Root();
//     }
//     //return Authenticate();
//   }
// }