import 'package:flutter/material.dart';

class Accueil extends StatefulWidget {
  final Object donnee;

  const Accueil({Key key, this.donnee}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _Accueil(donnee);
  }
}

class _Accueil extends State<Accueil> {
  final donnee;
  int _selectAccueil = 0;
  String name = "";
  String prenom = "";

  //bool _extended = false;

  _Accueil(this.donnee);
  //void setExtended(bool isExtended) => setState(() => _extended = isExtended);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(this.donnee);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            child: Column(
          children: [
            Text('Nom : ${donnee.Nom}'),
            Text('Prenom : ${donnee.Prenom}'),
            Text('Pseudo : ${donnee.Pseudo}'),
            Text('Matricule : ${donnee.Matricule}'),
          ],
        )),
      ),
    );
  }
}
