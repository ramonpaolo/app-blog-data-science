//---- Packages
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Perfil extends StatelessWidget {
  Perfil({Key key, this.user}) : super(key: key);
//---- Variables

  final Map user;

//---- Functions

  void launcher(url) async {
    try {
      launch(url);
    } catch (e) {
      print("'Perfil.dart': Não pode acessar a url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Voltar"),
        ),
        body: SingleChildScrollView(
          child: Container(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                ClipRRect(
                  child: Image.asset(
                    "assets/google.jpg",
                    width: 250,
                  ),
                  borderRadius: BorderRadius.circular(120),
                ),
                Divider(
                  color: Colors.white,
                ),
                Text(
                  user["nome"],
                  style: TextStyle(fontSize: 24),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Email: ",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      user["email"],
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                            color: Colors.black,
                            padding: EdgeInsets.only(left: 70, right: 70),
                            onPressed: () {
                              launcher(user["github"]);
                            },
                            child: Text(
                              "GitHub",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            )),
                        RaisedButton(
                          color: Colors.blue,
                          padding: EdgeInsets.only(left: 65, right: 65),
                          onPressed: () {
                            launcher(user["linkedin"]);
                          },
                          child: Text("Linkedin",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                        )
                      ],
                    )),
              ],
            ),
          )),
        ));
  }
}
