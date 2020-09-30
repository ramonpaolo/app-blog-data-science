//---- Packages
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

//---- Screens
import 'package:data_science/src/navigation/Nav.dart';

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
//---- Variables

  final form = GlobalKey<FormState>();
  final snack = GlobalKey<ScaffoldState>();

  FontStyle format_text = FontStyle.normal;

  List<bool> _selections = List.generate(2, (index) => false);

  String titulo;
  String rapida_descricao;
  String descricao;
  String github;

  var settings =
      ConnectionSettings(host: "", user: "", password: "", db: "", port: 0000);

//---- Functions

  void connection(titulo, github, rapida_descricao, descricao, id_user) async {
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
    github = widget.github;
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
                TextField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                      labelText: "Digite o link do projeto no github*",
                      prefixText: "${widget.github}"),
                  onChanged: (context) {
                    github = context;
                    print(github);
                  },
                ),
                /*formulario(
                    TextInputType.url,
                    "Digite o link do projeto no github (opcional)",
                    "",
                    github),*/
                formulario(TextInputType.text, "Digite o Título",
                    "Título não informado", titulo),
                formulario(TextInputType.text, "Uma breve descrição",
                    "Breve descrição não informado", rapida_descricao),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(fontStyle: format_text),
                  minLines: 5,
                  enableInteractiveSelection: true,
                  maxLines: 8,
                  decoration: InputDecoration(labelText: "Descrição"),
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
                ToggleButtons(
                  children: [Icon(Icons.format_italic), Icon(Icons.fastfood)],
                  isSelected: _selections,
                  onPressed: (index) {
                    setState(() {
                      _selections[index] = !_selections[index];
                      if (_selections[0]) {
                        format_text = FontStyle.italic;
                      } else {
                        format_text = FontStyle.normal;
                      }
                    });
                  },
                  selectedColor: Colors.red,
                  color: Colors.black,
                ),
                Divider(
                  color: Colors.white,
                ),
                Tooltip(
                  message: "Fazer publicação desse artigo",
                  child: RaisedButton(
                      onPressed: () async {
                        if (form.currentState.validate()) {
                          await connection(titulo, widget.github + github,
                              rapida_descricao, descricao, widget.id_user);
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
                Text("* Opcional")
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
