class ConnexionModel {
  final String matricule;
  final String password;

  ConnexionModel({this.matricule, this.password});

  factory ConnexionModel.fromJson(Map<String, dynamic> json) {
    return ConnexionModel(
      matricule: json['matricule'],
      password: json['password'],
    );
  }
}
