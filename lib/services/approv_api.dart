import 'dart:convert';
import 'package:echange/models/approv_models.dart';
import 'package:echange/services/api.dart';
import 'package:http/http.dart' as http;

//GET all
List<ApprovModel> parseApprov(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<ApprovModel>((json) => ApprovModel.fromJson(json)).toList();
}

Future<List<ApprovModel>> fetchApprov(http.Client client) async {
  final response = await client.get('$url_base/approv');
  return parseApprov(response.body);
}

//POST
Future<ApprovModel> createApprov(String codeCompte, montant) async {
  final http.Response response =
      await http.post('$url_base/approv/add', headers: <String, String>{
    'Content-Type': 'application/x-www-form-urlencoded',
  }, body: {
    'codeCompte': codeCompte,
    'montant': montant
  });
  if (response.statusCode == 201) {
    return ApprovModel.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}
