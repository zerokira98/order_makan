
import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/karyawanauth/karyawanauth_bloc.dart';
import 'package:order_makan/pages/admin_loginpage.dart';

class KaryawanLoginPage extends StatefulWidget {
  const KaryawanLoginPage({super.key});

  @override
  State<KaryawanLoginPage> createState() => _KaryawanLoginPageState();
}

class _KaryawanLoginPageState extends State<KaryawanLoginPage> {
  TextEditingController username = TextEditingController();

  TextEditingController password = TextEditingController();
  bool obsecure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Karyawan Login Page'),
      ),
      body: BlocListener<KaryawanauthBloc, KaryawanauthState>(
        listener: (context, state) {
          if (state is KaryawanUnAuth) {
            if (state.errorMsg != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('${state.errorMsg}')));
            }
          }
        },
        child: SingleChildScrollView(
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
                      var crypted =
                          Crypt.sha512(password.text, salt: 'garam').hash;
                      BlocProvider.of<KaryawanauthBloc>(context)
                          .add(SignIn(username.text, crypted));
                      // var a = await SharedPreferences.getInstance();
                      // var b = a.getString('karyawanCred');
                      // print(b);
                      // if (b != null) {
                      //   var c = jsonDecode(b);
                      //   var crypted =
                      //       Crypt.sha512(password.text, salt: 'garam').hash;
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
                    child: const Text('Login')),
                const Padding(padding: EdgeInsets.all(18)),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminLoginPage(),
                          ));
                    },
                    child: const Text('Admin Panel'))
              ],
            )),
          ),
        ),
      ),
    );
  }
}
