class InscriptionModel {
  final String nom;
  final String prenom;
  final String matricule;
  final String password;

  InscriptionModel({this.nom, this.prenom, this.matricule, this.password});

  factory InscriptionModel.fromJson(Map<String, dynamic> json) {
    return InscriptionModel(
        nom: json['nom'],
        prenom: json['prenom'],
        matricule: json['matricule'],
        password: json['password']);
  }
}
