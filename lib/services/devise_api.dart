import 'dart:convert';
import 'package:echange/models/devise_models.dart';
import 'package:echange/services/api.dart';
import 'package:http/http.dart' as http;

//GET
List<DeviseModel> parseDevise(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<DeviseModel>((json) => DeviseModel.fromJson(json)).toList();
}

Future<List<DeviseModel>> fetchDevise(http.Client client) async {
  final response = await client.get('$url_base/devise');

  return parseDevise(response.body);
}

//POST
Future<DeviseModel> createDevise(String codeOrg, libOrg) async {
  print("${codeOrg.runtimeType}");
  final http.Response response =
      await http.post('$url_base/devise/add', headers: <String, String>{
    'Content-Type': 'application/x-www-form-urlencoded',
  }, body: {
    'code_origine': codeOrg,
    'lib_origine': libOrg
  });
  if (response.statusCode == 201) {
    return DeviseModel.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}
