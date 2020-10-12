import 'dart:convert';
import 'package:echange/models/connexion_models.dart';
import 'package:echange/services/api.dart';
import 'package:http/http.dart' as http;

//POST
Future<ConnexionModel> createConnexion(String matricule, password) async {
  final http.Response response =
      await http.post('$url_base/user/login', headers: <String, String>{
    'Content-Type': 'application/x-www-form-urlencoded',
  }, body: {
    'matricule': matricule,
    'password': password
  });
  if (response.statusCode == 200) {
    print(response.body);
    return ConnexionModel.fromJson(json.decode(response.body));
  } else {
    throw Exception("Erreur");
  }
}
