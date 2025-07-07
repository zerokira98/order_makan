import 'package:cloud_firestore/cloud_firestore.dart';

class KasRepository {
  final FirebaseFirestore fire;
  CollectionReference pemasukan;
  CollectionReference pengeluaran;
  KasRepository({required this.fire})
      : pemasukan = fire.collection('pemasukan'),
        pengeluaran = fire.collection('pengeluaran');

  Future<DocumentSnapshot> getUangLaciHarian(int uang) {
    var now = DateTime.now();
    return fire
        .collection('laci_harian')
        .doc(Timestamp.fromDate(DateTime(now.year, now.month, now.day))
            .toString())
        .get();
  }

  Future setUangLaciHarian(int uang) {
    var now = DateTime.now();
    var timestamp = Timestamp.fromDate(DateTime(now.year, now.month, now.day));
    return fire
        .collection('laci_harian')
        .doc(timestamp.toString())
        .set({"uang": uang, "modified_date": Timestamp.fromDate(now)});
  }

  Future<DocumentSnapshot> tambahPemasukan(
      String title, int cost, DateTime date) {
    throw UnimplementedError();
  }

  Future<DocumentSnapshot> tambahPengeluaran(
      String title, int cost, DateTime date) {
    throw UnimplementedError();
  }

  Future<DocumentSnapshot> getPengeluaran(
      {required DateTime before, required DateTime after}) {
    throw UnimplementedError();
  }
}
