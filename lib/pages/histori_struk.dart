import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:order_makan/bloc/antrian/antrian_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/model/strukitem_model.dart';
import 'package:order_makan/repo/karyawan_authrepo.dart';
import 'package:order_makan/repo/strukrepo.dart';

import '../helper.dart' as x;

class HistoriStruk extends StatelessWidget {
  const HistoriStruk({super.key});

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
                                            child: Text(ew.title +
                                                ' x' +
                                                ew.count.toString()),
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
                  future: RepositoryProvider.of<StrukRepository>(context)
                      .readAllStruk(descending: true),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    var after =
                        await RepositoryProvider.of<StrukRepository>(context)
                            .readAllStruk();
                  },
                  child: const Text('press me!')),
            ],
          ),
        ),
      ),
    );
  }
}

class DisplayStruk extends StatelessWidget {
  final UseStrukState data;
  const DisplayStruk({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(8.0),
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
                      textScaler: TextScaler.linear(1.5),
                    )),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close))
                  ],
                ),
              ),
              Text('Id : ${data.strukId}'),
              FutureBuilder(
                future: RepositoryProvider.of<KaryawanAuthRepo>(context)
                    .getAllKaryawan(data.karyawanId),
                builder: (context, snapshot) {
                  if (!(snapshot.connectionState == ConnectionState.done)) {
                    return CircularProgressIndicator();
                  }
                  return snapshot.hasData
                      ? Text(snapshot.data['name'])
                      : Text('Id : ' + data.karyawanId);
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
                  StrukDataTable(
                    data: data,
                  ),
                ],
              ),
              // for (var i = 0; i < data.orderItems.length; i++)
              //   Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 12.0),
              //     child: Row(
              //       mainAxisSize: MainAxisSize.max,
              //       mainAxisAlignment: MainAxisAlignment.spaceAround,
              //       spacing: 2,
              //       children: [
              //         Expanded(flex: 4, child: Text(data.orderItems[i].title)),
              //         Expanded(
              //             flex: 2,
              //             child: Text(
              //               data.orderItems[i].price.numberFormatCurrency,
              //               textAlign: TextAlign.end,
              //             )),
              //         Expanded(
              //             flex: 1,
              //             child: Text(
              //               '${data.orderItems[i].count}',
              //               textAlign: TextAlign.end,
              //             )),
              //         Expanded(
              //             flex: 2,
              //             child: Text(
              //               (data.orderItems[i].count *
              //                       data.orderItems[i].price)
              //                   .numberFormatCurrency,
              //               textAlign: TextAlign.end,
              //             )),
              //       ],
              //     ),
              //   ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      'Nomor meja : ${data.nomorMeja == 0 ? 'Tanpa Meja' : data.nomorMeja}',
                      textAlign: TextAlign.end,
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      'Pembayaran : ${data.tipePembayaran}',
                      textAlign: TextAlign.end,
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      'Total : ${data.orderItems.fold(
                            0,
                            (previousValue, element) =>
                                previousValue + (element.count * element.price),
                          ).numberFormatCurrency}',
                      textAlign: TextAlign.end,
                    )),
                  ],
                ),
              ), // BlocBuilder<AntrianBloc, AntrianState>(
              //   builder: (context, state) {
              //     return Text(state.antrianStruks.toString());
              //   },
              // ),
              // Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MenuAnchor(
                    menuChildren: [
                      SubmenuButton(menuChildren: [
                        MenuItemButton(
                          child: Text('Salah Input'),
                          onPressed: () {},
                        ),
                        MenuItemButton(
                          child: Text('Lain-lain'),
                          onPressed: () {},
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
                    builder: (context, controller, child) => ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.red),
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                        ),
                        onPressed: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                        onLongPress: () {
                          BlocProvider.of<AntrianBloc>(context)
                              .add(Delete(data));
                          Navigator.pop(context);
                        },
                        child: Text('Batalkan Pesanan.')),
                  ),
                  // GestureDetector(
                  //   onLongPressStart: (details) => print(details),
                  //   child:
                  // ),
                  PrintWidget(
                    theData: data,
                  ),
                  // ElevatedButton.icon(
                  //   style: ButtonStyle(
                  //     backgroundColor: WidgetStatePropertyAll(Colors.blue),
                  //     foregroundColor: WidgetStatePropertyAll(Colors.white),
                  //   ),
                  //   onPressed: () {},
                  //   label: Text('Print'),
                  //   icon: Icon(Icons.print_outlined),
                  // ),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.green),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                      ),
                      onPressed: () {
                        BlocProvider.of<AntrianBloc>(context)
                            .add(OrderFinish(data.strukId!));

                        Navigator.pop(context);
                        //change to pop on listener
                      },
                      child: Text('Selesaikan Pesanan.')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PrintWidget extends StatefulWidget {
  final UseStrukState theData;
  const PrintWidget({super.key, required this.theData});

  @override
  State<PrintWidget> createState() => _PrintWidgetState();
}

class _PrintWidgetState extends State<PrintWidget> {
  FlutterThermalPrinter printerPlugin = FlutterThermalPrinter.instance;
  List<Printer> _devices = [];

  // List<DropdownMenuItem<BluetoothDevice>> getDeviceItems() {
  //   List<DropdownMenuItem<BluetoothDevice>> items = [];
  //   if (_devices.isEmpty) {
  //     items.add(const DropdownMenuItem(
  //       value: null,
  //       child: Text('NONE'),
  //     ));
  //   } else {
  //     for (var device in _devices) {
  //       items.add(DropdownMenuItem(
  //         value: device,
  //         child: Text(device.name ?? ""),
  //       ));
  //     }
  //   }
  //   return items;
  // }

