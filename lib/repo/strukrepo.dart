// import 'package:order_makan/model/menuitems_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';

abstract class StrukRepo {
  FirebaseFirestore db;

  StrukRepo(this.db);

  Future sendtoAntrian(UseStrukState state);
  Future<List<UseStrukState>> getAntrian();
  Future<int> getAntrianCount();
  Future deleteAntrian(String docId, String reason);
  Future finishAntrian(String strukId) async {}
  // Future sendtoDatabase(StrukState state);
  Future<List> readAllStruk();
  Future<int> getStrukCount();
  Future readStrukwithFilter(StrukFilter filter);
}

class StrukRepository extends StrukRepo {
  StrukRepository(super.db) {
    antrianRefVanilla = db.collection('antrian');
    antrianRef = antrianRefVanilla.withConverter<UseStrukState>(
      fromFirestore: (snapshot, options) =>
          UseStrukState.fromFirestore(snapshot),
      toFirestore: (value, options) => value.toFirestore(),
    );
    strukRefVanilla = db.collection('struk');
    strukRef = strukRefVanilla.withConverter<UseStrukState>(
      fromFirestore: (snapshot, options) =>
          UseStrukState.fromFirestore(snapshot),
      toFirestore: (value, options) => value.toFirestore(),
    );
  }

  late CollectionReference<UseStrukState> antrianRef;
  late CollectionReference<UseStrukState> strukRef;
  late CollectionReference antrianRefVanilla;
  late CollectionReference strukRefVanilla;

  Stream<int> getStrukStreamCount() {
    return strukRef.where('title', isNull: false).snapshots().map<int>(
          (value) => value.docChanges.length,
        );
  }

  @override
  Future<int> getStrukCount() {
    return strukRef.count().get().then(
          (value) => value.count ?? 0,
        );
  }

  @override
  Future<int> getAntrianCount() {
    return antrianRef.count().get().then(
          (value) => value.count ?? 0,
        );
  }

  @override
  Future<List<UseStrukState>> readAllStruk({bool descending = false}) {
    return (strukRef).orderBy('ordertime', descending: descending).get().then(
          (value) => value.docs
              .map(
                (e) => e.data(),
              )
              .toList(),
        );
  }

  Future<List<QueryDocumentSnapshot>> readAllStrukVanilla(
      {bool descending = false}) {
    return (strukRefVanilla)
        .orderBy('ordertime', descending: descending)
        .get()
        .then(
          (value) => value.docs.toList(),
        );
  }

  @override
  Future finishAntrian(String strukId) async {
    var now = DateTime.now();
    var a = antrianRef.doc(strukId);
    return db.runTransaction(
      (transaction) async {
        try {
          var b = await transaction.get(a);
          transaction.set(strukRef.doc(strukId), b.data()!);
          transaction.update(strukRef.doc(strukId), {
            "waktu_tunggu": now.difference(b.data()!.ordertime).inSeconds,
            "total_harga": b.data()!.orderItems.fold(
                  0,
                  (previousValue, element) =>
                      previousValue + (element.count * element.price),
                )
          });
          transaction.delete(a);
        } catch (e) {
          print(e);
          throw Exception(e);
        }
      },
    );
  }

  @override
  Future<List<UseStrukState>> readStrukwithFilter(StrukFilter filter) {
    var newfilter = Filter.and(
      Filter('ordertime',
          isGreaterThanOrEqualTo:
              filter.start != null ? Timestamp.fromDate(filter.start!) : null),
      Filter('ordertime',
          isLessThan:
              filter.end != null ? Timestamp.fromDate(filter.end!) : null),
      filter.pegawaiId != null
          ? Filter('pegawaiId', isGreaterThanOrEqualTo: filter.pegawaiId)
          : null,
      // filter.strukId != null
      //     ? Filter('strukId', isGreaterThanOrEqualTo: filter.strukId)
      //     : null
      // Filter('pegawaiId', isGreaterThanOrEqualTo: filter.pegawaiId),
      // Filter('strukId', isGreaterThanOrEqualTo: filter.strukId),
    );
    return strukRef.where(newfilter).orderBy('ordertime').get().then(
          (value) => value.docs
              .map(
                (e) => e.data(),
              )
              .toList(),
        );
  }

  Future<List<QueryDocumentSnapshot>> readStrukwithFilterVanilla(
      StrukFilter filter) {
    var newfilter = Filter.and(
      Filter('ordertime',
          isGreaterThanOrEqualTo:
              filter.start != null ? Timestamp.fromDate(filter.start!) : null),
      Filter('ordertime',
          isLessThan:
              filter.end != null ? Timestamp.fromDate(filter.end!) : null),
      filter.pegawaiId != null
          ? Filter('pegawaiId', isGreaterThanOrEqualTo: filter.pegawaiId)
          : null,
      // filter.strukId != null
      //     ? Filter('strukId', isGreaterThanOrEqualTo: filter.strukId)
      //     : null
      // Filter('pegawaiId', isGreaterThanOrEqualTo: filter.pegawaiId),
      // Filter('strukId', isGreaterThanOrEqualTo: filter.strukId),
    );
    return strukRef.where(newfilter).orderBy('ordertime').get().then(
          (value) => value.docs.toList(),
        );
  }

  @override
  Future deleteAntrian(String docId, String reason) {
    var deletedRef = db.collection('deleted_struk').doc(docId);
    return db.runTransaction(
      (transaction) async {
        var data = await transaction.get(antrianRef.doc(docId));
        transaction.set(deletedRef, data.data()!.toFirestore());
        transaction.set(
            deletedRef, {"reason": reason}, SetOptions(merge: true));
        transaction.delete(antrianRef.doc(docId));
      },
    );
  }

  @override
  Future<List<UseStrukState>> getAntrian() {
    return antrianRef.orderBy('ordertime').get().then(
          (value) => value.docs
              .map(
                (e) => e.data(),
              )
              .toList(),
        );
  }

  @override
  Future<DocumentReference> sendtoAntrian(UseStrukState state) {
    return antrianRef.add(state);
  }
}

// enum Filter {}
class StrukFilter {
  String? pegawaiId;
  DateTime? start;
  DateTime? end;
  String? strukId;
  StrukFilter({this.pegawaiId, this.start, this.end, this.strukId});
  static StrukFilter thisMonth() {
    var now = DateTime.now();
    return StrukFilter(
        pegawaiId: '',
        start: DateTime(now.year, now.month, 0),
        end: DateTime(now.year, now.month + 1, 0),
        strukId: '');
  }

  StrukFilter copywith({
    String? pegawaiId,
    DateTime? start,
    DateTime? end,
    String? strukId,
  }) =>
      StrukFilter(
          pegawaiId: pegawaiId ?? this.pegawaiId,
          start: start ?? this.start,
          end: end ?? this.end,
          strukId: strukId ?? this.strukId);
}
