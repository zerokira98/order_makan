// import 'package:order_makan/model/menuitems_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';

abstract class _StrukRepo {
  FirebaseFirestore db;

  _StrukRepo(this.db);

  Future sendtoAntrian(UseStrukState state);
  Future<List<UseStrukState>> getAntrian();
  Future<int> getCurrrentAntrianCount();
  Future deleteAntrian(String docId, String reason);
  Future finishAntrian(String strukId) async {}
  // Future sendtoDatabase(StrukState state);
  Future<List> readAllStruk();
  Future<int> getStrukCount();
  Future readStrukwithFilter(StrukFilter filter);
}

class StrukRepository extends _StrukRepo {
  MenuItemRepository menuitemrepo;
  StrukRepository(super.db, this.menuitemrepo) {
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

  ///just use increaseTodaysAntrianCount
  Future<int> getTodaysAntrianCount({DateTime? date}) {
    var antriancountref = db
        .collection('antriancount_perdate')
        .doc((date ?? DateTime.now()).formatBasic());
    return antriancountref.get(GetOptions(source: Source.cache)).then(
      (value) {
        debugPrint('telo');
        return (value.data()?['count'] as int?) ?? 0;
      },
    ).onError(
      (error, stackTrace) {
        debugPrint('telo error');
        throw error!;
      },
    );
    // var thedate = date == null ? DateTime.now() : date.simpler();
    // var sp = await SharedPreferences.getInstance();
    // return sp.getInt(thedate.formatBasic()) ?? 0;
  }

  Future<int> increaseTodaysAntrianCount({DateTime? date}) async {
    // var thedate = date == null ? DateTime.now() : date.simpler();
    var antriancountref = db
        .collection('antriancount_perdate')
        .doc((date ?? DateTime.now()).formatBasic());
    antriancountref
        .set({'count': FieldValue.increment(1)}, SetOptions(merge: true)).then(
      (value) => true,
    );
    return antriancountref.get().then(
          (value) => value.data()!['count'] as int,
        );
  }

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
  Future<int> getCurrrentAntrianCount() {
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
                      previousValue +
                      (element.count * element.price) +
                      element.submenues.fold(
                        0,
                        (prevValue, ele) =>
                            prevValue + (ele.adjustHarga * element.count),
                      ),
                )
          });
          for (var e in b.data()!.orderItems) {
            for (var f in e.ingredientItems) {
              var getid = await menuitemrepo.getIngredients(title: f.title);
              transaction.update(menuitemrepo.ingredientRef.doc(getid.first.id),
                  {'count': FieldValue.increment(-(f.count * e.count))});
            }
            for (var g in e.submenues) {
              for (var h in g.adjustIngredient) {
                var getid = await menuitemrepo.getIngredients(title: h.title);
                transaction.update(
                    menuitemrepo.ingredientRef.doc(getid.first.id),
                    {'count': FieldValue.increment(-(h.count * e.count))});
              }
            }
          }
          transaction.delete(a);
        } catch (e) {
          debugPrint(e.toString());
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
