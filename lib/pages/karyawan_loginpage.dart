import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/karyawanauth/karyawanauth_bloc.dart';
import 'package:order_makan/component/screen_lock.dart';
import 'package:order_makan/helper.dart' show validateEmail;
import 'package:order_makan/pages/karyawan_signup.dart';

class KaryawanLoginPage extends StatefulWidget {
  const KaryawanLoginPage({super.key});

  @override
  State<KaryawanLoginPage> createState() => _KaryawanLoginPageState();
}

class _KaryawanLoginPageState extends State<KaryawanLoginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();

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
          print(state);
          if (state is KaryawanUnAuth) {
            if (state.errorMsg != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('${state.errorMsg}')))
                  .closed
                  .then(
                    (value) => BlocProvider.of<KaryawanauthBloc>(context)
                        .add(InitiateKaryawan()),
                  );
            }
          }
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Center(
                child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    validator: validateEmail,
                    enableSuggestions: true,
                    onChanged: (value) => setState(() {}),
                    decoration: const InputDecoration(label: Text('Email')),
                  ),
                  TextFormField(
                    controller: password,
                    onChanged: (value) => setState(() {}),
                    obscureText: obsecure,
                    onFieldSubmitted: _formkey.currentState?.validate() ?? false
                        ? (value) async {
                            BlocProvider.of<KaryawanauthBloc>(context)
                                .add(SignIn(email.text, password.text));
                          }
                        : null,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              showDialog<bool?>(
                                context: context,
                                builder: (context) => KeyLock(
                                    tendigits: '392785', title: 'App Pass'),
                              ).then(
                                (value) {
                                  if (value != null && value) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              KaryawanSignupPage(),
                                        ));
                                  } else {}
                                },
                              );
                            },
                            child: const Text('Signup')),
                        Padding(padding: EdgeInsetsGeometry.all(8)),
                        ElevatedButton(
                            onPressed: _formkey.currentState?.validate() ??
                                    false
                                ? () =>
                                    BlocProvider.of<KaryawanauthBloc>(context)
                                        .add(SignIn(email.text, password.text))
                                : null,
                            child: const Text('Login')),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(18)),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => const AdminLoginPage(),
                  //           ));
                  //     },
                  //     child: const Text('Admin Panel'))
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}
