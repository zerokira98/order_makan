// set admin credential
// set 1 karyawan credential(?)

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/component/screen_lock.dart';
import 'package:order_makan/helper.dart' show usernameValidator, validateEmail;
import 'package:order_makan/model/menuitems_model.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupPage extends StatefulWidget {
  final void Function() click;
  const SetupPage(this.click, {super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final TextEditingController username = TextEditingController(text: '');
  final TextEditingController email = TextEditingController(text: '');
  final TextEditingController passworda = TextEditingController(text: '');
  final TextEditingController passworda2 = TextEditingController(text: '');

  // final TextEditingController namaResto = TextEditingController(text: '');
  bool obsecure1 = true;
  bool obsecure2 = true;
  GlobalKey<FormState> a = GlobalKey();
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) {
          return PopScope(
            canPop: false,
            child: KeyLock(
              showCancel: false,
              tendigits: '392785',
              title: 'First Started',
              //content: Text('Hello'),
            ),
          );
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sign Up Admin for App'),
            Text('First time setup. Don\'t forget',
                textScaler: TextScaler.linear(0.5)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: SingleChildScrollView(
          child: Form(
            key: a,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  controller: username,
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  validator: usernameValidator,
                  decoration: const InputDecoration(label: Text('Username')),
                ),
                TextFormField(
                  controller: email,
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  validator: validateEmail,
                  decoration: const InputDecoration(label: Text('Email')),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'At least 6';
                    }
                    return null;
                    //
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  controller: passworda,
                  obscureText: obsecure1,
                  decoration: InputDecoration(
                      label: const Text('Password'),
                      suffixIcon: IconButton(
                          focusNode: FocusNode(
                              skipTraversal: true, canRequestFocus: false),
                          onPressed: () {
                            setState(() {
                              obsecure1 = !obsecure1;
                            });
                          },
                          icon: Icon(obsecure1
                              ? Icons.visibility
                              : Icons.visibility_off))),
                ),
                TextFormField(
                  validator: (value) {
                    if (value != passworda.text) {
                      return 'Tidak Sama';
                    }
                    if (value!.length < 6) {
                      return 'At least 6';
                    }
                    return null;
                    //
                  },
                  controller: passworda2,
                  obscureText: obsecure2,
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  decoration: InputDecoration(
                      label: const Text('Ketik Password Lagi'),
                      suffixIcon: IconButton(
                          focusNode: FocusNode(
                              skipTraversal: true, canRequestFocus: false),
                          onPressed: () {
                            setState(() {
                              obsecure2 = !obsecure2;
                            });
                          },
                          icon: Icon(obsecure2
                              ? Icons.visibility
                              : Icons.visibility_off))),
                ),
                // TextFormField(
                //   validator: (value) {
                //     if (value!.length < 3) {
                //       return 'At least 3';
                //     }
                //     return null;
                //     //
                //   },
                //   controller: namaResto,
                //   autovalidateMode: AutovalidateMode.onUserInteraction,
                //   onEditingComplete: () {
                //     FocusScope.of(context).nextFocus();
                //   },
                //   decoration: const InputDecoration(label: Text('Nama Kafe')),
                // ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        if (a.currentState?.validate() ?? false) {
                          var sharedpref =
                              await SharedPreferences.getInstance();
                          // Map d = {
                          //   'namaresto': namaResto.text,
                          // };
                          var auth =
                              RepositoryProvider.of<FirebaseAuth>(context);
                          var store =
                              RepositoryProvider.of<FirebaseFirestore>(context);
                          await auth
                              .createUserWithEmailAndPassword(
                                  email: email.text, password: passworda.text)
                              .then(
                            (value) async {
                              await value.user!
                                  .updateDisplayName(username.text);
                              await store
                                  .collection('users')
                                  .doc(value.user?.uid)
                                  .set(
                                      {"name": username.text, "role": "admin"});
                              List firstcat = ['meals', 'snacks', 'drinks'];
                              var menurepo =
                                  RepositoryProvider.of<MenuItemRepository>(
                                      context);
                              if ((await menurepo.getCategories()).isEmpty) {
                                for (var e in firstcat) {
                                  await menurepo.addCategory(e);
                                }
                                List firstmenus = [
                                  MenuItems(
                                      title: 'Nasi',
                                      imgDir: 'assets/nasi.jpg',
                                      categories: ['meals'],
                                      price: 3500),
                                  MenuItems(
                                      title: 'Kentang',
                                      imgDir: 'assets/kentang.jpg',
                                      categories: ['snacks'],
                                      price: 5500),
                                  MenuItems(
                                      title: 'Es Teh',
                                      imgDir: 'assets/es_teh.jpg',
                                      categories: ['drinks'],
                                      price: 3000),
                                ];
                                for (var e in firstmenus) {
                                  await menurepo.addMenu(e);
                                }
                              }
                            },
                          );
                          // BlocProvider.of<KaryawanauthBloc>(context).add(SignUpAdmin());
                          // await sharedpref.setString('adminCred', jsonEncode(c));
                          // await sharedpref.setString(
                          //     'globalSetting', jsonEncode(d));
                          // b.setStringList('adminCred', []);

                          ///set default menu

                          await sharedpref.setInt('firstStart', 1);

                          await auth.signOut();
                          widget.click();
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => const KaryawanSignupPage(
                          //         firstTime: true,
                          //       ),
                          //     ));
                        }
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                    child: const Text('Next')),
                Padding(padding: EdgeInsetsGeometry.all(64.0)),
                ElevatedButton(
                    onPressed: () {
                      SharedPreferences.getInstance().then(
                        (value) {
                          value.setInt('firstStart', 2);
                          widget.click();
                        },
                      );
                    },
                    child: Text('Skip'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
