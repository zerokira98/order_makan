import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:order_makan/bloc/antrian/antrian_bloc.dart';
import 'package:order_makan/bloc/karyawanauth/karyawanauth_bloc.dart';
import 'package:order_makan/bloc/notif/notif_cubit.dart';
import 'package:order_makan/bloc/use_struk/struk_bloc.dart';
import 'package:order_makan/bloc/topbarbloc/topbar_bloc.dart';
import 'package:order_makan/bloc/menu/menu_bloc.dart' as m;
import 'package:order_makan/firebase_options.dart';
import 'package:order_makan/pages/admin_panel/adminpanel_main.dart';
import 'package:order_makan/pages/admin_panel/inputbelibahan/cubit/inputbeliform_cubit.dart';
import 'package:order_makan/pages/admin_panel/edit_app/cubit/menuedit_cubit.dart';
import 'package:order_makan/pages/firstrun_setup.dart';
import 'package:order_makan/pages/karyawan_loginpage.dart';
import 'package:order_makan/pages/karyawan_signup.dart';
import 'package:order_makan/repo/firestore_kas.dart';
import 'package:order_makan/repo/karyawan_authrepo.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';
import 'package:order_makan/repo/strukrepo.dart';
import 'package:order_makan/pages/use_app/use_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeDateFormatting('id_ID', null);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  var fireApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // var db = await SembastDB.init();
  // var db2 = await SembastDB.init2();
  var firebase = FirebaseAuth.instanceFor(app: fireApp);
  var firestore = FirebaseFirestore.instanceFor(app: fireApp);
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(
        create: (context) => firebase,
      ),
      RepositoryProvider(
        create: (context) => firestore,
      ),
      RepositoryProvider(
        create: (context) => KasRepository(fire: firestore),
        child: Container(),
      ),
      RepositoryProvider(
        create: (context) => KaryawanAuthRepo(firebase, firestore),
      ),
      RepositoryProvider(
        create: (context) => MenuItemRepository(firestore),
      ),
      RepositoryProvider(
        create: (context) => StrukRepository(
            firestore, RepositoryProvider.of<MenuItemRepository>(context)),
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              NotifCubit(RepositoryProvider.of<MenuItemRepository>(context)),
          child: Container(),
        ),
        BlocProvider(
          create: (context) =>
              MenueditCubit(RepositoryProvider.of<MenuItemRepository>(context)),
        ),
        BlocProvider(
          create: (context) => InputbeliformCubit(
              RepositoryProvider.of<MenuItemRepository>(context))
            ..initiate(),
        ),
        BlocProvider(
          create: (context) => UseStrukBloc(
              RepositoryProvider.of<StrukRepository>(context),
              RepositoryProvider.of<KaryawanAuthRepo>(context)),
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
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final backgroundcolor = Color(0xfffcf6e8);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<KaryawanauthBloc, KaryawanauthState>(
          listener: (context, state) {
            if (state is KaryawanAuthenticated) {
              BlocProvider.of<UseStrukBloc>(context)
                  .add(InitiateStruk(karyawanId: state.user.namaKaryawan));
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
        // routes: {'/adminpanel': (context) => AdminPanel()},
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          MonthYearPickerLocalizations.delegate,
        ],
        title: 'Flutter Demo',
        themeMode: ThemeMode.system,
        darkTheme: ThemeData.dark(useMaterial3: true),
        theme: ThemeData(
          scaffoldBackgroundColor: backgroundcolor,
          appBarTheme: AppBarTheme.of(context)
              .copyWith(backgroundColor: backgroundcolor),
          cardColor: backgroundcolor,
          cardTheme: CardTheme.of(context).copyWith(color: backgroundcolor),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: StatefulBuilder(builder: (context, setstate) {
          var future = SharedPreferences.getInstance()
              .then((value) => value.getInt('firstStart'));
          click() => setstate(() {
                future = future;
              });
          return FutureBuilder(
            future: future,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.done) {
                if ((snap.data == null) | (snap.data == 0)) {
                  return SetupPage(click);
                } else if (snap.data == 1) {
                  return KaryawanSignupPage(
                    firstTime: true,
                  );
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
          );
        }),
      ),
    );
  }
}
