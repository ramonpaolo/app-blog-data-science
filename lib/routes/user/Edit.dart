import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class Edit extends StatefulWidget {
  Edit({Key key, this.email, this.github, this.linkedin, this.id})
      : super(key: key);
  final String email;
  final String github;
  final String linkedin;
  final String id;

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  final key = GlobalKey<FormState>();

  String email;
  String github;
  String linkedin;
  bool snack = false;

  Future connection(id, email, github, linkedin) async {
    var settings = ConnectionSettings();
    var conn = await MySqlConnection.connect(settings);
    var results = await conn
        .query("update users set github = ? where id_user = ?", [github, id]);
    results = await conn
        .query("update users set email = ? where id_user = ?", [email, id]);
    results = await conn.query(
        "update users set linkedin = ? where id_user = ?", [linkedin, id]);
    conn.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    email = widget.email;
    github = widget.github;
    linkedin = widget.linkedin;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Editar perfil"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Container(
          child: Center(
              child: Form(
            key: key,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Aviso!",
                      style: TextStyle(fontSize: 28, color: Colors.red)),
                  Text(
                    "Tome cuidado ao editar seus dados. Caso aconteça algo, pode até perder a conta",
                    style: TextStyle(fontSize: 18),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  formulario(TextInputType.emailAddress, email, "Email", email),
                  formulario(TextInputType.url, github, "Github", github),
                  formulario(TextInputType.url, linkedin, "Linkedin", linkedin),
                  RaisedButton(
                    onPressed: () {
                      if (key.currentState.validate()) {
                        connection(widget.id, email, github, linkedin);

                        return Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "Atualizar Dados",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  snack == true
                      ? Text(
                          "Para poder ver as mudanças em seu perfil, será nessesário reiniciar o aplicativo")
                      : Text("")
                ],
              ),
            ),
          )),
        )));
  }

  Widget formulario(
      TextInputType type, String valueInit, String texto, String variavel) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return "Está vazio";
        }
      },
      onChanged: (context) {
        snack = true;
        setState(() {
          if (variavel == github) {
            github = context;
            print("Github: " + github);
          } else if (variavel == email) {
            email = context;
            print("Email: " + email);
          } else if (variavel == linkedin) {
            linkedin = context;
            print("Linkedin: " + linkedin);
          }
        });
      },
      keyboardType: type,
      initialValue: valueInit,
      decoration: InputDecoration(labelText: texto),
    );
  }
}
