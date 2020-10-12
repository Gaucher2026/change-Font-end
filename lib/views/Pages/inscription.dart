import 'package:flutter/material.dart';
import 'package:echange/views/Pages/index.dart';
import 'package:http/http.dart' as http;

class Inscription extends StatefulWidget {
  @override
  _InscriptionState createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final _fromKeys = GlobalKey<FormState>();
  String _controllerNom = "";
  String _controllerPrenom = "";
  String _controllerPseudo = "";
  String _controllerMatricule = "";
  String _controllerPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("INSCRIPTION"),
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                child: Center(
                  child: Image.asset("images/undraw_investing_7u74.png"),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Center(
                child: formulaire(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container formulaire() {
    return Container(
        child: Column(
      children: [
        Container(
            width: 400,
            padding: EdgeInsets.all(30),
            child: Form(
              autovalidate: true,
              key: _fromKeys,
              child: Column(
                children: [
                  //Nom
                  TextFormField(
                    // ignore: missing_return
                    validator: (nom) {
                      if (nom.isEmpty) {
                        return "remplissez ce champs";
                      } else {
                        setState(() => _controllerNom = nom);
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Nom",
                        labelText: "Nom",
                        helperStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        helperText: ""),
                  ),
                  SizedBox(height: 10),
                  //Prenom
                  TextFormField(
                    autocorrect: true,
                    // ignore: missing_return
                    validator: (prenoms) {
                      if (prenoms.isEmpty) {
                        return "remplissez ce champs";
                      } else {
                        setState(() => _controllerPrenom = prenoms);
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Prenom",
                        labelText: "Prenom",
                        helperStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        helperText: ""),
                  ),
                  SizedBox(height: 10),
                  //Pseudo
                  TextFormField(
                    autocorrect: true,
                    onSaved: (String pseudo) =>
                        setState(() => _controllerPseudo = pseudo),
                    // ignore: missing_return
                    validator: (pseudo) {
                      if (pseudo.isEmpty) {
                        return "remplissez ce champs";
                      } else {
                        setState(() => _controllerPseudo = pseudo);
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Pseudo",
                        labelText: "Pseudo",
                        helperStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        helperText: ""),
                  ),
                  SizedBox(height: 10),
                  //Matricule
                  TextFormField(
                    autocorrect: true,
                    // ignore: missing_return
                    validator: (matris) {
                      if (matris.isEmpty) {
                        return "remplissez ce champs";
                      } else if (matris is int) {
                        return "Ce champs doit avoir que les nombres";
                      } else {
                        setState(() => _controllerMatricule = matris);
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Matricule",
                        labelText: "Matricule",
                        helperStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        helperText: ""),
                  ),
                  SizedBox(height: 10),
                  //Password
                  TextFormField(
                    autocorrect: true,
                    // ignore: missing_return
                    validator: (password) {
                      if (password.isEmpty) {
                        return "remplissez ce champs";
                      } else if (password.length < 8) {
                        return "Votre mot de passe doit comportement au moins 8 caractaires";
                      } else if (password
                          .contains(new RegExp(r'[A-Z]+[a-z0-9]+@[0-9]'))) {
                        return "ex: Saelbatuta@12345";
                      } else {
                        setState(() => _controllerPassword = password);
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Password",
                        labelText: "Password",
                        helperStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        helperText: ""),
                  ),
                  SizedBox(height: 10),
                  //Bouton d'inscription
                  GestureDetector(
                    onTap: () {
                      _fromKeys.currentState.validate()
                          ? signInscription(
                              _controllerMatricule,
                              _controllerPassword,
                              _controllerNom,
                              _controllerPrenom,
                              _controllerPseudo)
                          : Text("");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).accentColor,
                      ),
                      alignment: Alignment.center,
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: Text("S'INSCRIRE",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ))
      ],
    ));
  }

  signInscription(String matricule, String password, String nom, String prenom,
      String pseudo) async {
    Map data = {
      'nom': nom,
      'prenom': prenom,
      'matricule': matricule,
      'pseudo': pseudo,
      'password': password
    };
    print(data);
    //Stockage
    //SharedPreferences sharedPreferences = await SharedPreferences.getInstances();
    var response = await http.post(
        "http://localhost:3000/api/v1/change/user/inscription",
        body: data);
    if (response.statusCode == 200) {
      setState(() {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return Index(myToken:response.body);
        }));
      });
    } else {
      setState(() {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Verifies vos donnees s'il vous plâit"),
              );
            });
      });
    }
  }
}
