import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceRepo {
  CollectionReference ref;
  DeviceRepo({required this.firestore}) : ref = firestore.collection('devices');
  FirebaseFirestore firestore;
  void updateToken(String deviceId, String token, bool isadmin) {
    var datenow = Timestamp.fromDate(DateTime.now());
    ref
        .doc(deviceId)
        .set({'token': token, "timestamp": datenow, "admin": isadmin});
  }
}
