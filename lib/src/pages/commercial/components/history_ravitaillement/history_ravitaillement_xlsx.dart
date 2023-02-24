import 'dart:io';

import 'package:excel/excel.dart';
import 'package:wm_commercial/src/models/commercial/history_ravitaillement_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class HistoriqueRavitaillementXlsx {
  Future<void> exportToExcel(List<HistoryRavitaillementModel> dataList) async {
    var excel = Excel.createExcel();
    String title = "HistoriqueRavitaillements";
    Sheet sheetObject = excel[title];
    sheetObject.insertRowIterables([
      "Id Product",
      "Quantité",
      "QuantityAchat",
      "Prix Achat Unitaire",
      "Prix Vente Unitaire",
      "Unité",
      "Marge Benefiaire",
      "TVA",
      "Qty Ravitailler",
      "Succursale",
      "Signature",
      "Date"
    ], 0);

    for (int i = 0; i < dataList.length; i++) {
      List<String> data = [
        dataList[i].idProduct,
        dataList[i].quantity,
        dataList[i].quantityAchat,
        dataList[i].priceAchatUnit,
        dataList[i].prixVenteUnit,
        dataList[i].unite,
        dataList[i].margeBen,
        dataList[i].tva,
        dataList[i].qtyRavitailler,
        dataList[i].succursale,
        dataList[i].signature,
        DateFormat("dd/MM/yy HH-mm").format(dataList[i].created.toDateTime()),
      ];

      sheetObject.insertRowIterables(data, i + 1);
    }
    excel.setDefaultSheet(title);
    final dir = await getApplicationDocumentsDirectory();
    final dateTime = DateTime.now();
    final date = DateFormat("dd-MM-yy_HH-mm").format(dateTime);

    var onValue = excel.encode();
    File('${dir.path}/$title$date.xlsx')
      ..createSync(recursive: true)
      ..writeAsBytesSync(onValue!);
  }
}
