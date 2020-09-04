import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import 'package:url_launcher/url_launcher.dart';
import './Edit.dart';

class Users extends StatefulWidget {
  Users({Key key, this.email, this.github, this.likedin}) : super(key: key);
  final String github;
  final String likedin;
  final String email;

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  Map user = {};

  Future<dynamic> getFutureDados() async {
    var settings = mysql.ConnectionSettings(
      host: "",
      user: "",
      password: "",
      db: "",
      port: 0000,
    );
    var conn = await mysql.MySqlConnection.connect(settings);
    var results = conn.query("select * from users where id_user = 1");
    await results
        .then((value) => {
              value.forEach((element) {
                if (element["id_user"] != user["id"])
                  return user = {
                    "id": element["id_user"],
                    "name": element["nome"],
                    "email": element["email"],
                    "github": element["github"],
                    "linkedin": element["linkedin"]
                  };
              })
            })
        .catchError((onError) => print("Errorr: ${onError}"));

    conn.close();
    return user;
  }

  void launcher(url) async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      launch("https://youtube.com");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: EdgeInsets.all(20),
      child: Container(
          child: FutureBuilder(
              initialData: "Aguarde",
              future: getFutureDados(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Center(
                          child: ClipRRect(
                        child: Image.asset(
                          "assets/python.png",
                          width: 90,
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(105),
                      )),
                      Text(
                        "Nome: ${user["name"]}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      Text(
                        "Email: ${user["email"]}",
                        style: TextStyle(fontSize: 18),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Tooltip(
                              message: "Ver GitHub",
                              child: RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    launcher(user["github"]);
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(left: 50, right: 40),
                                  child: Text(
                                    "GitHub",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                color: Colors.black,
                              ),
                            ),
                            Tooltip(
                                message: "Ver Linkedin",
                                child: RaisedButton(
                                  onPressed: () {
                                    setState(() {
                                      launcher(user["linkedin"]);
                                    });
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 40, right: 40),
                                    child: Text(
                                      "Linkedin",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  color: Colors.blue,
                                ))
                          ],
                        ),
                      ),
                      Tooltip(
                        message: "Mudar informações",
                        child: RaisedButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Edit(
                                          github: user["github"],
                                          linkedin: user["linkedin"],
                                          email: user["email"],
                                          id: user["id"],
                                        )));
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Editar",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              })),
    ));
  }
}
