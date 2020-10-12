import 'package:echange/models/taux_models.dart';
import 'package:echange/services/taux_api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class TauxRead extends StatefulWidget {
  @override
  _TauxStateRead createState() => _TauxStateRead();
}

class _TauxStateRead extends State<TauxRead> {
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
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 10.0),
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.all(10),
                color: Colors.grey,
                child: Center(
                  child: Text("HELLO WORD $index"),
                ),
              );
            }));
  }
}
