import 'package:sembast/sembast.dart';
import 'package:sembast/timestamp.dart';

class CaisseModel {
  late int? id;
  late String nomComplet;
  late String pieceJustificative;
  late String libelle;
  late String montantEncaissement;
  late String departement;
  late String typeOperation;
  late String numeroOperation;
  late String signature; // celui qui fait le document
  late int reference;
  late String caisseName;
  late Timestamp created;
  late String montantDecaissement;

  CaisseModel({
    this.id,
    required this.nomComplet,
    required this.pieceJustificative,
    required this.libelle,
    required this.montantEncaissement,
    required this.departement,
    required this.typeOperation,
    required this.numeroOperation,
    required this.signature,
    required this.reference,
    required this.caisseName,
    required this.created,
    required this.montantDecaissement,
  });

  factory CaisseModel.fromSQL(List<dynamic> row) {
    return CaisseModel(
      id: row[0],
      nomComplet: row[1],
      pieceJustificative: row[2],
      libelle: row[3],
      montantEncaissement: row[4],
      departement: row[5],
      typeOperation: row[6],
      numeroOperation: row[7],
      signature: row[8],
      reference: row[9],
      caisseName: row[10],
      created: row[11],
      montantDecaissement: row[12],
    );
  }

  factory CaisseModel.fromJson(Map<String, dynamic> json) {
    return CaisseModel(
      id: json['id'],
      nomComplet: json['nomComplet'],
      pieceJustificative: json['pieceJustificative'],
      libelle: json['libelle'],
      montantEncaissement: json['montantEncaissement'],
      departement: json['departement'],
      typeOperation: json['typeOperation'],
      numeroOperation: json['numeroOperation'],
      signature: json['signature'],
      reference: json['reference'],
      caisseName: json['caisseName'],
      created: Timestamp.parse(json['created']),
      montantDecaissement: json['montantDecaissement'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomComplet': nomComplet,
      'pieceJustificative': pieceJustificative,
      'libelle': libelle,
      'montantEncaissement': montantEncaissement,
      'departement': departement,
      'typeOperation': typeOperation,
      'numeroOperation': numeroOperation,
      'signature': signature,
      'reference': reference,
      'caisseName': caisseName,
      'created': created.toIso8601String(),
      'montantDecaissement': montantDecaissement,
    };
  }

  CaisseModel.fromDatabase(RecordSnapshot<int, Map<String, dynamic>> snapshot)
      : nomComplet = snapshot.value['nomComplet'] as String,
        pieceJustificative = snapshot.value['pieceJustificative'] as String,
        libelle = snapshot.value['libelle'] as String,
        montantEncaissement = snapshot.value['montantEncaissement'] as String,
        departement = snapshot.value['departement'] as String,
        typeOperation = snapshot.value['typeOperation'] as String,
        numeroOperation = snapshot.value['numeroOperation'] as String,
        signature = snapshot.value['signature'] as String,
        created = Timestamp.parse(snapshot.value['created']),
        id = snapshot.key;
}
