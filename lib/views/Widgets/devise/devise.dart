import 'package:echange/models/devise_models.dart';
import 'package:echange/services/api.dart';
import 'package:echange/services/devise_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Devise extends StatefulWidget {
  @override
  _DeviseState createState() => _DeviseState();
}

class _DeviseState extends State<Devise> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deviseGet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Devise"),
      ),
      body: FutureBuilder<List<DeviseModel>>(
        future: fetchDevise(http.Client()),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            print(snapshot.error);
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return DeviseViews(deviceMobile: snapshot.data);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context, 
            builder: (_) => DialogDevise());
        },
        tooltip: "Ajouter Devise",
        child: Icon(Icons.add),
      ),
    );
  }

  deviseGet() async {
    var response = await http.get('$url_base/devise');
    if (response.statusCode == 200) {
      http.Response africa = response;
      print(africa);
      /**
       * setState(() {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return Index(myToken: response.body);
        }));
      });
       */
    } else {
      print("Problemmme");
    }
  }
}

//Liste des elements à afficher
class DeviseViews extends StatelessWidget {
  //attribue
  final List<DeviseModel> deviceMobile;

  const DeviseViews({Key key, this.deviceMobile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
      itemCount: deviceMobile.length,
      itemBuilder: (BuildContext context, i) {
        return ListTile(
          title: Text("${deviceMobile[i].codeOrigine}"),
          subtitle: Text("${deviceMobile[i].libOrigine}"),
          leading: Icon(Icons.monetization_on),
        );
      },
    ));
  }
}

//Dialog pour recuperer les data entrer par utilisateur
class DialogDevise extends StatefulWidget {
  @override
  _DialogDeviseState createState() => _DialogDeviseState();
}

class _DialogDeviseState extends State<DialogDevise> {
  final TextEditingController _controllerCode = TextEditingController();
  final TextEditingController _controllerLib = TextEditingController();

  Future<DeviseModel> futureDeviceModels;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Align(
          alignment: Alignment.center,
          child: Text("DEVISE".toUpperCase(),
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
                //Code Devise
                TextField(
                  controller: _controllerCode,
                  decoration: InputDecoration(
                      labelText: "Code Devise ex: USD",
                      border: OutlineInputBorder()),
                ),
                SizedBox(height: 10),
                //Nom Devise
                TextField(
                  cursorColor: Theme.of(context).accentColor,
                  controller: _controllerLib,
                  decoration: InputDecoration(
                      labelText: "Nom Complet de Devise ex:Dollard",
                      border: OutlineInputBorder()),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      futureDeviceModels = createDevise(
                          _controllerCode.text.toUpperCase(),
                          _controllerLib.text.toUpperCase());
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
                    child: Text("Ajouter devise".toUpperCase(),
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          )
        ]);
  }
}
