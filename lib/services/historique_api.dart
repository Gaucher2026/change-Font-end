import 'dart:convert';
import 'package:echange/models/historique_models.dart';
import 'package:echange/services/api.dart';
import 'package:http/http.dart' as http;

//GET all

List<HistoriqueModels> parseHistorique(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<HistoriqueModels>((json) => HistoriqueModels.fromJson(json))
      .toList();
}

Future<List<HistoriqueModels>> fetchHistorique(http.Client client) async {
  final response = await client.get('$url_base/historique');
  print(response);
  return parseHistorique(response.body);
}


//Pour charge
/*
Future<HistoriqueModels> historiqueFetch() async {
  final response = await http.get('$url_base/historique');
  if (response.statusCode != 200) {
    throw Exception('Failed to load album');
  } else {
    final responseBody = json.decode(response.body);
    return HistoriqueModels.fromJson(responseBody[0]);
  }
}
*/