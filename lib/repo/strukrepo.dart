// import 'package:order_makan/model/menuitems_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_makan/bloc/struk/struk_state.dart';

abstract class StrukRepo {
  FirebaseFirestore db;

  StrukRepo(this.db);

  Future sendtoAntrian(StrukState state);
  Future getAntrian();
  Future<int> getAntrianCount();
  Future deleteAntrian(String docId, String reason);
  Future finishAntrian(String strukId) async {}
  // Future sendtoDatabase(StrukState state);
  Future<List> readAllStruk();
  Future<int> getStrukCount();
  Future readStrukwithFilter(StrukFilter filter);
}

class StrukRepository extends StrukRepo {
  StrukRepository(super.db)
      : antrianRef = db.collection('antrian').withConverter(
              fromFirestore: (snapshot, options) =>
                  StrukState.fromFirestore(snapshot),
              toFirestore: (value, options) => value.toFirestore(),
            ),
        strukRef = db.collection('struk').withConverter(
              fromFirestore: (snapshot, options) =>
                  StrukState.fromFirestore(snapshot),
              toFirestore: (value, options) => value.toFirestore(),
            );
  CollectionReference<StrukState> antrianRef;
  CollectionReference<StrukState> strukRef;
  @override
  Stream<int> getStrukStreamCount() {
    return strukRef.where('title', isNull: false).snapshots().map(
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
  Future<List<StrukState>> readAllStruk({bool? descending, bool? finished}) {
    return strukRef.get().then(
          (value) => value.docs
              .map(
                (e) => e.data(),
              )
              .toList(),
        );
  }

  @override
  Future finishAntrian(String strukId) async {
    var a = antrianRef.doc(strukId);
    return db.runTransaction(
      (transaction) async {
        var b = await transaction.get(a);
        transaction.set(strukRef.doc(strukId), b.data());
        transaction.delete(a);
      },
    );
  }

  @override
  Future<List<StrukState>> readStrukwithFilter(StrukFilter filter) {
    var newfilter = Filter.and(
      Filter('start', isGreaterThanOrEqualTo: filter.start),
      Filter('end', isLessThanOrEqualTo: filter.end),
      Filter('pegawaiId', isGreaterThanOrEqualTo: filter.pegawaiId),
      Filter('strukId', isGreaterThanOrEqualTo: filter.strukId),
    );
    return strukRef.where(newfilter).get().then(
          (value) => value.docs
              .map(
                (e) => e.data(),
              )
              .toList(),
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
  Future<List<StrukState>> getAntrian() {
    return antrianRef.get().then(
          (value) => value.docs
              .map(
                (e) => e.data(),
              )
              .toList(),
        );
  }

  @override
  Future<DocumentReference> sendtoAntrian(StrukState state) {
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
