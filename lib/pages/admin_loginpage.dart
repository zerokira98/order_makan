import 'dart:convert';

import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:order_makan/pages/admin_panel/adminpanel_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController usernamec = TextEditingController(text: '');

  final TextEditingController password = TextEditingController(text: '');

  bool obsecure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel Login Page'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: usernamec,
                decoration: const InputDecoration(label: Text('Username')),
              ),
              TextField(
                controller: password,
                obscureText: obsecure,
                decoration: InputDecoration(
                    label: const Text('Password'),
                    suffixIcon: IconButton(
                        focusNode: FocusNode(
                            skipTraversal: true, canRequestFocus: false),
                        onPressed: () {
                          setState(() {
                            obsecure = !obsecure;
                          });
                        },
                        icon: Icon(obsecure
                            ? Icons.visibility
                            : Icons.visibility_off))),
              ),
              const Padding(padding: EdgeInsets.all(8)),
              ElevatedButton(
                  onPressed: () async {
                    var a = await SharedPreferences.getInstance();
                    var b = a.getString('adminCred');
                    if (b != null) {
                      var c = jsonDecode(b);
                      var crypted =
                          Crypt.sha512(password.text, salt: 'garam').hash;
                      if (c['username'] == usernamec.text &&
                          c['password'] == crypted) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminPanel(),
                            ));
                      }
                    }
                  },
                  child: const Text('Login'))
            ],
          )),
        ),
      ),
    );
  }
}
