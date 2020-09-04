import '../../navigation/Nav.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class AddConteudo extends StatefulWidget {
  AddConteudo({Key key, this.github, this.id_user}) : super(key: key);
  final int id_user;
  final String github;
  @override
  _AddConteudoState createState() => _AddConteudoState();
}

class _AddConteudoState extends State<AddConteudo> {
  final form = GlobalKey<FormState>();
  final snack = GlobalKey<ScaffoldState>();

  String titulo, rapida_descricao;
  String descricao;
  String github;

  void connection(titulo, github, rapida_descricao, descricao, id_user) async {
    var settings = ConnectionSettings();
    var conn = await MySqlConnection.connect(settings);
    var results = conn.query(
        "insert into conteudo (id_conteudo, title, github, rapida_descricao, descricao, id_user) values(null, ?,?,?,?,?)",
        [titulo, widget.github, rapida_descricao, descricao, id_user]);
    Navigator.of(context).pop();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Nav()));
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
                formutexto(
                  TextInputType.url,
                  "Digite o link do projeto no github (opcional)",
                  github,
                ),
                formulario(TextInputType.text, "Digite o Título",
                    "Título não informado", titulo),
                formulario(TextInputType.text, "Uma breve descrição",
                    "Breve descrição não informado", rapida_descricao),
                formulario(TextInputType.text, "Descrição",
                    "Descrição não informada", descricao),
                Tooltip(
                  message: "Fazer publicação desse artigo",
                  child: RaisedButton(
                      onPressed: () {
                        if (form.currentState.validate()) {
                          connection(titulo, github, rapida_descricao,
                              descricao, widget.id_user);
                        } else {
                          snack.currentState.showSnackBar(SnackBar(
                            content: Text("Algo de errado..."),
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
            print(titulo);
          } else if (text == rapida_descricao) {
            rapida_descricao = context;
            print(rapida_descricao);
          } else if (text == descricao) {
            descricao = context;
            print(descricao);
          }
        });
      },
      validator: (value) {
        if (value.isEmpty) {
          return "$error";
        }
        return null;
      },
      decoration: InputDecoration(labelText: "$texto"),
    );
  }

  Widget formutexto(TextInputType type, String texto, String variavel) {
    return TextField(
      keyboardType: type,
      onChanged: (value) {
        setState(() {
          variavel = value;
        });
      },
      decoration: InputDecoration(labelText: "$texto"),
    );
  }
}
