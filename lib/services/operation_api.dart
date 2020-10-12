import 'dart:convert';
import 'package:echange/models/operation_models.dart';
import 'package:echange/services/api.dart';
import 'package:http/http.dart' as http;

//GET all
List<OperationModel> parseOperation(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<OperationModel>((json) => OperationModel.fromJson(json))
      .toList();
}

Future<List<OperationModel>> fetchOperation(http.Client client) async {
  final response = await client.get('$url_base/operation');
  return parseOperation(response.body);
}

//POST
Future<OperationModel> createOperation(
    String origine, String echange, String montant) async {
  final http.Response response =
      await http.post('$url_base/operation/add', headers: <String, String>{
    'Content-Type': 'application/x-www-form-urlencoded',
  }, body: {
    'dev_org': origine,
    'dev_echa': echange,
    'montant': montant
  });
  if (response.statusCode == 201 || response.statusCode == 200) {
    return OperationModel.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}
