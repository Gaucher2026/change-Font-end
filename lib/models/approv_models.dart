class ApprovModel {
  final String id;
  final String codeCompte;
  final double montant;

  ApprovModel({
    this.id,
    this.codeCompte,
    this.montant,
  });

  factory ApprovModel.fromJson(Map<String, dynamic> json) {
    return ApprovModel(
        id: json['_id'],
        codeCompte: json['codeCompte'],
        montant: json['montant']);
  }
}
