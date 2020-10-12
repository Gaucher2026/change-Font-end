import 'dart:convert';
import 'package:echange/models/versement_models.dart';
import 'package:echange/services/api.dart';
import 'package:http/http.dart' as http;

//GET all
List<VersementModel> parseVersement(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<VersementModel>((json) => VersementModel.fromJson(json))
      .toList();
}

Future<List<VersementModel>> fetchVersement(http.Client client) async {
  final response = await client.get('$url_base/versement');
  return parseVersement(response.body);
}

//POST
Future<VersementModel> createVersement(codeCompte, montant, motif) async {
  final http.Response response =
      await http.post('$url_base/versement/add', headers: <String, String>{
    'Content-Type': 'application/x-www-form-urlencoded',
  }, body: {
    'codeCompte': codeCompte,
    'motif': motif,
    'montant': montant
  });
  if (response.statusCode == 201) {
    return VersementModel.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}
