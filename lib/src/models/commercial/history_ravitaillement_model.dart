import 'package:sembast/sembast.dart';
import 'package:sembast/timestamp.dart';

class HistoryRavitaillementModel {
  late int? id;
  late String idProduct;
  late String quantity;
  late String quantityAchat;
  late String priceAchatUnit;
  late String prixVenteUnit;
  late String unite;
  late String margeBen;
  late String tva;
  late String qtyRavitailler;
  late String succursale;
  late String signature; // celui qui fait le document
  late Timestamp created;

  HistoryRavitaillementModel(
      {this.id,
      required this.idProduct,
      required this.quantity,
      required this.quantityAchat,
      required this.priceAchatUnit,
      required this.prixVenteUnit,
      required this.unite,
      required this.margeBen,
      required this.tva,
      required this.qtyRavitailler,
      required this.succursale,
      required this.signature,
      required this.created});

  factory HistoryRavitaillementModel.fromSQL(List<dynamic> row) {
    return HistoryRavitaillementModel(
        id: row[0],
        idProduct: row[1],
        quantity: row[2],
        quantityAchat: row[3],
        priceAchatUnit: row[4],
        prixVenteUnit: row[5],
        unite: row[6],
        margeBen: row[7],
        tva: row[8],
        qtyRavitailler: row[9],
        succursale: row[10],
        signature: row[11],
        created: row[12]);
  }

  factory HistoryRavitaillementModel.fromJson(Map<String, dynamic> json) {
    return HistoryRavitaillementModel(
        id: json['id'],
        idProduct: json['idProduct'],
        quantity: json['quantity'],
        quantityAchat: json['quantityAchat'],
        priceAchatUnit: json['priceAchatUnit'],
        prixVenteUnit: json['prixVenteUnit'],
        unite: json['unite'],
        margeBen: json['margeBen'],
        tva: json["tva"],
        qtyRavitailler: json["qtyRavitailler"],
        signature: json['signature'],
        succursale: json['succursale'],
        created: Timestamp.parse(json['created']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idProduct': idProduct,
      'quantity': quantity,
      'quantityAchat': quantityAchat,
      'priceAchatUnit': priceAchatUnit,
      'prixVenteUnit': prixVenteUnit,
      'unite': unite,
      'margeBen': margeBen,
      "tva": tva,
      "qtyRavitailler": qtyRavitailler,
      'succursale': succursale,
      'signature': signature,
      'created': created.toIso8601String()
    };
  }

  HistoryRavitaillementModel.fromDatabase(
      RecordSnapshot<int, Map<String, dynamic>> snapshot)
      : idProduct = snapshot.value['idProduct'] as String,
        quantity = snapshot.value['quantity'] as String,
        quantityAchat = snapshot.value['quantityAchat'] as String,
        priceAchatUnit = snapshot.value['priceAchatUnit'] as String,
        prixVenteUnit = snapshot.value['prixVenteUnit'] as String,
        unite = snapshot.value['unite'] as String,
        margeBen = snapshot.value['margeBen'] as String,
        tva = snapshot.value['tva'] as String,
        qtyRavitailler = snapshot.value['qtyRavitailler'] as String,
        succursale = snapshot.value['succursale'] as String,
        signature = snapshot.value['signature'] as String,
        created = Timestamp.parse(snapshot.value['created']),
        id = snapshot.key;
}
