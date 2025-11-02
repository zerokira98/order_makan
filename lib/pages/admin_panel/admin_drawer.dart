import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/pages/admin_panel/app_settings/app_settings.dart';
import 'package:order_makan/pages/admin_panel/inputbelibahan/input_bahanbaku.dart';
import 'package:order_makan/pages/admin_panel/karyawan_manage/karyawanmanage_main.dart';
import 'package:order_makan/pages/admin_panel/pengeluaran/pengeluaranpage.dart';
import 'package:order_makan/pages/admin_panel/rangkum/bloc/rangkuman_bloc.dart';
import 'package:order_makan/pages/admin_panel/rangkum/rangkuman_periodik/rangkuman_periodik.dart';
import 'package:order_makan/pages/histori_struk.dart';
import 'package:order_makan/repo/firestore_kas.dart';
import 'package:order_makan/repo/globalsettingrepo.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';
import 'package:order_makan/repo/strukrepo.dart';

class AdminDrawer extends StatefulWidget {
  const AdminDrawer({super.key});

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  final FocusNode lacifocusNode = FocusNode();
  final FocusNode wififocusNode = FocusNode();
  @override
  void dispose() {
    lacifocusNode.dispose();
    wififocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    return Drawer(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              children: [],
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Pengeluaran'),
            ),
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PengeluaranPage(),
                      ));
                },
                title: const Text('Catat Pengeluaran Umum')),
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InputBeliBahanbaku(),
                      ));
                },
                title: const Text('Pembelian Bahanbaku')),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Rangkuman'),
            ),
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoriStruk(),
                      ));
                },
                title: const Text('Histori Struk')),
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => RangkumanBloc(
                              RepositoryProvider.of<StrukRepository>(context),
                              RepositoryProvider.of<KasRepository>(context),
                              RepositoryProvider.of<MenuItemRepository>(
                                  context))
                            ..add(ChangeFilterRangkuman(
                                filter: StrukFilter(
                                    start:
                                        DateTime(now.year, now.month, now.day),
                                    end: DateTime(
                                        now.year, now.month, now.day + 1)))),
                          child: const RangkumanPeriodik(isHarian: true),
                        ),
                      ));
                },
                title: const Text('Rangkuman Harian')),
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => RangkumanBloc(
                              RepositoryProvider.of<StrukRepository>(context),
                              RepositoryProvider.of<KasRepository>(context),
                              RepositoryProvider.of<MenuItemRepository>(
                                  context))
                            ..add(ChangeFilterRangkuman(
                                filter: StrukFilter(
                                    start: DateTime(now.year, now.month),
                                    end: DateTime(now.year, now.month + 1)))),
                          child: const RangkumanPeriodik(),
                        ),
                      ));
                },
                title: const Text('Rangkuman Bulanan')),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Etc'),
            ),
            ListTile(
                onTap: () async {
                  var datatext =
                      await RepositoryProvider.of<KasRepository>(context)
                          .getUangLaciHarian()
                          .then(
                            (value) => value.data(),
                          );
                  showDialog(
                      context: context,
                      builder: (context) {
                        var tct = TextEditingController(
                            text: datatext?['uang'].toString() ?? '');
                        var telo = CurrencyTextInputFormatter.simpleCurrency(
                            decimalDigits: 0, locale: 'id_ID');
                        lacifocusNode.requestFocus();
                        return Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: TextFormField(
                                    controller: tct,
                                    autovalidateMode: AutovalidateMode.always,
                                    validator: (value) => numberValidator(
                                        telo.getUnformattedValue().toString()),
                                    inputFormatters: [telo],
                                    onFieldSubmitted: (value) {
                                      debugPrint(value);
                                      // BlocProvider.of<UseStrukBloc>(
                                      //         context)
                                      //     .add(ChangeCount(
                                      //         item: state.orderItems[
                                      //             widget.index],
                                      //         count:
                                      //             int.parse(value)));
                                      // Navigator.pop(context);
                                    },
                                    focusNode: lacifocusNode,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        label: Text('Uang Laci')),
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      if (telo.getDouble() != 0) {
                                        RepositoryProvider.of<KasRepository>(
                                                context)
                                            .setUangLaciHarian(
                                                int.tryParse(tct.text)!)
                                            .then(
                                              (value) => Navigator.pop(context),
                                            );
                                      }
                                    },
                                    child: Text('set'))
                              ],
                            ),
                          ),
                        );
                      });
                },
                title: Text('Set Uang Laci Hari ini')),
            ListTile(
                onTap: () {
                  RepositoryProvider.of<GlobalSettingRepo>(context)
                      .getWifiPass()
                      .then((datatext) {
                    if (context.mounted) {
                      return showDialog(
                          context: context,
                          builder: (context) {
                            var tct = TextEditingController(text: datatext);
                            wififocusNode.requestFocus();
                            return Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: TextFormField(
                                        controller: tct,
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                        // validator: (value) => numberValidator(
                                        //     telo.getUnformattedValue().toString()),
                                        // inputFormatters: [telo],
                                        onFieldSubmitted: (value) {
                                          RepositoryProvider.of<
                                                  GlobalSettingRepo>(context)
                                              .setWifiPass(tct.text)
                                              .then(
                                                (value) =>
                                                    Navigator.pop(context),
                                              );
                                        },
                                        focusNode: wififocusNode,

                                        // keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            label: Text('password wifi')),
                                      ),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          RepositoryProvider.of<
                                                  GlobalSettingRepo>(context)
                                              .setWifiPass(tct.text)
                                              .then(
                                                (value) =>
                                                    Navigator.pop(context),
                                              );
                                        },
                                        child: Text('set'))
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                  });
                },
                title: Text('Set password wifi')),
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KaryawanManageMain(),
                      ));
                },
                title: const Text('Manage Karyawan')),
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppSettings(),
                      ));
                },
                trailing: Icon(Icons.settings),
                title: const Text('App Settings')),
          ],
          // children: List.generate(
          //     a.length,
          //     (index) => ),
        ),
      ),
    );
  }
}
