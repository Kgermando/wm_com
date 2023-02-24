import 'package:sembast/sembast.dart';
import 'package:sembast/timestamp.dart';

class PaiementReservationModel {
  late int? id;
  late int reference;
  late String client;
  late String motif;
  late String montant;
  late String signature; // celui qui fait le document
  late Timestamp created;

  PaiementReservationModel({
    this.id,
    required this.reference,
    required this.client,
    required this.motif,
    required this.montant,
    required this.signature,
    required this.created,
  });

  factory PaiementReservationModel.fromSQL(List<dynamic> row) {
    return PaiementReservationModel(
        id: row[0],
        reference: row[1],
        client: row[2],
        motif: row[3],
        montant: row[4],
        signature: row[5],
        created: row[6]);
  }

  factory PaiementReservationModel.fromJson(Map<String, dynamic> json) {
    return PaiementReservationModel(
      id: json["id"],
      reference: json["reference"],
      client: json["client"],
      motif: json["motif"],
      montant: json["montant"],
      signature: json['signature'],
      created: Timestamp.parse(json['created']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'client': client,
      'motif': motif,
      'montant': montant,
      'signature': signature,
      'created': created.toIso8601String()
    };
  }

  PaiementReservationModel.fromDatabase(
      RecordSnapshot<int, Map<String, dynamic>> snapshot)
      : reference = snapshot.value['reference'] as int,
        client = snapshot.value['client'] as String,
        motif = snapshot.value['motif'] as String,
        montant = snapshot.value['montant'] as String,
        signature = snapshot.value['signature'] as String,
        created = Timestamp.parse(snapshot.value['created']),
        id = snapshot.key;
}
