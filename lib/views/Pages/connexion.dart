import 'package:echange/views/Pages/index.dart';
import 'package:echange/views/Pages/inscription.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  final String message;
  Login({Key key, this.message = ""}) : super(key: key);
  @override
  _LoginState createState() => _LoginState(message);
}

class _LoginState extends State<Login> {
  final _fromKey = GlobalKey<FormState>();
  final String message;
  String _controllerPseudo = "";
  String _controllerPassword = "";

  _LoginState(this.message);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Center(
          child: Container(
        color: Colors.white,
        width: 350,
        height: 450,
        child: Column(
          children: [
            imageEntreprise(),
            SizedBox(height: 5),
            nameFormulaire(),
            SizedBox(height: 5),
            formulaire(),
          ],
        ),
      )),
    );
  }

  //Logo entreprise
  Widget imageEntreprise() {
    return Container(
      width: 80,
      height: 80,
      child: Image.asset("images/a.png"),
    );
  }

  //Name entreprise
  Widget nameFormulaire() {
    // ignore: deprecated_member_use
    return Text("Please sign in", style: Theme.of(context).textTheme.display1);
  }

  //Formulaire
  Widget formulaire() {
    return Form(
        key: _fromKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 180,
              padding: EdgeInsets.only(left: 5),
              child: Column(
                children: [
                  //Pseudo
                  TextFormField(
                    autocorrect: true,
                    // ignore: missing_return
                    validator: (pseudo) {
                      if (pseudo.isEmpty) {
                        return "remplissez ce champs";
                      } else {
                        setState(() => _controllerPseudo = pseudo);
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Pseudo",
                        labelText: "Pseudo",
                        helperStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        helperText: ""),
                  ),
                  SizedBox(height: 5),
                  //Password
                  TextFormField(
                    autocorrect: true,
                    // ignore: missing_return
                    validator: (password) {
                      if (password.isEmpty) {
                        return "remplissez ce champs";
                      } else {
                        setState(() => _controllerPassword = password);
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Password",
                        labelText: "Password",
                        helperStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        helperText: ""),
                  ),
                ],
              ),
            ),
            Text("$message"),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                _fromKey.currentState.validate()
                    ? signIn(_controllerPseudo, _controllerPassword)
                    : Text("");
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).accentColor,
                ),
                width: MediaQuery.of(context).size.width,
                height: 45,
                child: Center(
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w200,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return Inscription();
                }));
              },
              child: Center(
                child: Text("INSCRIVEZ-VOUS"),
              ),
            )
          ],
        ));
  }

  signIn(String pseudo, String password) async {
    Map data = {'pseudo': pseudo, 'password': password};
    print(data);
    var response = await http
        .post("http://localhost:3000/api/v1/change/user/login", body: data);
    if (response.statusCode == 200) {
      setState(() {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return Index(myToken: response.body);
        }));
      });
    } else {
      setState(() {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return Login(message: "Verifiez votre Pseudo ou Password");
        }));
      });
    }
  }
}
