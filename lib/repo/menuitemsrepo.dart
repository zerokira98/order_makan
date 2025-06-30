import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_makan/model/kategori_model.dart';
import 'package:order_makan/model/menuitems_model.dart';

abstract class _MenuItemRepo {
  final FirebaseFirestore firestore;
  _MenuItemRepo(this.firestore);
  Future<List<MenuItems>> getAllMenus();
  Future<List<MenuItems>> getMenusByCategory(String category);
  Future<List> getCategories();
  Future addCategory(String category);
  Future deleteCategory(String category);
  Future addCategorytoMenu(MenuItems menu);
  Future addMenu(MenuItems menu) async {}
  Future deleteMenu(MenuItems menu);
  Future editMenu(MenuItems menu);
}

class MenuItemRepository implements _MenuItemRepo {
  @override
  final FirebaseFirestore firestore;
  CollectionReference<MenuItems> menuRef;
  CollectionReference menuRefVanilla;
  CollectionReference<Map> categoryRef;
  MenuItemRepository(this.firestore)
      : menuRef = firestore.collection('menu_items').withConverter(
            fromFirestore: (snap, _) => MenuItems.fromFirestore(snap),
            toFirestore: (model, _) => model.toFirestore()),
        categoryRef = firestore.collection('categories'),
        menuRefVanilla = firestore.collection('menu_items');
  @override
  Future editMenu(MenuItems menu) {
    return menuRef.doc(menu.id).update(menu.toFirestore());
    // var store = intMapStoreFactory.store('menus');
    // return store.update(db, menu.toJson(),
    //     finder: Finder(filter: Filter.equals('title', title)));
  }

  @override
  Future<List<MenuItems>> getAllMenus({bool customOrder = false}) {
    return menuRef
        .orderBy('title')
        .where('custom_order', isNull: !customOrder)
        .get()
        .then((value) => value.docs
            .map(
              (e) => e.data(),
            )
            .toList());
    // var store = intMapStoreFactory.store('menus');
    // return store
    //     .query(finder: Finder(sortOrders: [SortOrder('title')]))
    //     .getSnapshots(db)
    //     .then((value) {
    //   if (value.isNotEmpty) {
    //     return value.map((e) => MenuItems.fromJson(e.value)).toList();
    //   } else {
    //     return [];
    //   }
    // });
  }

  @override
  Future<List<MenuItems>> getMenusByCategory(String category) {
    return menuRef
        .where('categories', arrayContains: category)
        .get()
        .then((value) => value.docs
            .map(
              (e) => e.data(),
            )
            .toList());
    // var store = intMapStoreFactory.store('menus');
    // return store
    //     .query(
    //         finder: Finder(
    //             filter: Filter.equals('categories', category, anyInList: true)))
    //     .getSnapshots(db)
    //     .then((value) {
    //   if (value.isNotEmpty) {
    //     return value.map((e) => MenuItems.fromJson(e.value)).toList();
    //   } else {
    //     return [];
    //   }
    // });
  }

  @override
  Future addMenu(MenuItems menu, {bool customOrder = false}) async {
    // give error when they have ssame title
    var check = await menuRef.where('title', isEqualTo: menu.title).get();
    if (check.size > 0) return throw Exception('title exist');

    return menuRef.add(menu).then(
      (value) {
        value.update({'custom_order': customOrder});
      },
    );

    // var store = intMapStoreFactory.store('menus');
    // return store
    //     .findFirst(db,
    //         finder: Finder(filter: Filter.equals('title', menu.title)))
    //     .then((value) {
    //   if (value == null) {
    //     return store.add(db, menu.toJson());
    //   } else {
    //     return -1;
    //   }
    // });
  }

  @override
  Future<List<String>> getCategories() {
    return categoryRef.get().then((value) => value.docs
        .map(
          (e) => (e.data()['nama'] as String?) ?? '',
        )
        .toList());
    // var store = intMapStoreFactory.store('categories');
    // return store.query().getSnapshots(db).then((value) {
    //   if (value.isNotEmpty) {
    //     return value.map((e) => e.value['name'] as String).toList();
    //   } else {
    //     return [];
    //   }
    // });
  }

  @override
  Future addCategory(String category) {
    Map<String, dynamic> data = {"nama": category};
    return categoryRef.add(data);
    //   var store = intMapStoreFactory.store('categories');
    //   return store
    //       .find(db, finder: Finder(filter: Filter.equals('name', category)))
    //       .then((value) {
    //     if (value.isEmpty) {
    //       return store.add(db, {'name': category});
    //     } else {
    //       return -1;
    //     }
    //   });
  }

  @override
  Future deleteMenu(MenuItems menu) {
    return menuRef.doc(menu.id).delete();
    // var store = intMapStoreFactory.store('menus');
    // return store.delete(db,
    //     finder: Finder(filter: Filter.equals('title', menu.title)));
  }

  @override
  Future addCategorytoMenu(MenuItems menu) {
    // TODO: implement addCategorytoMenu
    throw UnimplementedError();
  }

  @override
  Future deleteCategory(String category) {
    return categoryRef.where('nama', isEqualTo: category).get().then(
      (value) {
        if (value.docs.isEmpty) throw Exception();
        return categoryRef.doc(value.docs[0].id).delete();
      },
    );
    // var store = intMapStoreFactory.store('categories');
    // return store.delete(db,
    //     finder: Finder(filter: Filter.equals('name', category)));
  }

  Future deleteCategoryFromMenu(String category) {
    throw UnimplementedError();
    // var store = intMapStoreFactory.store('categories');
    // return store.delete(db,
    //     finder: Finder(filter: Filter.equals('name', category)));
  }
}
