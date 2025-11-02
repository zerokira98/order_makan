// import 'package:firebase_storage/firebase_storage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class GlobalSettingRepo {
  final FirebaseFirestore firestore;
  GlobalSettingRepo(this.firestore);
  Future<String> getWifiPass() {
    return firestore.collection('globalsettings').doc('wifi').get().then(
          (value) => (value.data()?['password'] as String?) ?? '',
        );
  }

  Future setWifiPass(String password) {
    return firestore
        .collection('globalsettings')
        .doc('wifi')
        .set({'password': password});
  }
}
