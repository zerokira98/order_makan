// import 'dart:async';
// import 'dart:developer';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as i;
import 'package:month_year_picker/month_year_picker.dart';
import 'package:order_makan/bloc/antrian/antrian_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/model/strukitem_model.dart';
import 'package:order_makan/pages/antrian/print_widget.dart';
import 'package:order_makan/pages/historipenjualan/historipenjualan_harian.dart';
import 'package:order_makan/repo/globalsettingrepo.dart';
import 'package:order_makan/repo/karyawan_authrepo.dart';
import 'package:order_makan/repo/strukrepo.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../helper.dart' as x;

class HistoriStruk extends StatefulWidget {
  const HistoriStruk({super.key});

  @override
  State<HistoriStruk> createState() => _HistoriStrukState();
}

class _HistoriStrukState extends State<HistoriStruk> {
  late DateTime selected;
  late TextEditingController monthfilter;
  Future<List<UseStrukState>> thefuture(BuildContext context) =>
      RepositoryProvider.of<StrukRepository>(context)
          .readStrukwithFilter(StrukFilter(
        start: DateTime(selected.year, selected.month),
        end: DateTime(selected.year, selected.month + 1),
      ));
  @override
  void initState() {
    selected = DateTime.now();
    monthfilter = TextEditingController(text: selected.formatMonthYear());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('histori sturk'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: thefuture(context),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return const Text('null');
                    }
                    // StringBuffer aw = StringBuffer('');
                    // for (var data in snapshot.data!) {
                    //   aw.write(data.key);
                    //   aw.write(data.value);
                    // }
                    return GridView.count(
                      shrinkWrap: true,
                      childAspectRatio: 5,
                      crossAxisCount: 2,
                      children: snapshot.data!.map((e) {
                        List<StrukItem> ewe = e.orderItems;
                        return InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => DisplayStruk(
                                viewonly: true,
                                data: e,
                              ),
                            );
                          },
                          child: Card(
                              child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Id#${e.strukId}',
                                    textScaler: TextScaler.linear(1.2),
                                    textAlign: TextAlign.left,
                                  ),
                                  Expanded(child: Container()),
                                  Text(e.ordertime.toString())
                                ],
                              ),
                              Expanded(
                                  child: Row(
                                children: [
                                  Expanded(
                                    child: Wrap(
                                      alignment: WrapAlignment.start,
                                      children: [
                                        for (StrukItem ew in ewe)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                                '${ew.title} x${ew.count}'),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                              const Text('total: xxx')
                            ],
                          )),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Text('Filter'),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      showMonthYearPicker(
                                              context: context,
                                              initialDate: selected,
                                              firstDate: DateTime(2023),
                                              lastDate: DateTime.now())
                                          .then(
                                        (value) {
                                          if (value != null) {
                                            monthfilter.text =
                                                value.formatMonthYear();
                                            setState(() {
                                              selected = value;
                                            });
                                          }
                                        },
                                      );
                                    },
                                    child: TextField(
                                      // enabled: false,

                                      readOnly: true,
                                      decoration: InputDecoration(
                                          label: Text('Bulan'),
                                          disabledBorder:
                                              UnderlineInputBorder()),
                                      controller: monthfilter,
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsetsGeometry.all(8)),
                                ElevatedButton(
                                    onPressed: () {}, child: Text('Ok'))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DisplayStruk extends StatelessWidget {
  final UseStrukState data;
  final bool viewonly;
  const DisplayStruk({required this.data, super.key, this.viewonly = false});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    return BlocListener<AntrianBloc, AntrianState>(
      listenWhen: (previous, current) => previous.msg != current.msg,
      listener: (context, state) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HistoriPenjualanHarian(),
            ));
      },
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: width / 6),
        child: Dialog(
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Struk',
                          textAlign: TextAlign.center,
                          textScaler: TextScaler.linear(1.7),
                        )),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close))
                      ],
                    ),
                  ),
                  Text('Nomor Antrian : ${data.nomorAntrian}'),
                  // Text('Id : ${data.strukId}'),
                  FutureBuilder(
                    future: RepositoryProvider.of<KaryawanAuthRepo>(context)
                        .getAllKaryawan(data.karyawanId),
                    builder: (context, snapshot) {
                      if (!(snapshot.connectionState == ConnectionState.done)) {
                        return CircularProgressIndicator();
                      }
                      return snapshot.hasData
                          ? Text(snapshot.data?.singleOrNull?['name'] ?? '')
                          : Text('Id : ${data.karyawanId}');
                    },
                  ),
                  // Text(data.karyawanId),
                  Row(
                    children: [
                      Text(data.ordertime.formatLengkap()),
                      Text(data.ordertime.clockOnly()),
                    ],
                  ),
                  Padding(padding: EdgeInsetsGeometry.all(12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: StrukDataTable(
                          data: data,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0.0, right: 12),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Pembayaran : ${data.tipePembayaran.name.firstUpcase}',
                          textAlign: TextAlign.end,
                        )),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Total : ${data.orderItems.fold(
                                0,
                                (previousValue, element) =>
                                    previousValue +
                                    (element.count * element.price) +
                                    element.submenues.fold(
                                      0,
                                      (prevValue, ele) =>
                                          prevValue +
                                          (ele.adjustHarga * element.count),
                                    ),
                              ).numberFormatCurrency}',
                          textAlign: TextAlign.end,
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Dibayar : ${data.dibayar?.numberFormatCurrency}',
                          textAlign: TextAlign.end,
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Kembalian : ${((data.dibayar ?? 0) - data.orderItems.fold(
                                0,
                                (previousValue, element) =>
                                    previousValue +
                                    (element.count * element.price) +
                                    element.submenues.fold(
                                      0,
                                      (prevValue, ele) =>
                                          prevValue +
                                          (ele.adjustHarga * element.count),
                                    ),
                              )).numberFormatCurrency}',
                          textAlign: TextAlign.end,
                        )),
                      ],
                    ),
                  ),
                  // BlocBuilder<AntrianBloc, AntrianState>(
                  //   builder: (context, state) {
                  //     return Text(state.antrianStruks.toString());
                  //   },
                  // ),
                  // Expanded(child: Container()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white),
                          onPressed: () async {
                            if (await PrintBluetoothThermal.connectionStatus) {
                              try {
                                var ticket =
                                    await StrukPrint.printStruk(data, context);

                                await PrintBluetoothThermal.writeBytes(ticket);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('error: $e')));
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('no connection to printer')));
                            }
                          },
                          icon: Icon(Icons.print_rounded),
                          label: Text('Print')),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              backgroundColor: Colors.blue.shade600),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PrintWidgetSetting(),
                              )),
                          child: Icon(Icons.settings)),
                    ],
                  ),
                  Padding(padding: EdgeInsetsGeometry.all(2)),
                  if (viewonly == false)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MenuAnchor(
                          menuChildren: [
                            SubmenuButton(menuChildren: [
                              MenuItemButton(
                                child: Text('Salah Input'),
                                onPressed: () {
                                  BlocProvider.of<AntrianBloc>(context)
                                      .add(Delete(data, reason: 'Salah Input'));
                                  Navigator.pop(context);
                                },
                              ),
                              MenuItemButton(
                                child: Text('Lain-lain'),
                                onPressed: () {
                                  BlocProvider.of<AntrianBloc>(context)
                                      .add(Delete(data, reason: 'Lain-lain'));
                                  Navigator.pop(context);
                                },
                              ),
                            ], child: Text('Belum Dibuat')),
                            SubmenuButton(menuChildren: [
                              MenuItemButton(
                                child: Text('Salah Input'),
                                onPressed: () {},
                              ),
                              MenuItemButton(
                                child: Text('Batal beli,uang kembali'),
                                onPressed: () {},
                              ),
                              MenuItemButton(
                                child: Text('data3'),
                                onPressed: () {},
                              )
                            ], child: Text('Sudah/sedang Dibuat')),
                          ],
                          builder: (context, controller, child) =>
                              ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.red),
                                    foregroundColor:
                                        WidgetStatePropertyAll(Colors.white),
                                  ),
                                  // onPressed: () {
                                  //   if (controller.isOpen) {
                                  //     controller.close();
                                  //   } else {
                                  //     controller.open();
                                  //   }
                                  // },
                                  onPressed: () {
                                    BlocProvider.of<AntrianBloc>(context)
                                        .add(Delete(data, reason: ''));
                                    Navigator.pop(context);
                                  },
                                  child: Text('Batalkan Pesanan.')),
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.green),
                              foregroundColor:
                                  WidgetStatePropertyAll(Colors.white),
                            ),
                            onPressed: () {
                              BlocProvider.of<AntrianBloc>(context)
                                  .add(OrderFinish(data.strukId!));

                              //change to pop on listener
                            },
                            child: Text('Selesaikan Pesanan.')),
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StrukPrint {
  static Future<List<int>> printStruk(
      UseStrukState data, BuildContext context) async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final ByteData imgdata = await rootBundle.load('assets/qr/qr.jpeg');
    var passwifi =
        await RepositoryProvider.of<GlobalSettingRepo>(context).getWifiPass();
    final Uint8List bytesImg = imgdata.buffer.asUint8List();
    final image = i.decodeImage(bytesImg);
    final generator = Generator(PaperSize.mm58, profile);
    var datakaryawan = await RepositoryProvider.of<KaryawanAuthRepo>(context)
        .getAllKaryawan(data.karyawanId);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    bytes += generator.text('Koffie Coffeeshop',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            height: PosTextSize.size2));
    bytes += generator.text('Jl. Brawijaya 140',
        styles: const PosStyles(
          align: PosAlign.center,
        ));
    bytes += generator.text('Kampung Inggris',
        styles: const PosStyles(
          align: PosAlign.center,
        ));

    bytes += generator.emptyLines(1);
    bytes += generator.text('No. antrian:',
        styles: const PosStyles(
          align: PosAlign.center,
        ));
    bytes += generator.text('${data.nomorAntrian}',
        styles: const PosStyles(
          width: PosTextSize.size2,
          height: PosTextSize.size2,
          align: PosAlign.center,
          fontType: PosFontType.fontB,
        ));

    bytes += generator.emptyLines(1);
    // bytes += generator.text('Id: ${data.strukId}',
    //     styles: const PosStyles(
    //       align: PosAlign.left,
    //       fontType: PosFontType.fontB,
    //     ));
    bytes +=
        generator.text('Karyawan: ${datakaryawan.singleOrNull?['name'] ?? ''}',
            styles: const PosStyles(
              align: PosAlign.left,
              fontType: PosFontType.fontB,
            ));
    bytes += generator.row([
      PosColumn(
        text: data.ordertime.formatLengkap(),
        width: 9,
        styles:
            const PosStyles(align: PosAlign.left, fontType: PosFontType.fontB),
      ),
      PosColumn(
        text: data.ordertime.clockOnly(),
        width: 3,
        styles:
            const PosStyles(align: PosAlign.right, fontType: PosFontType.fontB),
      ),
    ]);
    bytes += generator.emptyLines(1);
    for (var i = 0; i < data.orderItems.length; i++) {
      bytes += generator.row([
        PosColumn(
          text: data.orderItems[i].title,
          width: 6,
          styles: const PosStyles(
              align: PosAlign.left, fontType: PosFontType.fontB),
        ),
        PosColumn(
          text: data.orderItems[i].count.toString(),
          width: 2,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: (data.orderItems[i].price * data.orderItems[i].count)
              .numberFormat(),
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      for (var e in data.orderItems[i].submenues) {
        bytes += generator.row([
          PosColumn(
            text: '-${e.title}',
            width: 6,
            styles: const PosStyles(
              align: PosAlign.left,
              fontType: PosFontType.fontB,
            ),
          ),
          PosColumn(
            text: '',
            width: 3,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: (e.adjustHarga * data.orderItems[i].count).numberFormat(),
            width: 3,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }
    }
    bytes += generator.text(
        'Pembayaran : ${data.tipePembayaran.name.firstUpcase}',
        styles: const PosStyles(
            align: PosAlign.right,
            fontType: PosFontType.fontA,
            width: PosTextSize.size1,
            height: PosTextSize.size1));
    bytes += generator.emptyLines(1);
    bytes += generator.text(
        'Total : ${data.orderItems.fold(
              0,
              (previousValue, element) =>
                  previousValue +
                  (element.count * element.price) +
                  element.submenues.fold(
                      0,
                      (prevValue, ele) =>
                          prevValue + (ele.adjustHarga * element.count)),
            ).numberFormat()}',
        styles: const PosStyles(
            align: PosAlign.right,
            fontType: PosFontType.fontA,
            width: PosTextSize.size1,
            height: PosTextSize.size1));
    bytes += generator.text('Bayar : ${data.dibayar?.numberFormat()}',
        styles: const PosStyles(
            align: PosAlign.right,
            fontType: PosFontType.fontA,
            width: PosTextSize.size1,
            height: PosTextSize.size1));
    bytes += generator.text(
        'Kembali : ${((data.dibayar ?? 0) - data.orderItems.fold(0, (previousValue, element) => previousValue + (element.count * element.price) + element.submenues.fold(
              0,
              (prevValue, ele) => prevValue + (ele.adjustHarga * element.count),
            ))).numberFormat()}',
        styles: const PosStyles(
            align: PosAlign.right,
            fontType: PosFontType.fontA,
            width: PosTextSize.size1,
            height: PosTextSize.size1));
    bytes += generator.emptyLines(2);
    bytes += generator.text('Terimakasi',
        styles: const PosStyles(
          align: PosAlign.center,
        ));
    bytes += generator.text(passwifi.isEmpty ? '' : 'pass : $passwifi',
        styles: const PosStyles(
          align: PosAlign.center,
        ));

    bytes += image != null
        ? generator.image(image)
        : generator.qrcode('https://www.instagram.com/koffiepare/');

    // bytes += generator.qrcode('https://www.instagram.com/koffiepare/');
    // bytes += generator.qrcode('https://www.tiktok.com/@koffie.pare');
    // bytes += generator.row([
    //   PosColumn(
    //     text: '-${e.title}',
    //     width: 6,
    //     styles: const PosStyles(
    //       align: PosAlign.left,
    //       fontType: PosFontType.fontB,
    //     ),
    //   ),
    // ]);
    bytes += generator.emptyLines(3);
    return bytes;
  }
}

