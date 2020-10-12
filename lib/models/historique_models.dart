class HistoriqueModels {
  final String id;
  final String data;
  final int heure;
  final int minute;
  final String codeorigine;
  final String codeechange;
  final String taux;

  HistoriqueModels(
      {this.id,
      this.data,
      this.heure,
      this.minute,
      this.codeorigine,
      this.codeechange,
      this.taux});

  factory HistoriqueModels.fromJson(Map<String, dynamic> json) {
    print(json);
    return HistoriqueModels(
        id: json['_id'],
        data: json['date'],
        heure: json['heure'],
        minute: json['minute'],
        codeorigine: json['code_origine'],
        codeechange: json['code_echange'],
        taux: json['Taux'].toString());
  }
}
