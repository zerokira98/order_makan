// set admin credential
// set 1 karyawan credential(?)

import 'dart:convert';

import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/menu/menu_bloc.dart';
import 'package:order_makan/bloc/topbarbloc/topbar_bloc.dart';
import 'package:order_makan/model/menuitems_model.dart';
import 'package:order_makan/pages/karyawan_signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final TextEditingController usernamea = TextEditingController(text: '');
  final TextEditingController passworda = TextEditingController(text: '');
  final TextEditingController passworda2 = TextEditingController(text: '');

  final TextEditingController namaResto = TextEditingController(text: '');
  bool obsecure1 = true;
  bool obsecure2 = true;
  GlobalKey<FormState> a = GlobalKey();
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Hello'),
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
            Text('First time setup. Don\'t forget', textScaleFactor: 0.5),
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
                  controller: usernamea,
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  validator: (value) {
                    if (value!.length < 3) {
                      return 'need more character';
                    }
                    return null;
                    //
                  },
                  decoration: const InputDecoration(label: Text('Username')),
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
                TextFormField(
                  validator: (value) {
                    if (value!.length < 3) {
                      return 'At least 3';
                    }
                    return null;
                    //
                  },
                  controller: namaResto,
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  decoration: const InputDecoration(label: Text('Nama Resto')),
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (a.currentState!.validate()) {
                        var b = await SharedPreferences.getInstance();
                        var cryptedpassa =
                            Crypt.sha512(passworda.text, salt: 'garam');
                        Map c = {
                          'username': usernamea.text,
                          'password': cryptedpassa.hash,
                        };
                        Map d = {
                          'namaresto': namaResto.text,
                        };
                        await b.setString('adminCred', jsonEncode(c));
                        await b.setString('globalSetting', jsonEncode(d));
                        // b.setStringList('adminCred', []);
                        await b.setBool('firstStart', false);

                        ///set default menu
                        List firstcat = ['meals', 'snacks', 'drinks'];
                        for (var e in firstcat) {
                          BlocProvider.of<TopbarBloc>(context)
                              .add(AddCat(name: e));
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
                          BlocProvider.of<MenuBloc>(context).add(AddMenu(e));
                        }
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const KaryawanSignupPage(
                                firstTime: true,
                              ),
                            ));
                      }
                    },
                    child: const Text('Next'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
