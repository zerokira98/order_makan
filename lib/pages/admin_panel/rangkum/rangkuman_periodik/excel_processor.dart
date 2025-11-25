import 'package:flutter/foundation.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:order_makan/model/inputstock_model.dart';
import 'package:order_makan/pages/admin_panel/rangkum/bloc/rangkuman_bloc.dart';
import 'package:order_makan/repo/karyawan_authrepo.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelProcessor {
  static Future<void> printExcel(
      RangkumanState state, BuildContext context) async {
    final Workbook workbook = Workbook();
//Accessing worksheet via index.
    final sheet = workbook.worksheets[0];
    var karyawans =
        await RepositoryProvider.of<KaryawanAuthRepo>(context).getAllKaryawan();
    sheet.name = 'Penjualan';
    debugPrint(karyawans.toString());
    for (var i = 0; i < state.struks.length; i++) {
      var simpled = state.struks[i].ordertime.day;

      sheet.getRangeByIndex(i + 1, 1)
        ..setDateTime(state.struks[i].ordertime)
        ..numberFormat = 'NNN, D MMMM YYYY';
      sheet.getRangeByIndex(i + 1, 2).setText(
          state.struks[i].orderItems.map((e) => e.title).toList().toString());
      sheet
          .getRangeByIndex(i + 1, 3)
          .setText(state.struks[i].tipePembayaran.name);
      sheet.getRangeByIndex(i + 1, 4).setText(karyawans.singleWhere(
            (element) => element?['id'] == state.struks[i].karyawanId,
            orElse: () => {'name': state.struks[i].karyawanId},
          )?['name']);
      sheet.getRangeByIndex(i + 1, 5)
        ..setNumber(state.struks[i].total?.toDouble())
        ..numberFormat = '#,##0';
    }
    sheet.getRangeByIndex(1, 8).setText('Total : ');
    sheet.getRangeByIndex(1, 9)
      ..setNumber(state.struks
          .fold(
            0,
            (previousValue, element) => previousValue + (element.total ?? 0),
          )
          .toDouble())
      ..numberFormat = '#,##0';
    sheet.autoFitColumn(1);
    sheet.autoFitColumn(2);
    sheet.autoFitColumn(3);

    ///Pengeluaran sheet
    final sheet2 = workbook.worksheets.add();
    sheet2.name = 'Pengeluaran';
    List<InputstockModel> listpengeluaranbahan =
        state.pengeluaranInputBahan as List<InputstockModel>;
    for (var i = 0; i < listpengeluaranbahan.length; i++) {
      sheet2
          .getRangeByIndex(i + 1, 1)
          .setDateTime(listpengeluaranbahan[i].tanggalbeli.toDate());
      sheet2.getRangeByIndex(i + 1, 2).setText(listpengeluaranbahan[i].title);
      sheet2
          .getRangeByIndex(i + 1, 3)
          .setNumber(listpengeluaranbahan[i].count.toDouble());
      sheet2
          .getRangeByIndex(i + 1, 4)
          .setNumber(listpengeluaranbahan[i].price.toDouble());
    }

//Add Text.
//     sheet.getRangeByIndex(0, 0).setText('Hello World');
// //Add Number
//     sheet.getRangeByName('A3').setNumber(44);
// //Add DateTime
//     sheet.getRangeByName('A5').setDateTime(DateTime(2020, 12, 12, 1, 10, 20));
    // Save the document.
    // var file = File('AddingTextNumberDateTime.xlsx').writeAsBytes(bytes);
//Dispose the workbook.
    if (kIsWeb) {
      // final params = SaveFileDialogParams(sourceFilePath: theFile.path);
      // final filePath = await FlutterFileDialog.saveFile(params: params);
      FileSaver.instance.saveFile(
          name: '/Backup_${DateFormat.MMMM().format(DateTime.now())}.xlsx',
          bytes: Uint8List.fromList(workbook.saveAsStream()));
      workbook.dispose();
      return;
    }
    debugPrint('here');
    List<int> bytes = workbook.saveAsStream();
    // Directory docDir = await getApplicationDocumentsDirectory();
    // File theFile =
    //     await File('${docDir.path}/Backup_${DateTime.now().day}.xlsx')
    //         .create(recursive: true);
    // await theFile.writeAsBytes(bytes);
    var filePath = await FileSaver.instance.saveAs(
        fileExtension: 'xlsx',
        mimeType: MimeType.microsoftExcel,
        name: 'Backup_${DateFormat.MMMM().format(DateTime.now())}',
        bytes: Uint8List.fromList(bytes));
    debugPrint(filePath);
    // print(await theFile.readAsBytes());
    // final params = SaveFileDialogParams(sourceFilePath: theFile.path);
    // final filePath = await FlutterFileDialog.saveFile(params: params);
    if (filePath != null) {
      var x = await OpenFilex.open(filePath);
      debugPrint(x.message);
    }
    workbook.dispose();
  }
}
