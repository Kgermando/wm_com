import 'package:sembast/sembast.dart';
import 'package:sembast/timestamp.dart';

class FactureCartModel {
  late int? id;
  late String cart;
  late String client; // Numero facture
  late String nomClient;
  late String telephone;
  late String succursale;
  late String signature; // Celui qui fait le document
  late Timestamp created;

  FactureCartModel(
      {this.id,
      required this.cart,
      required this.client,
      required this.nomClient,
      required this.telephone,
      required this.succursale,
      required this.signature,
      required this.created});

  factory FactureCartModel.fromSQL(List<dynamic> row) {
    return FactureCartModel(
        id: row[0],
        cart: row[1],
        client: row[2],
        nomClient: row[3],
        telephone: row[4],
        succursale: row[5],
        signature: row[6],
        created: row[7]);
  }

  factory FactureCartModel.fromJson(Map<String, dynamic> json) {
    return FactureCartModel(
        id: json['id'],
        cart: json['cart'],
        client: json['client'],
        nomClient: json['nomClient'],
        telephone: json['telephone'],
        succursale: json['succursale'],
        signature: json['signature'],
        created: Timestamp.parse(json['created']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cart': cart,
      'client': client,
      'nomClient': nomClient,
      'telephone': telephone,
      'succursale': succursale,
      'signature': signature,
      'created': created.toIso8601String()
    };
  }

  FactureCartModel.fromDatabase(
      RecordSnapshot<int, Map<String, dynamic>> snapshot)
      : cart = snapshot.value['cart'] as String,
        client = snapshot.value['client'] as String,
        nomClient = snapshot.value['nomClient'] as String,
        telephone = snapshot.value['telephone'] as String,
        succursale = snapshot.value['succursale'] as String,
        signature = snapshot.value['signature'] as String,
        created = Timestamp.parse(snapshot.value['created']),
        id = snapshot.key;
}
