// import 'package:order_makan/model/menuitems_model.dart';
import 'package:order_makan/model/strukitem_model.dart';
import 'package:sembast/sembast.dart';

abstract class StrukRepo {
  Database db;

  StrukRepo(this.db);

  Future sendtoDatabase(List<StrukItem> items);
  Future readAllStruk();
  Future readStrukwithFilter(StrukFilter filter);
}

class StrukRepository extends StrukRepo {
  StrukRepository(super.db);

  @override
  Future readAllStruk() {
    var store = intMapStoreFactory.store('struk');
    return store.query().getSnapshots(db);
  }

  @override
  Future sendtoDatabase(List<StrukItem> items) {
    var store = intMapStoreFactory.store('struk');
    return db.transaction((trx) async {
      for (var e in items) {
        await store.add(trx, e.toJson());
      }
    });
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
