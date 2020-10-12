class HistoriqueModelsActions {
  final String id;
  final String data;
  final int heure;
  final int minute;
  final String nom;
  final String prenom;
  final String operation;

  HistoriqueModelsActions(
      {this.id,
        this.data,
        this.heure,
        this.minute,
        this.nom,
        this.prenom,
        this.operation});

  factory HistoriqueModelsActions.fromJson(Map<String, dynamic> json) {
    print(json);
    return HistoriqueModelsActions(
        id: json['_id'],
        data: json['date'],
        heure: json['heure'],
        minute: json['minute'],
        nom: json['nom'],
        prenom: json['prenom'],
        operation: json['operation']);
  }
}