class StrukDataTable extends StatefulWidget {
  final UseStrukState data;
  const StrukDataTable({super.key, required this.data});

  @override
  State<StrukDataTable> createState() => _StrukDataTableState();
}

class _StrukDataTableState extends State<StrukDataTable> {
  late UseStrukState statedData;
  bool sort = true;
  @override
  void initState() {
    super.initState();
    statedData = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      sortAscending: sort,
      horizontalMargin: 12.0,
      columnSpacing: 18.0,
      dataRowMaxHeight: double.infinity,
      sortColumnIndex: 0,
      columns: <DataColumn>[
        DataColumn(
          columnWidth: FlexColumnWidth(2),
          onSort: (columnIndex, ascending) {
            setState(() {
              sort = !sort;
              statedData = statedData.copywith(
                  orderItems: statedData.orderItems
                    ..sort(
                      (ascending)
                          ? (a, b) => a.title.compareTo(b.title)
                          : (a, b) => b.title.compareTo(a.title),
                    ));
            });
          },
          label: Expanded(
              child:
                  Text('Nama', style: TextStyle(fontStyle: FontStyle.italic))),
        ),
        DataColumn(
          label: Expanded(
              child:
                  Text('Pcs', style: TextStyle(fontStyle: FontStyle.italic))),
        ),
        DataColumn(
          label: Expanded(
              child: Text('Satuan',
                  style: TextStyle(fontStyle: FontStyle.italic))),
        ),
        DataColumn(
          headingRowAlignment: MainAxisAlignment.end,
          numeric: true,
          label: Expanded(
              child:
                  Text('Total', style: TextStyle(fontStyle: FontStyle.italic))),
        ),
      ],
      rows: <DataRow>[
        for (var i = 0; i < statedData.orderItems.length; i++)
          DataRow(
            cells: <DataCell>[
              DataCell(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                      Text(statedData.orderItems[i].title),
                      // if (statedData.orderItems[i].catatan != null)
                      //   Text(
                      //     statedData.orderItems[i].catatan ?? "",
                      //     style: TextStyle(fontSize: 8),
                      //   ),
                    ] +
                    List.generate(
                      statedData.orderItems[i].submenues.length,
                      (index) => Text(
                        statedData.orderItems[i].submenues[index].title,
                        textScaler: TextScaler.linear(0.8),
                      ),
                    ),
              )),
              DataCell(Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Text(statedData.orderItems[i].count.toString()),
                ],
              )),
              DataCell(Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                      Text(
                        statedData.orderItems[i].price
                            .numberFormat(currency: true),
                        textAlign: TextAlign.end,
                      ),
                    ] +
                    List.generate(
                      statedData.orderItems[i].submenues.length,
                      (index) => Text(
                        statedData.orderItems[i].submenues[index].adjustHarga
                            .numberFormat(),
                        textAlign: TextAlign.end,
                      ),
                    ),
              )),
              DataCell(Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                      Builder(builder: (context) {
                        var itemtotal = (statedData.orderItems[i].count *
                            statedData.orderItems[i].price);
                        for (var e in statedData.orderItems[i].submenues) {
                          itemtotal +=
                              e.adjustHarga * statedData.orderItems[i].count;
                        }
                        return Text(
                          itemtotal.numberFormat(currency: true),
                          textAlign: TextAlign.end,
                        );
                      }),
                    ] +
                    List<Widget>.generate(
                      statedData.orderItems[i].submenues.length,
                      (index) {
                        // if (index ==
                        //     statedData.orderItems[i].submenues.length) {
                        //   return Text('total');
                        // }
                        return Text('');
                        //   return Text(
                        //   statedData.orderItems[i].submenues[index].adjustHarga
                        //       .numberFormat(),
                        //   textAlign: TextAlign.end,
                        // );
                      },
                    ),
              )),
              // DataCell(Text('19')),
              // DataCell(Text('Student')),
            ],
          ),
        // DataRow(
        //   cells: <DataCell>[
        //     DataCell(Text('Janine')),
        //     DataCell(Text('43')),
        //     DataCell(Text('Professor')),
        //   ],
        // ),
        // DataRow(
        //   cells: <DataCell>[
        //     DataCell(Text('William')),
        //     DataCell(Text('27')),
        //     DataCell(Text('Associate Professor')),
        //   ],
        // ),
      ],
    );
  }
}
