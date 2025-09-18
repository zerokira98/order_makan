
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/pages/admin_panel/inputbelibahan/input_bahanbaku.dart';
import 'package:order_makan/pages/admin_panel/karyawan_manage/karyawanmanage_main.dart';
import 'package:order_makan/pages/admin_panel/pengeluaran/pengeluaranpage.dart';
import 'package:order_makan/pages/admin_panel/rangkum/bloc/rangkuman_bloc.dart';
import 'package:order_makan/pages/admin_panel/rangkum/rangkuman_periodik/rangkuman_periodik.dart';
import 'package:order_makan/pages/histori_struk.dart';
import 'package:order_makan/repo/firestore_kas.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';
import 'package:order_makan/repo/strukrepo.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

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
                        final FocusNode focusNode = FocusNode();
                        var tct = TextEditingController(
                            text: datatext?['uang'].toString() ?? '');
                        var telo = CurrencyTextInputFormatter.simpleCurrency(
                            decimalDigits: 0, locale: 'id_ID');
                        focusNode.requestFocus();
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
                                    focusNode: focusNode,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        label: Text('Uang Laci')),
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      print(telo.getDouble());
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
                  // setState(() {
                  //   selectedIndex = 0;
                  // });
                  // Navigator.pop(context);
                },
                title: Text('Set Uang Laci Hari ini')),
            // ListTile(
            //     onTap: () async {
            //       var datatext = await SharedPreferences.getInstance().then(
            //         (value) {
            //           try {
            //             var a = value.getString('globalSetting') ?? '{}';
            //             print(a);
            //             var b = jsonDecode(a);
            //             return '${b['namaresto']}';
            //           } catch (e) {
            //             return '';
            //           }
            //         },
            //       );
            //       showDialog(
            //           context: context,
            //           builder: (context) {
            //             final FocusNode focusNode = FocusNode();
            //             var tct =
            //                 TextEditingController(text: datatext.toString());
            //             focusNode.requestFocus();
            //             return Dialog(
            //               child: Padding(
            //                 padding: const EdgeInsets.all(18.0),
            //                 child: Row(
            //                   mainAxisSize: MainAxisSize.min,
            //                   children: [
            //                     SizedBox(
            //                       width: 120,
            //                       child: TextFormField(
            //                         controller: tct,
            //                         validator: usernameValidator,
            //                         onFieldSubmitted: (value) {
            //                           debugPrint(value);
            //                         },
            //                         focusNode: focusNode,
            //                         keyboardType: TextInputType.name,
            //                         decoration: InputDecoration(
            //                             label: Text('Nama resto')),
            //                       ),
            //                     ),
            //                     ElevatedButton(
            //                         onPressed: () async {
            //                           var sp =
            //                               await SharedPreferences.getInstance();
            //                           await sp
            //                               .setString(
            //                                   'globalSetting',
            //                                   jsonEncode(
            //                                       {'namaresto': tct.text}))
            //                               .then(
            //                             (value) {
            //                               if (value) {
            //                                 Navigator.pop(context);
            //                               } else {
            //                                 debugPrint('error');
            //                               }
            //                             },
            //                           );
            //                         },
            //                         child: Text('set'))
            //                   ],
            //                 ),
            //               ),
            //             );
            //           });
            //       // setState(() {
            //       //   selectedIndex = 0;
            //       // });
            //       // Navigator.pop(context);
            //     },
            //     title: Text('Ganti Nama Resto/Kafe')),
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KaryawanManageMain(),
                      ));
                },
                title: const Text('Manage Karyawan')),
          ],
          // children: List.generate(
          //     a.length,
          //     (index) => ),
        ),
      ),
    );
  }
}
