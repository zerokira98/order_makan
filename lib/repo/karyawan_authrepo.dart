import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:order_makan/helper.dart';
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

  Future<bool> isAdmin() {
    return firestore.collection('users').doc(currentUser.id).get().then(
      (value) {
        debugPrint((value.data()?['role'] == 'admin').toString());
        return value.data()?['role'] == 'admin';
      },
    );
  }

  Future<List<Map<String, dynamic>?>> getAllKaryawan([String? karyawanId]) {
    if (karyawanId == null) {
      return firestore.collection('users').get().then(
            (value) => value.docs
                .map(
                  (e) => e.data(),
                )
                .toList(),
          );
    }
    return firestore.collection('users').doc(karyawanId).get().then(
          (value) => [value.data()],
        );
  }

  Future<void> signUp(
      {required String email,
      required String password,
      String? role,
      String? displayName}) async {
    try {
      await instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (value) {
          return firestore.collection('users').doc(value.user?.uid).set({
            "name": displayName ?? '',
            "email": value.user?.email ?? '',
            "role": role ?? "karyawan",
            "id": value.user?.uid
          });
        },
      );
    } on auth.FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      // throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      // throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<void> logInWithUserAndPassword({
    required String email,
    required String password,
  }) async {
    // try {
    await instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // } on auth.FirebaseAuthException catch (e) {
    //   print(e.toString());
    //   // throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    // } catch (_) {
    //   // throw const LogInWithEmailAndPasswordFailure();
    // }
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // try {
    await instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // } on auth.FirebaseAuthException catch (e) {
    //   debugPrint(e.toString());
    //   // throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    // } catch (_) {
    //   debugPrint(_.toString());
    //   // throw const LogInWithEmailAndPasswordFailure();
    // }
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

  set setcurrentAdmin(bool set) =>
      _cache.user = _cache.user?.setAdmin() ?? User.empty;
  User get currentUser => _cache.user ?? User.empty;

  Future<QuerySnapshot<Map<String, dynamic>>> karyawanList() {
    return firestore.collection('users').get();
  }
  // final Database _db;
  // Future<List<RecordSnapshot>> karyawanList() {

  //   var store = intMapStoreFactory.store('karyawanAuth');
  //   return store.query().getSnapshots(_db);
  // }
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

