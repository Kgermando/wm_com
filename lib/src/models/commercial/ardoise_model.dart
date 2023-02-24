import 'package:sembast/sembast.dart';
import 'package:sembast/timestamp.dart'; 

class ArdoiseModel {
  late int? id;
  late String ardoise;
  late String ardoiseJson;
  late String statut;
  late String succursale;
  late String signature; // Celui qui fait le document
  late Timestamp created;

  ArdoiseModel(
      {this.id,
      required this.ardoise,
      required this.ardoiseJson,
      required this.statut,
      required this.succursale,
      required this.signature,
      required this.created});

  factory ArdoiseModel.fromSQL(List<dynamic> row) {
    return ArdoiseModel(
        id: row[0],
        ardoise: row[1],
        ardoiseJson: row[2],
        statut: row[3],
        succursale: row[4],
        signature: row[5],
        created: row[6]);
  }

  factory ArdoiseModel.fromJson(Map<String, dynamic> json) {
    return ArdoiseModel(
        id: json['id'],
        ardoise: json['ardoise'],
        ardoiseJson: json['ardoiseJson'],
        statut: json['statut'],
        succursale: json['succursale'],
        signature: json['signature'],
        created: Timestamp.parse(json['created']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ardoise': ardoise,
      'ardoiseJson': ardoiseJson,
      'statut': statut,
      'succursale': succursale,
      'signature': signature,
      'created': created.toIso8601String()
    };
  }

  ArdoiseModel.fromDatabase(RecordSnapshot<int, Map<String, dynamic>> snapshot)
      : ardoise = snapshot.value['ardoise'] as String,
        ardoiseJson = snapshot.value['ardoiseJson'] as String,
        statut = snapshot.value['statut'] as String,
        succursale = snapshot.value['succursale'] as String,
        signature = snapshot.value['signature'] as String,
        created = Timestamp.parse(snapshot.value['created']),
        id = snapshot.key;
}
