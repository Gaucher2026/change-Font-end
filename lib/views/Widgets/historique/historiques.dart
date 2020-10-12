import 'package:echange/models/historique_action.dart';
import 'package:echange/services/historique_action_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Historique extends StatefulWidget {
  @override
  _HistoriqueState createState() => _HistoriqueState();
}

class _HistoriqueState extends State<Historique> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Historique"),
        actions: [
          IconButton(icon: Icon(Icons.search, color: Colors.white), onPressed: null)
        ],
      ),
      body: FutureBuilder<List<HistoriqueModelsActions>>(
        future: fetchHistoriqueAction(http.Client()),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            print(snapshot.error);
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return HistoriqueViews(historiqueMobile: snapshot.data);
          }
        },
      ),
    );
  }
}

//Liste des elements à afficher
class HistoriqueViews extends StatelessWidget {
  //attribue
  final List<HistoriqueModelsActions> historiqueMobile;

  const HistoriqueViews({Key key, this.historiqueMobile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
          itemCount: historiqueMobile.length,
          itemBuilder: (BuildContext context, i) {
            return ListTile(
              title: Text("${historiqueMobile[i].nom } ${historiqueMobile[i].prenom} "),
              subtitle: Text("${historiqueMobile[i].data} ${historiqueMobile[i].operation}"),
              leading: Icon(Icons.monetization_on),
            );
          },
        ));
  }
}
