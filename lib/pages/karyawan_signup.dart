import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/karyawanauth/karyawanauth_bloc.dart';
import 'package:order_makan/main.dart';

class KaryawanSignupPage extends StatefulWidget {
  final bool? firstTime;
  const KaryawanSignupPage({super.key, this.firstTime});

  @override
  State<KaryawanSignupPage> createState() => _KaryawanSignupPageState();
}

class _KaryawanSignupPageState extends State<KaryawanSignupPage> {
  TextEditingController username = TextEditingController();

  TextEditingController password = TextEditingController();
  bool obsecure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Karyawan Signup Page'),
            Text('Buat akun karyawan pertama',
                textScaler: TextScaler.linear(0.5)),
          ],
        ),
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
                controller: username,
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
                    // var a = await SharedPreferences.getInstance();
                    // var b = a.getString('karyawanCred');
                    // if (b != null) {
                    //   var c = jsonDecode(b);
                    var crypted =
                        Crypt.sha512(password.text, salt: 'garam').hash;
                    BlocProvider.of<KaryawanauthBloc>(context)
                        .add(SignUp(username.text, crypted));
                    if (widget.firstTime != null) {
                      if (widget.firstTime!) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyApp(),
                          ),
                          (route) => false,
                        );
                      }
                    }
                    //   if (c['username'] == username.text &&
                    //       c['password'] == crypted) {
                    //     Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => const UseMain(),
                    //         ));
                    //   }
                    // }
                  },
                  child: const Text('Signup'))
            ],
          )),
        ),
      ),
    );
  }
}
