import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference UserCollection =
      Firestore.instance.collection('USER');
  final CollectionReference ClientCollection =
      Firestore.instance.collection('CLIENTDATA');
  final CollectionReference MechCollection =
      Firestore.instance.collection('MECHDATA');


  Future updateUserAcc(String em) async {
    return await UserCollection.document(uid)
        .setData({'email': em, 'role': "user"});
  }

  Future updateClientData(String nm, String bm, String pn) async {
    return await ClientCollection.document(uid).setData(
        {'Name': nm, 'Bike Name': bm, 'Phone Number': pn, 'role': "user"});
  }

  Future updateMechAcc(String em) async {
    return await UserCollection.document(uid)
        .setData({'email': em, 'role': "mech"});
  }

  Future updateMechData(String nm, String gm, String pn) async {
    double lat = 3.1466;
    double long = 101.6958;
    return await MechCollection.document(uid).setData(
        {'Name': nm, 'Garage Name': gm, 'Phone Number': pn, 'role': "mech", 'latitude': 3.1446, 'longtitude': 101.6958 });
  }

  Future updateMap(double lat, double long) async {
    return await MechCollection.document(uid)
        .setData({'latitude': lat, 'longtitude': long}, merge: true);
  }

  Future reqMech(String mid) async {
    return await ClientCollection.document(uid)
        .setData({'request': mid, 'status': "WAITING"}, merge: true);
  }

  Future addToMech(String mid, String name, String bname, String pnum) async {
    return await MechCollection.document(uid).collection("request").document(mid).setData({'status': "waiting", 'Name': name, 'Bike Name': bname, 'Phone Number': pnum});
  }
}
