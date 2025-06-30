import 'package:cloud_firestore/cloud_firestore.dart';

class KasRepository {
  final FirebaseFirestore fire;

  KasRepository({required this.fire});

  Future uangLaciHarian(int uang) {
    var now = DateTime.now();
    return fire
        .collection('collectionPath')
        .doc(Timestamp.fromDate(DateTime(now.year, now.month, now.day))
            .toString())
        .get();
  }
}
