import 'package:flutter/cupertino.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/timestamp.dart';

class AnnuaireModel {
  late int? id;
  late String categorie;
  late String nomPostnomPrenom;
  late String email;
  late String mobile1;
  late String mobile2;
  late String secteurActivite;
  late String nomEntreprise;
  late String grade;
  late String adresseEntreprise;
  late String succursale;
  late String signature;
  late Timestamp created;

  AnnuaireModel(
      {this.id,
      required this.categorie,
      required this.nomPostnomPrenom,
      required this.email,
      required this.mobile1,
      required this.mobile2,
      required this.secteurActivite,
      required this.nomEntreprise,
      required this.grade,
      required this.adresseEntreprise,
      required this.succursale,
      required this.signature,
      required this.created});

  factory AnnuaireModel.fromSQL(List<dynamic> row) {
    return AnnuaireModel(
        id: row[0],
        categorie: row[1],
        nomPostnomPrenom: row[2],
        email: row[3],
        mobile1: row[4],
        mobile2: row[5],
        secteurActivite: row[6],
        nomEntreprise: row[7],
        grade: row[8],
        adresseEntreprise: row[9],
        succursale: row[10],
        signature: row[11],
        created: row[12]);
  }

  factory AnnuaireModel.fromJson(Map<String, dynamic> json) {
    return AnnuaireModel(
        id: json['id'],
        categorie: json['categorie'],
        nomPostnomPrenom: json['nomPostnomPrenom'],
        email: json['email'],
        mobile1: json['mobile1'],
        mobile2: json['mobile2'],
        secteurActivite: json['secteurActivite'],
        nomEntreprise: json['nomEntreprise'],
        grade: json['grade'],
        adresseEntreprise: json['adresseEntreprise'],
        succursale: json['succursale'],
        signature: json['signature'],
        created: Timestamp.parse(json['created']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categorie': categorie,
      'nomPostnomPrenom': nomPostnomPrenom,
      'email': email,
      'mobile1': mobile1,
      'mobile2': mobile2,
      'secteurActivite': secteurActivite,
      'nomEntreprise': nomEntreprise,
      'grade': grade,
      'adresseEntreprise': adresseEntreprise,
      'succursale': succursale,
      'signature': signature,
      'created': created.toIso8601String()
    };
  }

  AnnuaireModel.fromDatabase(RecordSnapshot<int, Map<String, dynamic>> snapshot)
      : categorie = snapshot.value['categorie'] as String,
        nomPostnomPrenom = snapshot.value['nomPostnomPrenom'] as String,
        email = snapshot.value['email'] as String,
        mobile1 = snapshot.value['mobile1'] as String,
        mobile2 = snapshot.value['mobile2'] as String,
        secteurActivite = snapshot.value['secteurActivite'] as String,
        nomEntreprise = snapshot.value['nomEntreprise'] as String,
        grade = snapshot.value['grade'] as String,
        adresseEntreprise = snapshot.value['adresseEntreprise'] as String,
        succursale = snapshot.value['succursale'] as String,
        signature = snapshot.value['signature'] as String,
        created = Timestamp.parse(snapshot.value['created']),
        id = snapshot.key;
}

class AnnuaireColor {
  final AnnuaireModel annuaireModel;
  final Color color;

  AnnuaireColor({required this.annuaireModel, required this.color});
}
