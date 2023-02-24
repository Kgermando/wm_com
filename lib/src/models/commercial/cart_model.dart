import 'package:sembast/sembast.dart';
import 'package:sembast/timestamp.dart';

class CartModel {
  late int? id;
  late String idProductCart;
  late String quantityCart;
  late String priceCart;
  late String priceAchatUnit;
  late String unite;
  late String tva;
  late String remise;
  late String qtyRemise;
  late String succursale;
  late String signature; // celui qui fait le document
  late Timestamp created;
  late DateTime createdAt;

  CartModel(
      {this.id,
      required this.idProductCart,
      required this.quantityCart,
      required this.priceCart,
      required this.priceAchatUnit,
      required this.unite,
      required this.tva,
      required this.remise,
      required this.qtyRemise,
      required this.succursale,
      required this.signature,
      required this.created,
      required this.createdAt});

  factory CartModel.fromSQL(List<dynamic> row) {
    return CartModel(
        id: row[0],
        idProductCart: row[1],
        quantityCart: row[2],
        priceCart: row[3],
        priceAchatUnit: row[4],
        unite: row[5],
        tva: row[6],
        remise: row[7],
        qtyRemise: row[8],
        succursale: row[9],
        signature: row[10],
        created: row[11],
        createdAt: row[12]);
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
        id: json['id'],
        idProductCart: json['idProductCart'],
        quantityCart: json['quantityCart'],
        priceCart: json['priceCart'],
        priceAchatUnit: json['priceAchatUnit'],
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
      'priceCart': priceCart,
      'priceAchatUnit': priceAchatUnit,
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

  CartModel.fromDatabase(RecordSnapshot<int, Map<String, dynamic>> snapshot)
      : idProductCart = snapshot.value['idProductCart'] as String,
        quantityCart = snapshot.value['quantityCart'] as String,
        priceCart = snapshot.value['priceCart'] as String,
        priceAchatUnit = snapshot.value['priceAchatUnit'] as String,
        unite = snapshot.value['unite'] as String,
        tva = snapshot.value['tva'] as String,
        remise = snapshot.value['remise'] as String,
        qtyRemise = snapshot.value['qtyRemise'] as String,
        succursale = snapshot.value['succursale'] as String,
        signature = snapshot.value['signature'] as String,
        created = Timestamp.parse(snapshot.value['created']),
        id = snapshot.key;
}
