import 'dart:convert';
import 'dart:ui';
import 'package:echange/models/taux_models.dart';
import 'package:echange/services/api.dart';
import 'package:echange/views/Pages/listViews.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Index extends StatefulWidget{
  final myToken;

  const Index({Key key, this.myToken}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _Index(myToken);
  }
}
class _Index extends State<Index> {
  final myToken;
  int _selectIndex = 0;
  String name = "";
  String prenom = "";
  //bool _extended = false;
  

  _Index(this.myToken);
  //void setExtended(bool isExtended) => setState(() => _extended = isExtended);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            backgroundColor: Colors.black,
            selectedLabelTextStyle:
                TextStyle(color: Theme.of(context).primaryColor),
            unselectedLabelTextStyle: TextStyle(color: Colors.white),
            selectedIconTheme:
                IconThemeData(color: Theme.of(context).primaryColor),
            unselectedIconTheme: IconThemeData(color: Colors.white),
            leading: ExtendableFab(name: name,prenom: prenom),
            extended: true,
            selectedIndex: _selectIndex,
            onDestinationSelected: (int index) =>
                setState(() => _selectIndex = index),
            labelType: NavigationRailLabelType.none,
            destinations: [
              //Compte
              NavigationRailDestination(
                  icon: Icon(Icons.money_off),
                  selectedIcon: Icon(Icons.money_off),
                  label: Text('Compte')),
              //Approvisionnement
              NavigationRailDestination(
                  icon: Icon(Icons.account_balance_wallet),
                  selectedIcon: Icon(Icons.account_balance_wallet),
                  label: Text('Approvisionnement')),
              //Versement
              NavigationRailDestination(
                  icon: Icon(Icons.account_balance),
                  selectedIcon: Icon(Icons.account_balance),
                  label: Text('Versement')),
              //Operation de change
              NavigationRailDestination(
                  icon: Icon(Icons.attach_money),
                  selectedIcon: Icon(Icons.attach_money),
                  label: Text('Opération de change')),
              //Historique
              NavigationRailDestination(
                  icon: Icon(Icons.history),
                  selectedIcon: Icon(Icons.history),
                  label: Text('Historique')),
              //Taux
              NavigationRailDestination(
                  icon: Icon(Icons.check_box_outline_blank),
                  selectedIcon: Icon(Icons.check_box_outline_blank),
                  label: Text('Taux')),
              //Devise
              NavigationRailDestination(
                  icon: Icon(Icons.call_missed_outgoing),
                  selectedIcon: Icon(Icons.call_missed_outgoing),
                  label: Text('Devise')),
              //Deconnexion
              NavigationRailDestination(
                  icon: Icon(Icons.content_cut),
                  selectedIcon: Icon(Icons.content_cut),
                  label: Text('Deconnexion')),
            ],
          ),
          VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          Expanded(
            child: widgets[_selectIndex],
          )
        ],
      ),
    );
  }
  Widget viewsData(data) {
    print("Heeeee sael");
    final List<TauxModel> compteMobile = data;
    return Container(
        child: ListView.builder(
      itemCount: compteMobile.length,
      itemBuilder: (BuildContext context, i) {
        return ListTile(
          title: Text(
              "${compteMobile[i].codeOrigine} => ${compteMobile[i].codeEchange} "),
          subtitle: Text("${compteMobile[i].taux}"),
          leading: Icon(Icons.monetization_on),
        );
      },
    ));
  }
  tokenIn()async{
    print(myToken);
    var response = await http.get("$url_base/user/id",headers:{
      'auth-token': myToken,
    });
    if(response.statusCode == 201){
      var user = jsonDecode(response.body);
      print(user);
      setState(() {
        name = user['nom'];
        prenom = user['prenom'];
      });
    }else{
      print("Probleme dfdhgfdkjkdjfkdfj");
    }
  }

}
  

class ExtendableFab extends StatelessWidget{
  final String name;
  final String prenom;

  const ExtendableFab({Key key, this.name, this.prenom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation =
        NavigationRail.extendedAnimation(context);
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        // The extended fab has a shorter height than the regular fab.
        return Container(
          height: 56,
          padding: EdgeInsets.symmetric(
            vertical: lerpDouble(0, 6, animation.value),
          ),
          child: animation.value == 0
              ? FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(Icons.person),
                  onPressed: () {},
                )
              : Align(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: animation.value,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8),
                    child: FloatingActionButton.extended(
                      backgroundColor: Theme.of(context).primaryColor,
                      icon: Icon(Icons.person),
                      label: Text('$name $prenom'),
                      onPressed: () {},
                    ),
                  ),
                ),
        );
      },
    );
  }
}