import 'dart:async';
import 'package:echange/models/connexion_models.dart';
import 'package:echange/services/connexion_api.dart';
import 'package:echange/views/Pages/index.dart';
import 'package:flutter/material.dart';

class Album {
  final int id;
  final String title;

  Album({this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
    );
  }
}

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _Login createState() {
    return _Login();
  }
}

class _Login extends State<Login> {
  final TextEditingController _controllerMatricule = TextEditingController();

  final TextEditingController _controllerPassword = TextEditingController();

  final String message = "";

  Future<ConnexionModel> _futureConnexion;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Create Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futureConnexion == null)
              ? Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text("CONNEXION",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900)),
                    ),
                    SizedBox(height: 20),
                    //Matricule
                    TextField(
                      controller: _controllerMatricule,
                      decoration: InputDecoration(
                          labelText: "Votre Matricule",
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 10),
                    //Password
                    TextField(
                      controller: _controllerPassword,
                      cursorColor: Colors.blue,
                      decoration: InputDecoration(
                          labelText: "Password", border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 5),
                    Text("$message"),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _futureConnexion = createConnexion(
                              _controllerMatricule.text,
                              _controllerPassword.text);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue,
                        ),
                        alignment: Alignment.center,
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Text("CONNEXION",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                )
              : FutureBuilder<ConnexionModel>(
                  future: _futureConnexion,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Index();
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return CircularProgressIndicator();
                  },
                ),
        ),
      ),
    );
  }
}

/*
import 'package:echange/models/connexion_models.dart';
import 'package:echange/services/connexion_api.dart';
import 'package:echange/views/Pages/connexion.dart';
import 'package:echange/views/Pages/home_page.dart';
import 'package:flutter/material.dart';

class TraitementConnexionState extends StatelessWidget {
  final String matricule;
  final String password;
  Future<ConnexionModel> _futureConnexion;

  const TraitementConnexionState({Key key, this.matricule, this.password})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: (_futureConnexion == null)
            ? Center(
                child: setState(() {
                  _futureConnexion = createConnexion(_controller.text);
                }),
              )
            : FutureBuilder<ConnexionModel>(
                future: _futureConnexion,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return HomePage();
                  } else if (snapshot.hasError) {
                    return Login(
                        message: "Votre Matricule ou Password est incorrect");
                  }
                  return CircularProgressIndicator();
                },
              ),
      ),
    );
  }
}
*/

/*
 RaisedButton(
                      child: Text('Create Data'),
                      onPressed: () {
                        setState(() {
                          _futureAlbum = createAlbum(_controller.text);
                        });
                      },
                    ),*/
