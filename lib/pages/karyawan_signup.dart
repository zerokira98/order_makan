import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/karyawanauth/karyawanauth_bloc.dart';
import 'package:order_makan/helper.dart' show validateEmail, usernameValidator;
import 'package:order_makan/main.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

class KaryawanSignupPage extends StatefulWidget {
  final bool firstTime;
  const KaryawanSignupPage({super.key, this.firstTime = false});

  @override
  State<KaryawanSignupPage> createState() => _KaryawanSignupPageState();
}

class _KaryawanSignupPageState extends State<KaryawanSignupPage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();
  bool obsecure = true;
  @override
  Widget build(BuildContext context) {
    return BlocListener<KaryawanauthBloc, KaryawanauthState>(
      listenWhen: (previous, current) => current is KaryawanAuthenticated,
      listener: (context, state) {
        if (widget.firstTime == false) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Karyawan Signup Page'),
              Text(widget.firstTime == true ? 'Buat akun karyawan pertama' : '',
                  textScaler: TextScaler.linear(0.5)),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Center(
                child: Form(
              key: formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: username,
                    validator: usernameValidator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(label: Text('Username')),
                  ),
                  TextFormField(
                    controller: email,
                    validator: validateEmail,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(label: Text('Email')),
                  ),
                  TextFormField(
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
                      onPressed: formkey.currentState?.validate() ?? false
                          ? () async {
                              var sharedpref =
                                  await SharedPreferences.getInstance();
                              // var b = a.getString('karyawanCred');
                              // if (b != null) {
                              //   var c = jsonDecode(b);
                              try {
                                BlocProvider.of<KaryawanauthBloc>(context).add(
                                    SignUp(email.text, password.text,
                                        username.text));

                                if (widget.firstTime) {
                                  await sharedpref.setInt('firstStart', 2);
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MyApp(),
                                    ),
                                    (route) => false,
                                  );
                                } else {}
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                            }
                          : null,
                      child: const Text('Signup'))
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}
