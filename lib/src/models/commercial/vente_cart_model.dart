import 'package:sembast/sembast.dart';
import 'package:sembast/timestamp.dart';

class VenteCartModel {
  late int? id;
  late String idProductCart;
  late String quantityCart;
  late String priceTotalCart;
  late String unite;
  late String tva;
  late String remise;
  late String qtyRemise;
  late String succursale;
  late String signature; // celui qui fait le document
  late Timestamp created;
  late DateTime createdAt;

  VenteCartModel(
      {this.id,
      required this.idProductCart,
      required this.quantityCart,
      required this.priceTotalCart,
      required this.unite,
      required this.tva,
      required this.remise,
      required this.qtyRemise,
      required this.succursale,
      required this.signature,
      required this.created,
      required this.createdAt});

  factory VenteCartModel.fromSQL(List<dynamic> row) {
    return VenteCartModel(
        id: row[0],
        idProductCart: row[1],
        quantityCart: row[2],
        priceTotalCart: row[3],
        unite: row[4],
        tva: row[5],
        remise: row[6],
        qtyRemise: row[7],
        succursale: row[8],
        signature: row[9],
        created: row[10],
        createdAt: row[11]);
  }

  factory VenteCartModel.fromJson(Map<String, dynamic> json) {
    return VenteCartModel(
        id: json['id'],
        idProductCart: json['idProductCart'],
        quantityCart: json['quantityCart'],
        priceTotalCart: json['priceTotalCart'],
        unite: json['unite'],
        tva: json["tva"],
        remise: json["remise"],
        qtyRemise: json["qtyRemise"],
        succursale: json['succursale'],
        signature: json['signature'],
        created: Timestamp.parse(json['created']),
        createdAt: DateTime.parse(json['createdAt']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idProductCart': idProductCart,
      'quantityCart': quantityCart,
      'priceTotalCart': priceTotalCart,
      'unite': unite,
      "tva": tva,
      "remise": remise,
      "qtyRemise": qtyRemise,
      'succursale': succursale,
      'signature': signature,
      'created': created.toIso8601String(),
      'createdAt': createdAt.toIso8601String()
    };
  }

  VenteCartModel.fromDatabase(
      RecordSnapshot<int, Map<String, dynamic>> snapshot)
      : idProductCart = snapshot.value['idProductCart'] as String,
        quantityCart = snapshot.value['quantityCart'] as String,
        priceTotalCart = snapshot.value['priceTotalCart'] as String,
        unite = snapshot.value['unite'] as String,
        tva = snapshot.value['tva'] as String,
        remise = snapshot.value['remise'] as String,
        qtyRemise = snapshot.value['qtyRemise'] as String,
        succursale = snapshot.value['succursale'] as String,
        signature = snapshot.value['signature'] as String,
        created = Timestamp.parse(snapshot.value['created']),
        id = snapshot.key;
}
