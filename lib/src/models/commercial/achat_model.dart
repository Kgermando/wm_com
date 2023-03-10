import 'package:sembast/sembast.dart'; 
import 'package:sembast/timestamp.dart';

class AchatModel {
  late int? id;
  late String idProduct;
  late String quantity;
  late String quantityAchat;
  late String priceAchatUnit;
  late String prixVenteUnit;
  late String unite;
  late String tva;
  late String remise;
  late String qtyRemise;
  late String qtyLivre; // Remplace qtyRavitailler
  late String succursale;
  late String signature;
  late Timestamp created;

  AchatModel(
      {this.id,
      required this.idProduct,
      required this.quantity,
      required this.quantityAchat,
      required this.priceAchatUnit,
      required this.prixVenteUnit,
      required this.unite,
      required this.tva,
      required this.remise,
      required this.qtyRemise,
      required this.qtyLivre,
      required this.succursale,
      required this.signature,
      required this.created});

  factory AchatModel.fromSQL(List<dynamic> row) {
    return AchatModel(
        id: row[0],
        idProduct: row[1],
        quantity: row[2],
        quantityAchat: row[3],
        priceAchatUnit: row[4],
        prixVenteUnit: row[5],
        unite: row[6],
        tva: row[7],
        remise: row[8],
        qtyRemise: row[9],
        qtyLivre: row[10],
        succursale: row[11],
        signature: row[12],
        created: row[13]);
  }

  factory AchatModel.fromJson(Map<String, dynamic> json) {
    return AchatModel(
        id: json['id'],
        idProduct: json['idProduct'],
        quantity: json['quantity'],
        quantityAchat: json['quantityAchat'],
        priceAchatUnit: json['priceAchatUnit'],
        prixVenteUnit: json['prixVenteUnit'],
        unite: json['unite'],
        tva: json["tva"],
        remise: json["remise"],
        qtyRemise: json["qtyRemise"],
        qtyLivre: json["qtyLivre"],
        succursale: json['succursale'],
        signature: json['signature'],
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
      "tva": tva,
      "remise": remise,
      "qtyRemise": qtyRemise,
      "qtyLivre": qtyLivre,
      'succursale': succursale,
      'signature': signature,
      'created': created.toIso8601String()
    };
  }

  AchatModel.fromDatabase(RecordSnapshot<int, Map<String, dynamic>> snapshot)
      : idProduct = snapshot.value['idProduct'] as String,
        quantity = snapshot.value['quantity'] as String,
        quantityAchat = snapshot.value['quantityAchat'] as String,
        priceAchatUnit = snapshot.value['priceAchatUnit'] as String,
        prixVenteUnit = snapshot.value['prixVenteUnit'] as String,
        unite = snapshot.value['unite'] as String,
        tva = snapshot.value['tva'] as String,
        remise = snapshot.value['remise'] as String,
        qtyRemise = snapshot.value['qtyRemise'] as String,
        qtyLivre = snapshot.value['qtyLivre'] as String,
        succursale = snapshot.value['succursale'] as String,
        signature = snapshot.value['signature'] as String,
        created = Timestamp.parse(snapshot.value['created']),
        id = snapshot.key;
}
