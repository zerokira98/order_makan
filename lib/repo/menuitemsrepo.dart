import 'package:order_makan/model/menuitems_model.dart';
import 'package:sembast/sembast.dart';

abstract class MenuItemRepo {
  Database db;
  MenuItemRepo(this.db);
  Future<List<MenuItems>> getAllMenus();
  Future<List<MenuItems>> getMenusByCategory(String category);
  Future<List> getCategories();
  Future addCategory(String category);
  Future deleteCategory(String category);
  Future addCategorytoMenu(MenuItems menu);
  Future addMenu(MenuItems menu);
  Future deleteMenu(MenuItems menu);
  Future editMenu(String title, MenuItems menu);
}

class MenuItemRepository implements MenuItemRepo {
  @override
  Database db;

  MenuItemRepository(this.db);
  @override
  Future editMenu(String title, MenuItems menu) {
    var store = intMapStoreFactory.store('menus');
    return store.update(db, menu.toJson(),
        finder: Finder(filter: Filter.equals('title', title)));
  }

  @override
  Future<List<MenuItems>> getAllMenus() {
    var store = intMapStoreFactory.store('menus');
    return store
        .query(finder: Finder(sortOrders: [SortOrder('title')]))
        .getSnapshots(db)
        .then((value) {
      if (value.isNotEmpty) {
        return value.map((e) => MenuItems.fromJson(e.value)).toList();
      } else {
        return [];
      }
    });
  }

  @override
  Future<List<MenuItems>> getMenusByCategory(String category) {
    var store = intMapStoreFactory.store('menus');
    return store
        .query(
            finder: Finder(
                filter: Filter.equals('categories', category, anyInList: true)))
        .getSnapshots(db)
        .then((value) {
      if (value.isNotEmpty) {
        return value.map((e) => MenuItems.fromJson(e.value)).toList();
      } else {
        return [];
      }
    });
  }

  @override
  Future addMenu(MenuItems menu) {
    var store = intMapStoreFactory.store('menus');
    return store
        .findFirst(db,
            finder: Finder(filter: Filter.equals('title', menu.title)))
        .then((value) {
      if (value == null) {
        return store.add(db, menu.toJson());
      } else {
        return -1;
      }
    });
  }

  @override
  Future<List<String>> getCategories() {
    var store = intMapStoreFactory.store('categories');
    return store.query().getSnapshots(db).then((value) {
      if (value.isNotEmpty) {
        return value.map((e) => e.value['name'] as String).toList();
      } else {
        return [];
      }
    });
  }

  @override
  Future addCategory(String category) {
    var store = intMapStoreFactory.store('categories');
    return store
        .find(db, finder: Finder(filter: Filter.equals('name', category)))
        .then((value) {
      if (value.isEmpty) {
        return store.add(db, {'name': category});
      } else {
        return -1;
      }
    });
  }

  @override
  Future deleteMenu(MenuItems menu) {
    var store = intMapStoreFactory.store('menus');
    return store.delete(db,
        finder: Finder(filter: Filter.equals('title', menu.title)));
  }

  @override
  Future addCategorytoMenu(MenuItems menu) {
    // TODO: implement addCategorytoMenu
    throw UnimplementedError();
  }

  @override
  Future deleteCategory(String category) {
    var store = intMapStoreFactory.store('categories');
    return store.delete(db,
        finder: Finder(filter: Filter.equals('name', category)));
  }
}
