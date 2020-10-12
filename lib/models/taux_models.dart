class TauxModel {
  final String id;
  final String codeOrigine;
  final String codeEchange;
  final String type;
  final double taux;

  TauxModel(
      {this.id, this.codeOrigine, this.codeEchange, this.type, this.taux});

  factory TauxModel.fromJson(Map<String, dynamic> json) {
    return TauxModel(
        id: json['_id'],
        codeOrigine: json['code_origine'],
        codeEchange: json['code_echange'],
        type: json['type'],
        taux: json['Taux']);
  }
}
