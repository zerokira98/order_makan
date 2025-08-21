import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:open_filex/open_filex.dart';
import 'package:order_makan/pages/admin_panel/rangkum/bloc/rangkuman_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelProcessor {
  Future<void> printExcel(RangkumanState state) async {
    final Workbook workbook = Workbook();
//Accessing worksheet via index.
    final sheet = workbook.worksheets[0];
    for (var i = 0; i < state.struks.length; i++) {
      sheet.getRangeByIndex(i + 1, 1).setDateTime(state.struks[i].ordertime);
      sheet
          .getRangeByIndex(i + 1, 2)
          .setText(state.struks[i].tipePembayaran.name);
      sheet
          .getRangeByIndex(i + 1, 3)
          .setNumber(state.struks[i].total?.toDouble());
    }

//Add Text.
//     sheet.getRangeByIndex(0, 0).setText('Hello World');
// //Add Number
//     sheet.getRangeByName('A3').setNumber(44);
// //Add DateTime
//     sheet.getRangeByName('A5').setDateTime(DateTime(2020, 12, 12, 1, 10, 20));
    // Save the document.
    List<int> bytes = workbook.saveAsStream();
    // var file = File('AddingTextNumberDateTime.xlsx').writeAsBytes(bytes);
//Dispose the workbook.
    Directory docDir = await getApplicationDocumentsDirectory();
    File theFile =
        await File('${docDir.path}/Backup_${DateTime.now().day}.xlsx')
            .create(recursive: true);
    await theFile.writeAsBytes(bytes);
    print(await theFile.readAsBytes());
    final params = SaveFileDialogParams(sourceFilePath: theFile.path);
    final filePath = await FlutterFileDialog.saveFile(params: params);
    if (filePath != null) {
      var x = await OpenFilex.open(theFile.path);
      debugPrint(x.message);
    }
    workbook.dispose();
    print('here');
  }
}
