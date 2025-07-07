import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_makan/model/ingredient_model.dart';
import 'package:order_makan/model/inputstock_model.dart';
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
  CollectionReference<IngredientItem> ingredientRef;
  CollectionReference<InputstockModel> inputstocksRef;
  CollectionReference<MenuItems> menuRef;
  CollectionReference menuRefVanilla;
  CollectionReference<Map> categoryRef;
  MenuItemRepository(this.firestore)
      : inputstocksRef = firestore.collection('input_stocks').withConverter(
              fromFirestore: (snapshot, options) =>
                  InputstockModel.fromMap(snapshot.data()!),
              toFirestore: (value, options) => value.toMap(),
            ),
        menuRef = firestore.collection('menu_items').withConverter(
            fromFirestore: (snap, _) => MenuItems.fromFirestore(snap),
            toFirestore: (model, _) => model.toFirestore()),
        categoryRef = firestore.collection('categories'),
        //change importatn
        ingredientRef = firestore.collection('ingredients').withConverter(
              fromFirestore: (snapshot, options) =>
                  IngredientItem.fromFirestore(snapshot),
              toFirestore: (value, options) => value.toMap(),
            ),
        menuRefVanilla = firestore.collection('menu_items');
  @override
  Future editMenu(MenuItems menu) async {
    var newingredientItems = menu.ingredientItems;
    for (var ele in menu.ingredientItems) {
      await ingredientRef.where('title', isEqualTo: ele.title).get().then(
        (value) async {
          if (value.docs.isEmpty) {
            await ingredientRef.add(ele).then(
              (value2) {
                newingredientItems = newingredientItems
                    .map(
                      (e) => e.title == ele.title
                          ? e.copyWith(id: () => value2.id)
                          : e,
                    )
                    .toList();
              },
            );
          } else {
            if (ele.id == null) {
              newingredientItems = newingredientItems
                  .map(
                    (e) => e.title == ele.title
                        ? e.copyWith(id: () => value.docs.first.id)
                        : e,
                  )
                  .toList();
            }
          }
        },
      );
    }
    return menuRef.doc(menu.id).update(
        menu.copywith(ingredientItems: newingredientItems).toFirestore());
  }

  @override
  Future<List<MenuItems>> getAllMenus({bool customOrder = false}) {
    return menuRef
        .orderBy('title')
        // .where('custom_order', isGreaterThanOrEqualTo: customOrder)
        .get()
        .then((value) => value.docs
            .map(
              (e) => (e.data().customOrder ?? false) == customOrder
                  ? e.data()
                  : null,
            )
            .nonNulls
            .toList());
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
  }

  Future<QuerySnapshot<IngredientItem>> getIngredients() {
    return ingredientRef.get();
  }

  Future<QuerySnapshot<IngredientItem>> getStocks() {
    return ingredientRef.get();
  }

  Future<DocumentReference<InputstockModel>> addInputstocks(
      InputstockModel data) {
    return inputstocksRef.add(data);
  }

  Future<QuerySnapshot<InputstockModel>> getInputstocks() {
    return inputstocksRef.get();
  }

  @override
  Future<DocumentReference<MenuItems>> addMenu(MenuItems menu,
      {bool customOrder = false}) async {
    // give error when they have ssame title
    var check = await menuRef.where('title', isEqualTo: menu.title).get();
    if (check.size > 0 && !customOrder) {
      return throw Exception('title exist');
    } else if (customOrder) {
      //always single

      return menuRef.doc(check.docs.first.id)
        ..update({
          "modified": FieldValue.arrayUnion([
            {
              "date": Timestamp.fromDate(DateTime.now()),
              "price_before": check.docs.first.data().price
            }
          ])
        });
    }
    for (var e in menu.ingredientItems) {
      await ingredientRef
          .where('title', isEqualTo: menu.ingredientItems)
          .get()
          .then(
        (value) async {
          if (value.docs.isEmpty) {
            await ingredientRef.add(e.copyWith(count: 0));
          }
        },
      );
    }
    // firestore.runTransaction(
    //   (transaction) {
    //     transaction.get(ingredientRef.where('title',isEqualTo: menu.ingredientItems).)
    //     return;
    //   },
    // );
    return menuRef.add(menu).then(
      (value) {
        value.update({'custom_order': customOrder});
        return value;
      },
    );
  }

  @override
  Future<List<String>> getCategories() {
    return categoryRef.get().then((value) => value.docs
        .map(
          (e) => (e.data()['nama'] as String?) ?? '',
        )
        .toList());
  }

  @override
  Future addCategory(String category) {
    Map<String, dynamic> data = {"nama": category};
    return categoryRef.add(data);
  }

  @override
  Future deleteMenu(MenuItems menu) {
    return menuRef.doc(menu.id).delete();
  }

  @override
  Future addCategorytoMenu(MenuItems menu) {
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
