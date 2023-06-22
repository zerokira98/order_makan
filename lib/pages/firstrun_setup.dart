// set admin credential
// set 1 karyawan credential(?)

import 'dart:convert';

import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:order_makan/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final TextEditingController usernamec = TextEditingController(text: '');

  final TextEditingController password = TextEditingController(text: '');

  final TextEditingController password2 = TextEditingController(text: '');

  final TextEditingController namaResto = TextEditingController(text: '');
  bool obsecure1 = true;
  bool obsecure2 = true;
  GlobalKey<FormState> a = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Sign Up'),
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
                  controller: usernamec,
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
                  controller: password,
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
                    if (value != password.text) {
                      return 'Tidak Sama';
                    }
                    if (value!.length < 6) {
                      return 'At least 6';
                    }
                    return null;
                    //
                  },
                  controller: password2,
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
                        var cryptedpass =
                            Crypt.sha512(password.text, salt: 'garam');
                        Map c = {
                          'username': usernamec.text,
                          'password': cryptedpass.hash,
                        };
                        Map d = {
                          'namaresto': namaResto.text,
                        };
                        await b.setString('adminCred', jsonEncode(c));
                        await b.setString('globalSetting', jsonEncode(d));
                        // b.setStringList('adminCred', []);
                        await b.setBool('firstStart', false);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MyHome(title: 'title'),
                            ));
                      }
                    },
                    child: const Text('Complete Setup'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
