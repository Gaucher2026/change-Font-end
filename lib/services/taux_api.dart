import 'dart:convert';
import 'package:echange/models/taux_models.dart';
import 'package:echange/services/api.dart';
import 'package:http/http.dart' as http;

//GET All
List<TauxModel> parseTaux(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<TauxModel>((json) => TauxModel.fromJson(json)).toList();
}

Future<List<TauxModel>> fetchTaux(http.Client client) async {
  final response = await client.get('$url_base/taux');
  return parseTaux(response.body);
}

//POST
Future<TauxModel> createTaux(codeOrg, codeEcha, taux, type) async {
  print("${codeOrg.runtimeType}");
  final http.Response response =
      await http.post('$url_base/taux/add', headers: <String, String>{
    'Content-Type': 'application/x-www-form-urlencoded',
  }, body: {
    'code_origine': codeOrg,
    'code_echange': codeEcha,
    'type': type,
    'taux': taux
  });
  if (response.statusCode == 201) {
    return TauxModel.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}
