import 'package:sembast/sembast.dart';
import 'package:sembast/timestamp.dart';

class GainModel {
  late int? id;
  late double sum;
  late String succursale;
  late String signature; // celui qui fait le document
  late Timestamp created;

  GainModel(
      {this.id,
      required this.sum,
      required this.succursale,
      required this.signature,
      required this.created});

  factory GainModel.fromSQL(List<dynamic> row) {
    return GainModel(
        id: row[0],
        sum: row[1],
        succursale: row[2],
        signature: row[3],
        created: row[4]);
  }

  factory GainModel.fromJson(Map<String, dynamic> json) {
    return GainModel(
        id: json['id'],
        sum: double.parse(json['sum'].toString()),
        succursale: json['succursale'],
        signature: json['signature'],
        created: Timestamp.parse(json['created']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sum': sum,
      'succursale': succursale,
      'signature': signature,
      'created': created.toIso8601String()
    };
  }

  GainModel.fromDatabase(RecordSnapshot<int, Map<String, dynamic>> snapshot)
      : sum = snapshot.value['sum'] as double,
        succursale = snapshot.value['succursale'] as String,
        signature = snapshot.value['signature'] as String,
        created = Timestamp.parse(snapshot.value['created']),
        id = snapshot.key;
}
