import 'dart:async';

import 'package:sembast/sembast.dart';

class KaryawanAuthRepo {
  final Cache _cache;
  KaryawanAuthRepo(Database db)
      : _cache = Cache(),
        _db = db;

  final _controller = StreamController<User>();
  Stream<User> get user {
    // _controller.stream.listen((event) {
    // });
    return _controller.stream;
  }

  User get currentUser => _cache.user ?? User.empty;
  final Database _db;
  Future<List<RecordSnapshot>> karyawanList() {
    var store = intMapStoreFactory.store('karyawanAuth');
    return store.query().getSnapshots(_db);
  }

  Future<void> signUp(
      {required String username, required String password}) async {
    try {
      /// fileservice.loginkaryawan(username,password);
      ///
      var store = intMapStoreFactory.store('karyawanAuth');
      User data = User(username: username, password: password);
      var exist = await store.findFirst(_db,
          finder: Finder(filter: Filter.equals('username', username)));
      if (exist != null) {
        throw Exception('username already exist');
      } else {
        await store.add(_db, data.toJson());
        _controller.add(User(username: username));
      }

      /// return : User
      /// _cache.write(user:user);
    } on Exception catch (e) {
      throw Exception(e);
    } catch (_) {
      throw Exception(_);
    }
  }

  Future<void> signOut() async {
    try {
      _controller.add(const User(username: ''));

      /// return : User
      /// _cache.write(user:user);
    } on Exception catch (e) {
      throw Exception(e);
    } catch (_) {
      throw Exception(_);
    }
  }

  Future<void> signIn(
      {required String username, required String password}) async {
    try {
      /// fileservice.loginkaryawan(username,password);
      ///
      var store = intMapStoreFactory.store('karyawanAuth');
      var a = await store.findFirst(_db,
          finder: Finder(
              filter: Filter.and([
            Filter.equals('username', username),
            Filter.equals('password', password),
          ])));
      if (a == null) {
        var b = await store.findFirst(_db,
            finder: Finder(filter: Filter.equals('username', username)));
        if (b != null) {
          throw 'pass not correct';
        } else {
          throw 'username not found, not correct';
        }
      } else {
        _controller.add(User(username: username));
      }

      /// return : User
      /// _cache.write(user:user);
    } on Exception catch (e) {
      throw Exception(e);
    } catch (_) {
      throw Exception(_);
    }
  }
}

class User {
  final String username;
  final String password;

  final String namaKaryawan;
  final String foto;
  const User(
      {String? username, String? namaKaryawan, String? foto, String? password})
      : username = username ?? '',
        password = password ?? '',
        namaKaryawan = namaKaryawan ?? '',
        foto = foto ?? '';
  static const empty = User();
  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'namaKaryawan': namaKaryawan,
        'foto': foto,
      };
  bool get isEmpty => this == User.empty;
}

class Cache {
  User? user;
}
