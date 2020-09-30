//---- Packages
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//---- Screens
import 'package:data_science/src/routes/user/Edit.dart';

class Users extends StatefulWidget {
  Users(
      {Key key,
      this.email,
      this.nome,
      this.github,
      this.id,
      this.linkedin,
      this.descricao})
      : super(key: key);
  final String email;
  final String nome;
  final String github;
  final String linkedin;
  final String id;
  final String descricao;

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
//---- Variables

  Map user = {};

//---- Functions

  Future getDados() async {
    return [
      user["nome"] = widget.nome,
      user["email"] = widget.email,
      user["github"] = widget.github,
      user["linkedin"] = widget.linkedin,
      user["descricao"] = widget.descricao,
      user["id"] = widget.id.toString()
    ];
  }

  void launcher(url) async {
    if (await canLaunch("$url")) {
      launch(url);
    } else {
      launch("https://youtube.com");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print("----------------- USER.DART -----------------");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: EdgeInsets.all(20),
      child: Container(
          child: FutureBuilder(
              initialData: "Aguarde",
              future: getDados(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Center(
                        child: ClipRRect(
                          child: Image.asset(
                            "assets/python.png",
                            width: 150,
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(105),
                        ),
                      ),
                      Divider(
                        height: 40,
                        color: Colors.white,
                      ),
                      Text(
                        "Nome: ${user["nome"]}",
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
                              message: "Abrir GitHub",
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
                                message: "Abrir Linkedin",
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
                      Divider(
                        color: Colors.white,
                        height: 20,
                      ),
                      Text(
                        "Sobre mim: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text("${user["descricao"]}",
                          style: TextStyle(
                              fontSize: 16, fontStyle: FontStyle.italic)),
                      Divider(
                        color: Colors.white,
                        height: 20,
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
                                          nome: user["nome"],
                                          descricao: user["descricao"],
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
                  return Center(child: CircularProgressIndicator());
                }
              })),
    ));
  }
}
