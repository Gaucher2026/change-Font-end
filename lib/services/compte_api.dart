import 'dart:convert';
import 'package:echange/models/compte_models.dart';
import 'package:echange/services/api.dart';
import 'package:http/http.dart' as http;

//GET all
List<CompteModel> parseCompte(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<CompteModel>((json) => CompteModel.fromJson(json)).toList();
}

Future<List<CompteModel>> fetchCompte(http.Client client) async {
  final response = await client.get('$url_base/compte');
  return parseCompte(response.body);
}

//POST
Future<CompteModel> createCompte(codeCompte,solde) async {
  final http.Response response =
      await http.post('$url_base/compte/add', headers: <String, String>{
    'Content-Type': 'application/x-www-form-urlencoded',
  }, body: {
    'codeCompte': codeCompte,
    'solde': solde
  });
  if (response.statusCode == 201 || response.statusCode == 200 ) {
    return CompteModel.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}
