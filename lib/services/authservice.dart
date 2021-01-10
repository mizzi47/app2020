
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app2020/models/user.dart';
import 'package:app2020/services/database.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email = "";
  String userid = "";
  String role = "";

  //declare db user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //stream user
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }

  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future regUser(String email, String password, String nm, String bm,
      String pn) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await DatabaseService(uid: user.uid).updateUserAcc(email);
      await DatabaseService(uid: user.uid).updateClientData(nm, bm, pn);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future regMech(String email, String password, String nm, String gm,
      String pn) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await DatabaseService(uid: user.uid).updateMechAcc(email);
      await DatabaseService(uid: user.uid).updateMechData(nm, gm, pn);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInUser(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  //Future getData() async {
    //userid = (await FirebaseAuth.instance.currentUser()).uid;
    // email = (await FirebaseAuth.instance.currentUser()).email;
    // await DatabaseService(uid: userid).complain(em, date, userid);
    // var document = await Firestore.instance.collection('USER')
    //     .document(userid)
    //     .get();
    // role = document.data['role'].toString();
    // return email;
   // print(userid);
  //}
}




