import 'dart:convert';
import 'package:echange/models/taux_models.dart';
import 'package:echange/services/api.dart';
import 'package:echange/services/taux_api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class TauxCreate extends StatefulWidget {
  @override
  _TauxStateCreate createState() => _TauxStateCreate();
}

class _TauxStateCreate extends State<TauxCreate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<TauxModel>>(
        future: fetchTaux(http.Client()),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            print(snapshot.error);
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return TauxViews(deviceMobile: snapshot.data);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder:(_) => DialogTaux());
        },
        tooltip: "Ajouter Devise",
        child: Icon(Icons.add),
      ),
    );
  }
}

//Liste des elements à afficher
class TauxViews extends StatelessWidget {
  //attribue
  final List<TauxModel> deviceMobile;

  const TauxViews({Key key, this.deviceMobile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
          itemCount: deviceMobile.length,
          itemBuilder: (BuildContext context, i) {
            if (deviceMobile[i].type == "true") {
              return ListTile(
                title: Text(
                    "${deviceMobile[i].codeOrigine} => ${deviceMobile[i].codeEchange}"),
                subtitle: Text("${deviceMobile[i].taux} => ACHAT "),
                leading: Icon(Icons.monetization_on),
              );
            } else {
              return ListTile(
                  title: Text(
                      "${deviceMobile[i].codeOrigine} => ${deviceMobile[i].codeEchange}"),
                  subtitle: Text("${deviceMobile[i].taux} => VENTE"),
                  leading: Icon(Icons.monetization_on));
            }
          },
        ));
  }
}

class DialogTaux extends StatefulWidget {
  @override
  _DialogTaux createState() => _DialogTaux();
}

class _DialogTaux extends State<DialogTaux> {
  final TextEditingController _controllerTaux = TextEditingController();
  List<dynamic> _dataCompte = List();
  List<Map<String, String>> _typeOperation = List();
  var codeOrg;
  var codeEcha;
  var typeOperation;

  Future<TauxModel> futureTauxModels;

  @override
  void initState() {
    super.initState();
    getCompte();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Align(
          alignment: Alignment.center,
          child: Text("Taux du jour".toUpperCase(),
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
                //Code Origine
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButton(
                    hint: Text("code d'origine"),
                    value: codeOrg,
                    items: _dataCompte.map((item) {
                      return DropdownMenuItem(
                        child: Text(item['code_origine']),
                        value: item['code_origine'],
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        codeOrg = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                //Code Echange
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButton(
                    hint: Text("code d'echange"),
                    value: codeEcha,
                    items: _dataCompte.map((item) {
                      return DropdownMenuItem(
                        child: Text(item['code_origine']),
                        value: item['code_origine'],
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        codeEcha = value;
                      });
                    },
                  ),
                ),
                //operation d'echange Type
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButton(
                    hint: Text("Type d'operation d'echange"),
                    value: typeOperation,
                    items: _typeOperation.map((item) {
                      return DropdownMenuItem(
                        child: Text(item['nom']),
                        value: item['type'],
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        typeOperation = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                //Taux
                TextField(
                  cursorColor: Theme.of(context).accentColor,
                  keyboardType: TextInputType.number,
                  controller: _controllerTaux,
                  decoration: InputDecoration(
                      labelText: "Montant", border: UnderlineInputBorder()),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      futureTauxModels = createTaux(codeOrg, codeEcha,
                          _controllerTaux.text, typeOperation.toString());
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).accentColor,
                    ),
                    alignment: Alignment.center,
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Text("Ajouter Taux".toUpperCase(),
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
    final typeOperation = [
      {'nom': 'Achat', 'type': "true"},
      {'nom': 'Vente', 'type': "false"}
    ];
    var listData = jsonDecode(respose.body);
    print("data : $listData");
    setState(() {
      _dataCompte = listData;
      _typeOperation = typeOperation;
    });
  }
}
