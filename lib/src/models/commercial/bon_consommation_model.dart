class BonConsommationModel {
  late int? id;
  late String ardoise;
  late int reference; // Quand on selection l'ardoise
  late String consommation; // json de consommation
  late String succursale;
  late String signature; // Celui qui fait le document
  late DateTime created;

  BonConsommationModel(
      {this.id,
      required this.ardoise,
      required this.reference,
      required this.consommation, 
      required this.succursale,
      required this.signature,
      required this.created});

  factory BonConsommationModel.fromSQL(List<dynamic> row) {
    return BonConsommationModel(
        id: row[0],
        ardoise: row[1],
        reference: row[2],
        consommation: row[3],
        succursale: row[4],
        signature: row[5],
        created: row[6]
      );
  }

  factory BonConsommationModel.fromJson(Map<String, dynamic> json) {
    return BonConsommationModel(
        id: json['id'],
        ardoise: json['ardoise'],
        reference: json['reference'],
        consommation: json['consommation'], 
        succursale: json['succursale'],
        signature: json['signature'],
        created: DateTime.parse(json['created']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ardoise': ardoise,
      'reference': reference,
      'consommation': consommation, 
      'succursale': succursale,
      'signature': signature,
      'created': created.toIso8601String()
    };
  }
}
