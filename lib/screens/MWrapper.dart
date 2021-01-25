import 'package:app2020/screens/authenticate/msign_in.dart';
import 'package:flutter/material.dart';
import 'package:app2020/models/user.dart';
import 'package:app2020/screens/homescreen/mhome.dart';
import 'package:provider/provider.dart';

class MWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    if(user == null){
      return MSignIn();
    } else {
      // print(user.uid);
      return SplashScreen();
    }

    //return Authenticate();
  }
}