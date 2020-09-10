import '../../navigation/Nav.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class AddConteudo extends StatefulWidget {
  AddConteudo({Key key, this.github, this.id_user, this.email})
      : super(key: key);
  final int id_user;
  final String github;
  final String email;
  @override
  _AddConteudoState createState() => _AddConteudoState();
}

class _AddConteudoState extends State<AddConteudo> {
  final form = GlobalKey<FormState>();
  final snack = GlobalKey<ScaffoldState>();

  String titulo;
  String rapida_descricao;
  String descricao;
  String github;

  void connection(titulo, github, rapida_descricao, descricao, id_user) async {
    print("Funcao $github");
    var settings = ConnectionSettings(
      host: "mysql669.umbler.com",
      user: "ramon_paolo",
      password: "familiAMaram12.",
      db: "data-science",
      port: 41890,
    );
    var conn = await MySqlConnection.connect(settings);
    conn.query(
        "insert into conteudo (id_conteudo, title, github, rapida_descricao, descricao, id_user) values(null,?,?,?,?,?)",
        [titulo, github, rapida_descricao, descricao, widget.id_user]);
    print("Query $github");
    Navigator.of(context).pop();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Nav(
                  email: widget.email,
                  github: github,
                )));
  }

  @override
  void initState() {
    // TODO: implement initState
    print("----------------- ADD-CONTEUDO.DART -----------------");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: snack,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Adicionar Conteúdo"),
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                formulario(
                    TextInputType.url,
                    "Digite o link do projeto no github (opcional)",
                    "",
                    github),
                formulario(TextInputType.text, "Digite o Título",
                    "Título não informado", titulo),
                formulario(TextInputType.text, "Uma breve descrição",
                    "Breve descrição não informado", rapida_descricao),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: 8,
                  decoration: InputDecoration(labelText: "Descrição"),
                  onChanged: (value) {
                    setState(() {
                      descricao = value;
                      print(descricao);
                    });
                  },
                ),
                Tooltip(
                  message: "Fazer publicação desse artigo",
                  child: RaisedButton(
                      onPressed: () async {
                        if (form.currentState.validate()) {
                          print("Form: $github");
                          await connection(titulo, github, rapida_descricao,
                              descricao, widget.id_user);
                        } else {
                          snack.currentState.showSnackBar(SnackBar(
                            content: Text("Campos invalidos"),
                            duration: Duration(seconds: 2),
                          ));
                        }
                      },
                      child: Text(
                        "Fazer Publicação",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            ),
          ),
        ))));
  }

  Widget formulario(
    TextInputType type,
    String texto,
    String error,
    String text,
  ) {
    return TextFormField(
      keyboardType: type,
      onChanged: (context) {
        setState(() {
          if (text == titulo) {
            titulo = context;
            print("Título: $titulo");
          } else if (text == rapida_descricao) {
            rapida_descricao = context;
            print("Rápida descrição: $rapida_descricao");
          } else if (text == github) {
            github = context;
            print("Github: $github");
          }
        });
      },
      validator: (value) {
        if (error != "") {
          if (value.isEmpty) {
            return "$error";
          }
        }
      },
      decoration: InputDecoration(labelText: "$texto"),
    );
  }
}
