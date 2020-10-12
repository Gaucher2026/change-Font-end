import 'dart:convert';
import 'package:echange/models/operation_models.dart';
import 'package:echange/services/api.dart';
import 'package:echange/services/operation_api.dart';
import 'package:echange/views/Pages/index.dart';
import 'package:echange/views/Widgets/dialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Operation extends StatefulWidget {
  @override
  _OperationState createState() => _OperationState();
}

class _OperationState extends State<Operation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Operation'),
      ),
      body: FutureBuilder<List<OperationModel>>(
        future: fetchOperation(http.Client()),
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
          showDialog(context: context, child: DialogAddOperationState());
        },
        tooltip: "Effectuez l'operation d'echange",
        child: Icon(Icons.add),
      ),
    );
  }

  Widget viewsData(data) {
    final List<OperationModel> operationMobile = data;
    return Container(
        child: ListView.builder(
      itemCount: operationMobile.length,
      itemBuilder: (BuildContext context, i) {
        return ListTile(
          title: Text(
              "${operationMobile[i].devorg.toUpperCase()} Montant de : ${operationMobile[i].montant}"),
          subtitle: Text(
              "${operationMobile[i].devecha.toUpperCase()} Valeur de : ${operationMobile[i].valeur}"),
          leading: Icon(Icons.monetization_on),
        );
      },
    ));
  }
}

class DialogAddOperationState extends StatefulWidget {
  @override
  _DialogAddOperationStateState createState() =>
      _DialogAddOperationStateState();
}

class _DialogAddOperationStateState extends State<DialogAddOperationState> {
  final TextEditingController _controllerMontant = TextEditingController();

  Future<OperationModel> futurOperationModels;
  List<dynamic> _dataCompte = List();
  var codeOrg;
  var codeEcha;

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
          child: Text("EFFECTUEZ L'OPERATION D'ECHANGE".toUpperCase(),
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
                  //devise d'origine
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButton(
                      hint: Text("code origine"),
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
                  //devise d'echange
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
                  SizedBox(height: 10),
                  //Solde
                  TextField(
                    controller: _controllerMontant,
                    keyboardType: TextInputType.number,
                    cursorColor: Theme.of(context).accentColor,
                    decoration: InputDecoration(
                        labelText: "Montant", border: UnderlineInputBorder()),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        verifymontent(codeOrg, codeEcha,_controllerMontant.text);
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
              ))
        ]);
  }

  //dialog show
  void showConfirmation() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirmation"),
            content: Text(
                "Vous avez besoin de effetuer cette operation?".toUpperCase()),
            actions: [
              //si l'operation de est effectuer
              FlatButton(
                  onPressed: () {
                    verifymontent(codeOrg, codeEcha,_controllerMontant.text);
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

  effectuerOperation(String origine, String echange, String montant) async {
    Map data = {'dev_org': origine, 'dev_echa': echange, 'montant': montant};
    var response = await http
        .post("http://localhost:3000/api/v1/change/operation/add", body: data);
    if (response.statusCode == 200) {
      setState(() {
        Navigator.pop(context);
      });
    } else {
      setState(() {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return alertDialog(
                  "En dépit de Montant d'echange nous ne pouvons pas effectuer cette operation");
            });
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

  verifymontent(String origine, String echange,String montant) async {
    var response = await http
        .get("http://localhost:3000/api/v1/change/taux/$origine/$echange");
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      setState((){
        effectuerOperation(origine,echange, montant);
      });
    } else {
      setState(() {
        print("--------------------------------");
      });
    }
  }
}
