import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app2020/models/user.dart';
class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference UserCollection = Firestore.instance.collection('USER');
  final CollectionReference ClientCollection = Firestore.instance.collection('CLIENTDATA');
  final CollectionReference MechCollection = Firestore.instance.collection('MECHDATA');

  Future updateUserAcc(String em) async {
    return await UserCollection.document(uid).setData(
        {
          'email': em,
          'role' : "user"
        });
  }
  Future updateClientData(String nm, String bm, String pn) async {
    return await ClientCollection.document(uid).setData(
        {
          'Name': nm,
          'Bike Name': bm,
          'Phone Number': pn,
          'role': "user"
        });
  }

  Future updateMechAcc(String em) async {
    return await UserCollection.document(uid).setData(
        {
          'email' : em,
          'role': "mech"
        });
  }

  Future updateMechData(String nm, String gm, String pn) async {
    return await MechCollection.document(uid).setData(
        {
          'Name': nm,
          'Garage Name': gm,
          'Phone Number': pn,
          'role': "mech"
        });
  }

  Future updateMap(double lat, double long) async {
    return await MechCollection.document(uid).setData(
        {
          'latitude': lat,
          'longtitude': long
        }, merge: true);
  }

}