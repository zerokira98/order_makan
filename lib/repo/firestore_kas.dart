import 'package:cloud_firestore/cloud_firestore.dart';

class KasRepository {
  final FirebaseFirestore fire;
  CollectionReference<Map> pemasukan;
  CollectionReference<Map> pengeluaran;
  KasRepository({required this.fire})
      : pemasukan = fire.collection('pemasukan'),
        pengeluaran = fire.collection('pengeluaran');

  Future<DocumentSnapshot<Map>> getUangLaciHarian() {
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

  Future<DocumentReference> tambahPengeluaran(
      String title, int cost, DateTime date, String userid) {
    Map<String, dynamic> data = {
      "title": title,
      "userid": userid,
      "cost": cost,
      "date": Timestamp.fromDate(date),
      "posting_time": Timestamp.fromDate(DateTime.now())
    };
    return pengeluaran.add(data);
  }

  Future<QuerySnapshot<Map>> getPengeluaranAll() {
    return pengeluaran.get();
  }

  Future<QuerySnapshot<Object?>> getPengeluaran(
      {required DateTime start, required DateTime end}) {
    return pengeluaran
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .get();
  }
}
