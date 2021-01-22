import 'package:app2020/screens/authenticate/msign_in.dart';
import 'package:app2020/screens/homescreen//mhome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:app2020/services/authservice.dart';
import 'package:app2020/shared/constants.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class MRegister extends StatefulWidget {

  final Function toggleView;
  MRegister({this.toggleView});
  @override
  _MRegisterState createState() => _MRegisterState();
}

class _MRegisterState extends State<MRegister> {

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final AuthService _auth = AuthService();
  final formkey = GlobalKey<FormState>();
  TextEditingController email =new TextEditingController();
  TextEditingController pw = new TextEditingController();
  TextEditingController nm =new  TextEditingController();
  TextEditingController gm =new  TextEditingController();
  TextEditingController pn =new  TextEditingController();
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/mg.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset(
                    "assets/logo.png",
                  ),
                ),
                SizedBox(height: 10.0),
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter email';
                          }
                          else if (!value.contains("@")) {
                            return 'Please enter correct email format';
                          }
                          return null;
                        },
                        controller: email,
                        obscureText: false,
                        style: style,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Email",
                            border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter password';
                          }
                          else if (value.length < 8){
                            return 'Password must be more than 7 characters';
                          }
                          return null;
                        },
                        controller: pw,
                        obscureText: true,
                        style: style,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Password",
                            border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                        controller: nm,
                        obscureText: false,
                        style: style,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Name",
                            border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter garage name';
                          }
                          return null;
                        },
                        controller: gm,
                        obscureText: false,
                        style: style,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Garage Name",
                            border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  // ignore: deprecated_member_use
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    else if (value.length < 9){
                      return 'Please enter valid phone number';
                    }
                    return null;
                  },
                  controller: pn,
                  obscureText: false,
                  style: style,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Phone Number",
                      border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                ),
                SizedBox(height: 10.0),

                Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.purple,
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width*0.6,
                    padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    onPressed: () async {
                      print(controller.text);
                      if (formkey.currentState.validate()) {
                        //register .. send data  to authservices
                        dynamic result = await _auth.regMech(email.text, pw.text, nm.text, gm.text, pn.text);
                        showDialog(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Successfully Registered'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Continue to login'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () async {
                                    dynamic result = await _auth.signOut();
                                    if (result == null) {
                                      int i = 1;
                                      print(i.toString());
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              MSignIn(),
                                        ),
                                            (route) => false,
                                      );
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        if (result == null) {
                          showDialog(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('This account already been used'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text('Use other email account'),
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
                        }
                      }
                    },
                    child: Text("Submit",textAlign: TextAlign.center, style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),

                SizedBox(height: 10.0),
                Text("Already have an account?"),
                FlatButton(
                  child: Text("Login here!", style: style),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }
}