  StreamSubscription<List<Printer>>? _devicesStreamSubscription;
  Printer? connectedDevice;
  // Get Printer List
  void startScan() async {
    _devicesStreamSubscription?.cancel();
    await printerPlugin.getPrinters(connectionTypes: [
      ConnectionType.USB,
      ConnectionType.BLE,
    ]);
    _devicesStreamSubscription =
        printerPlugin.devicesStream.listen((List<Printer> event) {
      if (mounted) {
        log(event.map((e) => e.name).toList().toString());
        if (event.isNotEmpty) {
          setState(() {
            _devices = event;
            _devices.removeWhere(
                (element) => element.name == null || element.name == '');
          });
        }
      }
    });
  }

  @override
  void dispose() {
    stopScan();
    _devicesStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startScan();
    });
  }

  stopScan() {
    printerPlugin.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    // if (kIsWeb) {
    //   return Text('Unsupported p[latform]');
    // }
    return SizedBox(
      // width: 240,
      // height: 240,
      child: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // startScan();
                  startScan();
                },
                child: const Text('Scan'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (connectedDevice != null) {
                    await printerPlugin.printWidget(context,
                        printer: connectedDevice!,
                        printOnBle: true,
                        widget: receiptWidget(
                          connectedDevice!.connectionTypeString,
                        ));
                  }
                  // startScan();
                  // stopScan();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                      (connectedDevice?.isConnected ?? false)
                          ? Colors.green
                          : Colors.red),
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                ),
                child: const Text('Print'),
              ),
            ],
          ),
          Row(
            children: [
              DropdownButton(
                value: connectedDevice,
                onChanged: (value) {
                  setState(() {
                    connectedDevice = value;
                  });
                  print(value);
                },
                items: [
                  for (var index = 0; index < _devices.length; index++)
                    DropdownMenuItem(
                        value: _devices[index],
                        onTap: () async {
                          if (_devices[index].isConnected ?? false) {
                            await printerPlugin.disconnect(_devices[index]);
                          } else {
                            await printerPlugin.connect(_devices[index]).then(
                                  (value) => setState(() {}),
                                );
                          }
                        },
                        child: Text(_devices[index].name ?? 'No Name'))
                ],
              ),

              // ListTile(
              //   onTap: () async {
              //     if (_devices[index].isConnected ?? false) {
              //       await printerPlugin.disconnect(_devices[index]);
              //     } else {
              //       await printerPlugin.connect(_devices[index]);
              //     }
              //   },
              //   title: Text(_devices[index].name ?? 'No Name'),
              //   subtitle: Text("Connected: ${_devices[index].isConnected}"),
              //   trailing: IconButton(
              //     icon: const Icon(Icons.connect_without_contact),
              //     onPressed: () async {
              //       await printerPlugin.printWidget(
              //         context,
              //         printer: _devices[index],
              //         printOnBle: true,
              //         widget: receiptWidget(
              //           _devices[index].connectionTypeString,
              //         ),
              //       );
              //     },
              //   ),
              // )
            ],
          ),
        ],
      ),
    );

    // ElevatedButton(
    //     style: ElevatedButton.styleFrom(
    //         backgroundColor: Colors.green.shade800),
    //     onPressed: () {
    //       printThermal(widget.theData);
    //       // generatePDF(false, theData);
    //     },
    //     child: const Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: [
    //         Icon(
    //           Icons.print,
    //           color: Colors.white,
    //         ),
    //         Text(
    //           'Print Bluetooth',
    //           style: TextStyle(color: Colors.white),
    //         ),
    //       ],
    //     )),
  }

  Future<List<int>> _generateReceipt() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];
    bytes += generator.text(
      "Teste Network print",
      styles: const PosStyles(
        bold: true,
        height: PosTextSize.size3,
        width: PosTextSize.size3,
      ),
    );
    bytes += generator.cut();
    return bytes;
  }

  Widget receiptWidget(String printerType) {
    return SizedBox(
      width: 550,
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'FLUTTER THERMAL PRINTER',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(thickness: 2),
              const SizedBox(height: 10),
              _buildReceiptRow('Item', 'Price'),
              const Divider(),
              _buildReceiptRow('Apple', '\$1.00'),
              _buildReceiptRow('Banana', '\$0.50'),
              _buildReceiptRow('Orange', '\$0.75'),
              const Divider(thickness: 2),
              _buildReceiptRow('Total', '\$2.25', isBold: true),
              const SizedBox(height: 20),
              _buildReceiptRow('Printer Type', printerType),
              const SizedBox(height: 50),
              const Center(
                child: Text(
                  'Thank you for your purchase!',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String leftText, String rightText,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            rightText,
            style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
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
      sortColumnIndex: 0,
      columns: <DataColumn>[
        DataColumn(
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
              DataCell(Text(statedData.orderItems[i].title)),
              DataCell(Text(statedData.orderItems[i].count.toString())),
              DataCell(Text(
                  statedData.orderItems[i].price.numberFormat(currency: true))),
              DataCell(Text(
                (statedData.orderItems[i].count *
                        statedData.orderItems[i].price)
                    .numberFormat(currency: true),
                textAlign: TextAlign.end,
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
