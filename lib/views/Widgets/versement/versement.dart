import 'dart:convert';
import 'package:echange/models/versement_models.dart';
import 'package:echange/services/api.dart';
import 'package:echange/services/versement_api.dart';
import 'package:echange/views/Pages/index.dart';
import 'package:echange/views/Widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Versement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Versement"),
      ),
      body: FutureBuilder<List<VersementModel>>(
        future: fetchVersement(http.Client()),
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
          showDialog(context: context, child: DialogVersement());
        },
        tooltip: "Ajouter versement",
        child: Icon(Icons.add),
      ),
    );
  }

  Widget viewsData(data) {
    final List<VersementModel> compteMobile = data;
    return Container(
        child: ListView.builder(
      itemCount: compteMobile.length,
      itemBuilder: (BuildContext context, i) {
        return ListTile(
          title: Text("${compteMobile[i].codeCompte}"),
          subtitle: Text("${compteMobile[i].montant}"),
          leading: Icon(Icons.monetization_on),
        );
      },
    ));
  }
}

class DialogVersement extends StatefulWidget {
  @override
  _DialogVersementState createState() => _DialogVersementState();
}

class _DialogVersementState extends State<DialogVersement> {
  final TextEditingController _controllermotif = TextEditingController();
  final TextEditingController _controllermontant = TextEditingController();
  List<dynamic> _dataCompte = List();
  var codeCompte;

  Future<VersementModel> futureCompteModels;

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
          child: Text("Faite votre versement ici".toUpperCase(),
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
                //Numero Versement
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButton(
                    hint: Text("code versement"),
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
                //Montant
                TextField(
                  controller: _controllermontant,
                  cursorColor: Theme.of(context).accentColor,
                  decoration: InputDecoration(
                      labelText: "Montant", border: UnderlineInputBorder()),
                ),
                SizedBox(height: 10),
                //Motif
                TextField(
                  controller: _controllermotif,
                  maxLines: 4,
                  decoration: InputDecoration(
                      labelText: "Motif de versement",
                      border: UnderlineInputBorder()),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showConfirmation();
                    });
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

  //dialog show
  void showConfirmation() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirmation"),
            content: Text("Vous avez besoin de effetuer ce versement?".toUpperCase()),
            actions: [
              //si l'operation de est effectuer
              FlatButton(
                  onPressed: () {
                    verifyCompte(codeCompte.toString(), _controllermontant.text,
                        _controllermotif.text);
                    futureCompteModels = createVersement(codeCompte.toString(),
                        _controllermontant.text, _controllermotif.text);
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Index()));
                  },
                  child: Text("yes".toUpperCase())),
              //si l'operation ne pas effectuer
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(context);
                  },
                  child: Text("no".toUpperCase()))
            ],
          );
        });
  }

  verifyCompte(String codeCompte, String montant, String motif) async {
    var montantInt = int.parse(montant);
    var response = await http
        .get("http://localhost:3000/api/v1/change/compte/" + codeCompte);
    if (response.statusCode == 200) {
      var montantCompte = json.decode(response.body);
      if (montantInt > montantCompte) {
        setState(() {
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return alertDialog(
                    "Nous ne pouvons pas effectuer ce versement, car le montant de $montant est trop pour decrementé dans compte ");
              });
        });
      } else {
        setState(() {});
      }
    } else {
      setState(() {
        print("--------------------------------");
      });
    }
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
