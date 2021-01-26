import 'package:flutter/material.dart';
import 'package:app2020/models/user.dart';
import 'package:app2020/services/authservice.dart';
import 'package:provider/provider.dart';
import 'package:app2020/screens/authenticate/root.dart';


void main()async {

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().user,
        child: MaterialApp(
          home: Root()
        )
    );
  }
}
