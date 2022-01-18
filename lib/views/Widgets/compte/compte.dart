import 'dart:convert';
import 'package:echange/models/compte_models.dart';
import 'package:echange/services/api.dart';
import 'package:echange/services/compte_api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Compte extends StatefulWidget {
  @override
  _CompteState createState() => _CompteState();
}

class _CompteState extends State<Compte> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compte'),

        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<List<CompteModel>>(
        future: fetchCompte(http.Client()),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            print(snapshot.error);
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return viewsData(snapshot.data);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => DialogAddCompte(contexts: context,)
          );
        },
        tooltip: "Ajouter un compte",
        child: Icon(Icons.add),
      ),
    );
  }

  Widget viewsData(data) {
    final List<CompteModel> compteMobile = data;
    return Container(
        child: ListView.builder(
      itemCount: compteMobile.length,
      itemBuilder: (BuildContext context, i) {
        return ListTile(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogCompte(
                    codeCompte: compteMobile[i].codeCompte,
                    solde: compteMobile[i].solde.toString(),
                  );
                });
          },
          title: Text("${compteMobile[i].codeCompte} "),
          subtitle: Text("${compteMobile[i].solde}"),
          leading: Icon(Icons.monetization_on),
        );
      },
    ));
  }
}

// ignore: must_be_immutable
class DialogCompte extends StatelessWidget {
  //constructeur
  final String compteNom;
  final String codeCompte;
  final String solde;

  const DialogCompte({Key key, this.compteNom, this.codeCompte, this.solde})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Text("$codeCompte"),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Text("$solde"),
        )
      ],
    );
  }
}

class DialogAddCompte extends StatefulWidget {
  final BuildContext contexts;

  const DialogAddCompte({Key key, this.contexts}) : super(key: key);
  @override
  _DialogAddCompteState createState() => _DialogAddCompteState(contexts);
}

class _DialogAddCompteState extends State<DialogAddCompte> {
  final TextEditingController _controllerSolde = TextEditingController();
  final BuildContext contexts;
  List<dynamic> _dataCompte = List();
  var codeCompte;
  var nomCompte;

  Future<CompteModel> futureCompteModels;

  _DialogAddCompteState(this.contexts);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCompte();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Align(
          alignment: Alignment.center,
          child: Text("AJOUTER UN COMPTE".toUpperCase(),
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w900)),
        ),
        children: [
          Container(
            width: 500,
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                //Numero Compte
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButton(
                    hint: Text("code compte"),
                    value: codeCompte,
                    items: _dataCompte.map((item) {
                      return DropdownMenuItem(
                        child: Text(item['code_origine']),
                        value: item['code_origine'],
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        codeCompte = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                //Solde
                TextField(
                  controller: _controllerSolde,
                  keyboardType: TextInputType.number,
                  cursorColor: Theme.of(context).accentColor,
                  decoration: InputDecoration(
                      labelText: "Montant", border: UnderlineInputBorder()),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text("Confirmation"),
                          content:
                              Text("Voulez-vous vraiment ajouter ce compte?".toUpperCase()),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("non".toUpperCase()),
                              onPressed: () {
                                Navigator.of(contexts).pop();
                              },
                            ),
                            FlatButton(
                              child: Text("yes".toUpperCase()),
                              onPressed: () {
                                setState(() {
                                  futureCompteModels = createCompte(
                                      codeCompte, _controllerSolde.text);
                                  Navigator.pushNamed(context,'/index');
                                });
                              },
                            ),
                          ],
                        ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).accentColor,
                    ),
                    alignment: Alignment.center,
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Text("Enregistrer".toUpperCase(),
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          )
        ]);
  }

  void getCompte() async {
    final respose = await http.get("$url_base/devise");
    var listData = jsonDecode(respose.body);
    print("data : $listData");
    setState(() {
      _dataCompte = listData;
    });
  }
}
