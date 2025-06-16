import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/antrian/antrian_bloc.dart';
import 'package:order_makan/bloc/karyawanauth/karyawanauth_bloc.dart';
import 'package:order_makan/bloc/struk/struk_bloc.dart';
import 'package:order_makan/bloc/topbarbloc/topbar_bloc.dart';
import 'package:order_makan/bloc/menu/menu_bloc.dart' as m;
import 'package:order_makan/pages/firstrun_setup.dart';
import 'package:order_makan/pages/karyawan_loginpage.dart';
import 'package:order_makan/repo/karyawan_authrepo.dart';
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
        create: (context) => KaryawanAuthRepo(db),
      ),
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
          create: (context) => StrukBloc(),
        ),
        BlocProvider(
          create: (context) =>
              AntrianBloc(RepositoryProvider.of<StrukRepository>(context))
                ..add(InitiateAntrian()),
        ),
        BlocProvider(
          create: (context) => KaryawanauthBloc(
              RepositoryProvider.of<KaryawanAuthRepo>(context)),
        ),
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
    return MultiBlocListener(
      listeners: [
        BlocListener<AntrianBloc, AntrianState>(
          listener: (context, state) {
            // TODO: implement listener
          },
        ),
        BlocListener<KaryawanauthBloc, KaryawanauthState>(
          listener: (context, state) {
            if (state is KaryawanAuthenticated) {
              BlocProvider.of<StrukBloc>(context)
                  .add(InitiateStruk(karyawanId: state.user.username));
            }
          },
        ),
        BlocListener<TopbarBloc, TopbarState>(
          listenWhen: (p, c) =>
              p.selected != c.selected && c.selected.isNotEmpty,
          listener: (context, state) {
            BlocProvider.of<m.MenuBloc>(context)
                .add(m.ChangeTopbarCat(catName: state.selected));
          },
        )
      ],
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
            if (snap.connectionState == ConnectionState.done) {
              if ((snap.data == null) | (snap.data == true)) {
                return const SetupPage();
              } else {
                return BlocBuilder<KaryawanauthBloc, KaryawanauthState>(
                  builder: (context, state) {
                    if (state is! KaryawanAuthenticated) {
                      return const KaryawanLoginPage();
                    } else {
                      return const UseMain();
                    }
                  },
                );
              }
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

// class MyHome extends StatelessWidget {
//   final String title;
//   const MyHome({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
//         overlays: SystemUiOverlay.values);
//     return Scaffold(
//       appBar: AppBar(title: BlocBuilder<KaryawanauthBloc, KaryawanauthState>(
//         builder: (context, state) {
//           if (state is KaryawanAuthenticated) {
//             return Text('username:${state.user.username}');
//           } else {
//             return const Text('title');
//           }
//         },
//       )),
//       body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//         // const Text('Login Karyawan'),
//         // const Card(
//         //     child: Padding(
//         //   padding: EdgeInsets.all(28.0),
//         //   child: Text('login Form'),
//         // )),
//         BlocBuilder<KaryawanauthBloc, KaryawanauthState>(
//           builder: (context, state) {
//             if (state is! KaryawanAuthenticated) {
//               return ElevatedButton(
//                   onPressed: () {
//                     // BlocProvider.of<TopbarBloc>(context).add(Init());
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const KaryawanLoginPage(),
//                         ));
//                   },
//                   child: const Text('Login Karyawan'));
//             } else {
//               return ElevatedButton(
//                   onPressed: () {
//                     BlocProvider.of<TopbarBloc>(context).add(Init());
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const UseMain(),
//                         ));
//                   },
//                   child: const Text('Usemain'));
//             }
//           },
//         ),
//         ElevatedButton(
//             onPressed: () async {
//               var a = await RepositoryProvider.of<StrukRepository>(context)
//                   .readAllStruk();
//               print(a[a.length - 1]);
//               // Navigator.push(
//               //     context,
//               //     MaterialPageRoute(
//               //       builder: (context) => const AdminLoginPage(),
//               //     ));
//             },
//             child: const Text('Admin Panel')),
//         ElevatedButton(
//             onPressed: () async {
//               BlocProvider.of<KaryawanauthBloc>(context).add(SignOut());
//             },
//             child: const Text('LogOut')),
//       ]),
//     );
//   }
// }
