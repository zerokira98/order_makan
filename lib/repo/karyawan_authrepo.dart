import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'user_model.dart';
// import 'package:sembast/sembast.dart';

class KaryawanAuthRepo {
  final Cache _cache;
  auth.FirebaseAuth instance;
  FirebaseFirestore firestore;
  KaryawanAuthRepo(this.instance, this.firestore) : _cache = Cache();

  // final _controller = StreamController<User>();
  Stream<User> get user {
    return instance.authStateChanges().map(
      (firebaseUser) {
        final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
        _cache.user = user;
        return user;
      },
    );
  }

  Future<void> signUp(
      {required String email, required String password, String? role}) async {
    try {
      await instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (value) {
          return firestore.collection('users').doc(value.user?.uid).set({
            "name": value.user?.displayName ?? "",
            "role": role ?? "karyawan"
          });
        },
      );
    } on auth.FirebaseAuthException catch (e) {
      // throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      // throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<void> logInWithUserAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on auth.FirebaseAuthException catch (e) {
      // throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      // throw const LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on auth.FirebaseAuthException catch (e) {
      // throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      // throw const LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        instance.signOut(),
      ]);
    } catch (_) {
      // throw LogOutFailure();
    }
  }

  User get currentUser => _cache.user ?? User.empty;
  // final Database _db;
  // Future<List<RecordSnapshot>> karyawanList() {

  //   var store = intMapStoreFactory.store('karyawanAuth');
  //   return store.query().getSnapshots(_db);
  // }
}

extension UserParsing on auth.User {
  User get toUser {
    return User(
        email: email, foto: photoURL, namaKaryawan: displayName, id: uid);
  }
}

class Cache {
  User? user;
}

  // Future<void> signUp(
  //     {required String username, required String password}) async {
  //   try {
  //     /// fileservice.loginkaryawan(username,password);
  //     ///
  //     var store = intMapStoreFactory.store('karyawanAuth');
  //     User data = User(username: username, password: password);
  //     var exist = await store.findFirst(_db,
  //         finder: Finder(filter: Filter.equals('username', username)));
  //     if (exist != null) {
  //       throw Exception('username already exist');
  //     } else {
  //       await store.add(_db, data.toJson());
  //       _controller.add(User(username: username));
  //     }

  //     /// return : User
  //     /// _cache.write(user:user);
  //   } on Exception catch (e) {
  //     throw Exception(e);
  //   } catch (_) {
  //     throw Exception(_);
  //   }
  // }

  // Future<void> signOut() async {
  //   try {
  //     _controller.add(const User(username: ''));

  //     /// return : User
  //     /// _cache.write(user:user);
  //   } on Exception catch (e) {
  //     throw Exception(e);
  //   } catch (_) {
  //     throw Exception(_);
  //   }
  // }

  // Future<void> signIn(
  //     {required String username, required String password}) async {
  //   try {
  //     /// fileservice.loginkaryawan(username,password);
  //     ///
  //     var store = intMapStoreFactory.store('karyawanAuth');
  //     var a = await store.findFirst(_db,
  //         finder: Finder(
  //             filter: Filter.and([
  //           Filter.equals('username', username),
  //           Filter.equals('password', password),
  //         ])));
  //     if (a == null) {
  //       var b = await store.findFirst(_db,
  //           finder: Finder(filter: Filter.equals('username', username)));
  //       if (b != null) {
  //         throw 'pass not correct';
  //       } else {
  //         throw 'username not found, not correct';
  //       }
  //     } else {
  //       _controller.add(User(username: username));
  //     }

  //     /// return : User
  //     /// _cache.write(user:user);
  //   } on Exception catch (e) {
  //     throw Exception(e);
  //   } catch (_) {
  //     throw Exception(_);
  //   }
  // }

