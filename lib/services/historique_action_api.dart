import 'dart:convert';
import 'package:echange/models/historique_action.dart';
import 'package:echange/services/api.dart';
import 'package:http/http.dart' as http;

//GET all

List<HistoriqueModelsActions> parseHistoriqueAction(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<HistoriqueModelsActions>((json) => HistoriqueModelsActions.fromJson(json))
      .toList();
}

Future<List<HistoriqueModelsActions>> fetchHistoriqueAction(http.Client client) async {
  final response = await client.get('$url_base/action');
  print(response);
  return parseHistoriqueAction(response.body);
}

