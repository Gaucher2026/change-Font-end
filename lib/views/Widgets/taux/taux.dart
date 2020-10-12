import 'package:echange/views/Widgets/taux/createTaux.dart';
import 'package:echange/views/Widgets/taux/readTaux.dart';
import 'package:flutter/material.dart';

class Taux extends StatefulWidget {
  @override
  _TauxState createState() => _TauxState();
}
List<Widget> choise = [
  TauxCreate(),
  TauxRead()
];

class _TauxState extends State<Taux>{
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: choise.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
              isScrollable: true,
              tabs: [
                Text("data1"),
                Text("data2")
              ]),
        ),
        body: TabBarView(children: choise),
      ),
    );
  }
}
