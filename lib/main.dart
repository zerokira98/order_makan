import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/topbarbloc/topbar_bloc.dart';
import 'package:order_makan/edit_app/edit_main.dart';
import 'package:order_makan/bloc/menu/menu_bloc.dart' as m;
import 'package:order_makan/repo/menuitemsrepo.dart';
import 'package:order_makan/sembastdb.dart';
import 'package:order_makan/use_app/use_main.dart';

import 'use_app/bloc/struk/struk_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var db = await SembastDB.init();
  runApp(RepositoryProvider(
    create: (context) => MenuItemRepository(db),
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
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(useMaterial3: true),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHome(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHome extends StatelessWidget {
  final String title;
  const MyHome({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('Login App'),
        const Card(
            child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('login app form'),
        )),
        ElevatedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => StrukBloc(),
                    child: const EditMain(),
                  ),
                )),
            child: const Text('Login Pengusaha')),
        ElevatedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UseMain(),
                )),
            child: const Text('Login Karyawan')),
        ElevatedButton(
            onPressed: () async {
              // var menurepo = RepositoryProvider.of<MenuItemRepository>(context);
              // await menurepo
              //     .deleteMenu(MenuItems(title: 'Kentang', imgDir: ''));
              // var printable = await menurepo.getAllMenus();
            },
            child: const Text('Button debug')),
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
