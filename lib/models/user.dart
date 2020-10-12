class UserModel {
  final String nom;
  final double prenom;

  UserModel({
    this.nom,
    this.prenom,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        nom: json['nom'],
        prenom: json['prenom']);
  }
}