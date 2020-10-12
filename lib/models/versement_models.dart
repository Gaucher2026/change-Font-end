class VersementModel {
  final String id;
  final String codeCompte;
  final String motif;
  final double montant;

  VersementModel({
    this.id,
    this.codeCompte,
    this.motif,
    this.montant,
  });

  factory VersementModel.fromJson(Map<String, dynamic> json) {
    return VersementModel(
        id: json['_id'],
        codeCompte: json['codeCompte'],
        motif: json['motif'],
        montant: json['montant']);
  }
}
