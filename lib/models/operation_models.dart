class OperationModel {
  final String id;
  final String devorg;
  final String devecha;
  final double valeur;
  final double montant;

  OperationModel({
    this.id,
    this.devorg,
    this.devecha,
    this.valeur,
    this.montant,
  });

  factory OperationModel.fromJson(Map<String, dynamic> json) {
    return OperationModel(
        id: json['_id'],
        devorg: json['dev_origine'],
        devecha: json['dev_echange'],
        valeur: json['valeur'],
        montant: json['montant']);
  }
}
