// import 'package:order_makan/model/menuitems_model.dart';
import 'package:order_makan/bloc/struk/struk_state.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/utils/value_utils.dart';

abstract class StrukRepo {
  Database db;

  StrukRepo(this.db);

  Future sendtoDatabase(StrukState state);
  Future<List> readAllStruk();
  Future<int> getCount();
  Future antrianFinish(int key) async {}
  Future readStrukwithFilter(StrukFilter filter);
}

class StrukRepository extends StrukRepo {
  StrukRepository(super.db);
  @override
  Future<int> getCount() {
    var store = intMapStoreFactory.store('struk');
    return store.count(db);
  }

  @override
  Future<List<RecordSnapshot>> readAllStruk(
      {bool? descending, bool? finished}) {
    var store = intMapStoreFactory.store('struk');
    Filter? filter1;
    SortOrder sortOrder = SortOrder(Field.key, true);
    if (finished != null) {
      filter1 = Filter.equals('isFinished', finished);
    }
    if (descending != null) {
      sortOrder = SortOrder(Field.key, descending);
    }
    return store
        .query(finder: Finder(filter: filter1, sortOrders: [sortOrder]))
        .getSnapshots(db);
  }

  @override
  Future sendtoDatabase(StrukState state) {
    var store = intMapStoreFactory.store('struk');
    var jsonState = state.toJson();
    var now = DateTime.now();
    jsonState.addAll({'timestamp': now.toString()});
    // return Future(() => null);
    return db.transaction((trx) async {
      await store.add(trx, jsonState);
    });
  }

  @override
  Future antrianFinish(int key) async {
    var store = intMapStoreFactory.store('struk');
    store.findFirst(db);
    var a = await store.record(key).get(db);
    var map = cloneMap(a!);
    // var b = a!.cast();
    map['isFinished'] = true;
    return store.record(key).update(db, map);
    // return db.transaction((trx) async {

    // await store.add(trx, jsonState);
    // });
  }

  @override
  Future readStrukwithFilter(StrukFilter filter) {
    // TODO: implement readStrukwithFilter
    var store = intMapStoreFactory.store('struk');

    var newfilter = Filter.and([
      Filter.greaterThanOrEquals('start', filter.start),
      Filter.lessThanOrEquals('end', filter.end),
      Filter.greaterThanOrEquals('pegawaiId', filter.pegawaiId),
      Filter.greaterThanOrEquals('strukId', filter.strukId),
    ]);
    return store.query(finder: Finder(filter: newfilter)).getSnapshots(db);
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
