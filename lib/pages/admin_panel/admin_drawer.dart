import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/pages/admin_panel/inputbelibahan/input_bahanbaku.dart';
import 'package:order_makan/pages/admin_panel/karyawan_manage/karyawanmanage_main.dart';
import 'package:order_makan/pages/admin_panel/rangkum/bloc/rangkuman_bloc.dart';
import 'package:order_makan/pages/admin_panel/rangkum/rangkum_bulan/rangkum_bulan.dart';
import 'package:order_makan/pages/admin_panel/rangkum/rangkum_hari/rangkum_hari.dart';
import 'package:order_makan/pages/histori_struk.dart';
import 'package:order_makan/repo/strukrepo.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              children: [],
            ),
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InputBeliBahanbaku(),
                      ));
                },
                title: const Text('Pembelian Bahanbaku')),
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KaryawanManageMain(),
                      ));
                },
                title: const Text('Manage Karyawan')),
            Divider(),
            Text('Rangkuman'),
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoriStruk(),
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
                              RepositoryProvider.of<StrukRepository>(context)),
                          child: const RangkumHari(),
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
                              RepositoryProvider.of<StrukRepository>(context))
                            ..add(InitiateRangkuman()),
                          child: const RangkumBulan(),
                        ),
                      ));
                },
                title: const Text('Rangkuman Bulanan')),
            Divider(),
            ListTile(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        final FocusNode focusNode = FocusNode();
                        focusNode.requestFocus();
                        return Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SizedBox(
                              width: 100,
                              child: TextFormField(
                                // controller: tct,

                                validator: numberValidator,

                                // initialValue: state
                                //     .orderItems[widget.index].count
                                //     .toString(),

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
                                decoration:
                                    InputDecoration(label: Text('Uang Laci')),
                              ),
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
          ],
          // children: List.generate(
          //     a.length,
          //     (index) => ),
        ),
      ),
    );
  }
}
