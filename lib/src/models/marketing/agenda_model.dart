import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/timestamp.dart';

class AgendaModel {
  late int? id;
  late String title;
  late String description;
  late DateTime dateRappel;
  late String signature;
  late Timestamp created;

  AgendaModel(
      {this.id,
      required this.title,
      required this.description,
      required this.dateRappel,
      required this.signature,
      required this.created});

  factory AgendaModel.fromSQL(List<dynamic> row) {
    return AgendaModel(
        id: row[0],
        title: row[1],
        description: row[2],
        dateRappel: row[3],
        signature: row[4],
        created: row[5]);
  }

  factory AgendaModel.fromJson(Map<String, dynamic> json) {
    return AgendaModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        dateRappel: DateTime.parse(json['dateRappel']),
        signature: json['signature'],
        created: Timestamp.parse(json['created']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateRappel': dateRappel.toIso8601String(),
      'signature': signature,
      'created': created.toIso8601String()
    };
  }

  AgendaModel.fromDatabase(RecordSnapshot<int, Map<String, dynamic>> snapshot)
      : title = snapshot.value['title'] as String,
        description = snapshot.value['description'] as String,
        dateRappel = snapshot.value['dateRappel'] as DateTime,
        signature = snapshot.value['signature'] as String,
        created = Timestamp.parse(snapshot.value['created']),
        id = snapshot.key;
}

class AgendaColor {
  final AgendaModel agendaModel;
  final Color color;

  AgendaColor({required this.agendaModel, required this.color});
}
