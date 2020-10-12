class CompteModel {
  final String id;
  final String codeCompte;
  final double solde;

  CompteModel({
    this.id,
    this.codeCompte,
    this.solde,
  });

  factory CompteModel.fromJson(Map<String, dynamic> json) {
    return CompteModel(
        id: json['_id'],
        codeCompte: json['codeCompte'],
        solde: json['solde']);
  }
}
