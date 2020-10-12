class DeviseModel {
  final String id;
  final String codeOrigine;
  final String libOrigine;

  DeviseModel({this.id, this.codeOrigine, this.libOrigine});

  factory DeviseModel.fromJson(Map<String, dynamic> json) {
    return DeviseModel(
      id: json['_id'],
      codeOrigine: json['code_origine'],
      libOrigine: json['lib_origine'],
    );
  }
}
