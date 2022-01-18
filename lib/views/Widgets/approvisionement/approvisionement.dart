import 'dart:convert';
import 'package:echange/models/approv_models.dart';
import 'package:echange/services/api.dart';
import 'package:echange/services/approv_api.dart';
import 'package:echange/views/Pages/index.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Approvisionement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Approvisionement"),
      ),
      body: FutureBuilder<List<ApprovModel>>(
        future: fetchApprov(http.Client()),
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
              builder: (context) => DialogApprovisionement()
          );
        },
        tooltip: "Ajouter versement",
        child: Icon(Icons.add),
      ),
    );
  }

  Widget viewsData(data) {
    final List<ApprovModel> compteMobile = data;
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

class DialogApprovisionement extends StatefulWidget {
  @override
  _DialogApprovisionementState createState() => _DialogApprovisionementState();
}

class _DialogApprovisionementState extends State<DialogApprovisionement> {
  final TextEditingController _controllermontant = TextEditingController();
  List<dynamic> _dataCompte = List();
  var codeCompte;

  Future<ApprovModel> futureApprovModels;
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
          child: Text("Faite votre Approvisionement Ici".toUpperCase(),
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
                //Numero Approvisionement
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButton(
                    hint: Text("code d'approvisionement"),
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
                  keyboardType: TextInputType.number,
                  cursorColor: Theme.of(context).accentColor,
                  decoration: InputDecoration(
                      labelText: "Montant", border: UnderlineInputBorder()),
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
            content: Text("Vous avez besoin de effetuer cette approvisionement?"
                .toUpperCase()),
            actions: [
              //si l'operation de est effectuer
              FlatButton(
                  onPressed: () {
                    futureApprovModels =
                        createApprov(codeCompte, _controllermontant.text);
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

  void getCompte() async {
    final respose = await http.get("$url_base/devise");
    var listData = jsonDecode(respose.body);
    print("data : $listData");
    setState(() {
      _dataCompte = listData;
    });
  }
}

/*
*futureCompteModels =
                    createApprov(codeCompte, _controllermontant.text);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Index()));
*/
