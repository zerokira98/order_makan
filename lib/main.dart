import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/topbarbloc/topbar_bloc.dart';
import 'package:order_makan/bloc/menu/menu_bloc.dart' as m;
import 'package:order_makan/pages/admin_loginpage.dart';
import 'package:order_makan/pages/firstrun_setup.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';
import 'package:order_makan/repo/strukrepo.dart';
import 'package:order_makan/sembastdb.dart';
import 'package:order_makan/pages/use_app/use_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var db = await SembastDB.init();
  var db2 = await SembastDB.init2();
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(
        create: (context) => MenuItemRepository(db),
      ),
      RepositoryProvider(
        create: (context) => StrukRepository(db2),
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              TopbarBloc(RepositoryProvider.of<MenuItemRepository>(context))
                ..add(Init()),
        ),
        BlocProvider(
            create: (context) => m.MenuBloc(
                  RepositoryProvider.of<MenuItemRepository>(context),
                )..add(m.Init())),
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocListener<TopbarBloc, TopbarState>(
      listenWhen: (p, c) => p.selected != c.selected,
      listener: (context, state) {
        BlocProvider.of<m.MenuBloc>(context)
            .add(m.ChangeTopbarCat(catName: state.selected ?? '[ALL]'));
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        themeMode: ThemeMode.system,
        darkTheme: ThemeData.dark(useMaterial3: true),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: FutureBuilder(
          future: SharedPreferences.getInstance()
              .then((value) => value.getBool('firstStart')),
          builder: (context, snap) {
            if ((snap.data == null) | (snap.data == true)) {
              return const SetupPage();
            } else {
              return const MyHome(title: 'Flutter Home Page');
            }
          },
        ),
      ),
    );
  }
}

class MyHome extends StatelessWidget {
  final String title;
  const MyHome({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: SystemUiOverlay.values);
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('Login Karyawan'),
        const Card(
            child: Padding(
          padding: EdgeInsets.all(28.0),
          child: Text('login Form'),
        )),
        ElevatedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UseMain(),
                )),
            child: const Text('Login Karyawan')),
        ElevatedButton(
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminLoginPage(),
                  ));
            },
            child: const Text('Admin Panel')),
      ]),
    );
  }
}

class LoginKaryawan extends StatelessWidget {
  const LoginKaryawan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('Login Karyawan'),
        const Card(
            child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('login Karyawan form'),
        )),
        ElevatedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginKaryawan(),
                )),
            child: const Text('Login'))
      ]),
    );
  }
}
