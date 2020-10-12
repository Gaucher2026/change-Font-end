import 'dart:convert';
import 'package:echange/services/api.dart';
import 'package:http/http.dart' as http;
import 'package:echange/models/inscription_models.dart';

//POST
Future<InscriptionModel> createInscription(
    String nom, prenom, matricule, password) async {
  final http.Response response =
      await http.post('$url_base/user/inscription', headers: <String, String>{
    'Content-Type': 'application/x-www-form-urlencoded',
  }, body: {
    'nom': nom,
    'prenom': prenom,
    'matricule': matricule,
    'password': password
  });
  if (response.statusCode == 201) {
    return InscriptionModel.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}
