//---- Packages
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class Edit extends StatefulWidget {
  Edit(
      {Key key,
      this.email,
      this.github,
      this.linkedin,
      this.id,
      this.nome,
      this.descricao})
      : super(key: key);
  final String email;
  final String github;
  final String linkedin;
  final String id;
  final String nome;
  final String descricao;

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
//---- Variables

  bool snack = false;

  final key = GlobalKey<FormState>();

  String email;
  String github;
  String linkedin;
  String nome;
  String descricao;

  var settings =
      ConnectionSettings(host: "", user: "", password: "", db: "", port: 0000);

//---- Functions

  Future connection(id, email, github, linkedin, nome, descricao) async {
    var conn = await MySqlConnection.connect(settings);
    await conn
        .query("update users set github = ? where id_user = ?", [github, id]);
    await conn
        .query("update users set email = ? where id_user = ?", [email, id]);
    await conn.query(
        "update users set linkedin = ? where id_user = ?", [linkedin, id]);
    await conn.query("update users set nome = ? where id_user = ?", [nome, id]);
    await conn.query(
        "update users set descricao = ? where id_user = ?", [descricao, id]);
    await conn.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    print("----------------- EDIT.DART -----------------");
    email = widget.email;
    github = widget.github;
    linkedin = widget.linkedin;
    nome = widget.nome;
    descricao = widget.descricao;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                  formulario(TextInputType.name, nome, "Nome", nome),
                  formulario(TextInputType.emailAddress, email, "Email", email),
                  formulario(TextInputType.url, github, "Github", github),
                  formulario(TextInputType.url, linkedin, "Linkedin", linkedin),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 10,
                    initialValue: descricao,
                    onChanged: (value) {
                      setState(() {
                        descricao = value;
                        print(descricao);
                      });
                    },
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (key.currentState.validate()) {
                        connection(widget.id, email, github, linkedin, nome,
                            descricao);

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
          } else if (variavel == nome) {
            nome = context;
            print("Nome: " + nome);
          } else if (variavel == descricao) {
            descricao = context;
            print("Descricao: " + descricao);
          }
        });
      },
      keyboardType: type,
      initialValue: valueInit,
      decoration: InputDecoration(labelText: texto),
    );
  }
}
