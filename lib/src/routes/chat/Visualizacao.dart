//---- Packages
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import 'dart:async';

class Visualizacao extends StatefulWidget {
  Visualizacao(
      {Key key, this.titulo, this.imagem, this.id_user, this.table, this.name})
      : super(key: key);
  final String titulo;
  final String imagem;
  final int id_user;
  final String table;
  final String name;

  @override
  _VisualizacaoState createState() => _VisualizacaoState();
}

class _VisualizacaoState extends State<Visualizacao> {
  //---- Variables

  List mensagens = [];

  Map mensagem;

  String texto;

  var _streamController = StreamController<List>();
  var settings = mysql.ConnectionSettings(
      host: "", user: "", password: "", db: "", port: 0000);

  //---- Functions

  Future getMensagens() async {
    var conn = await mysql.MySqlConnection.connect(settings);
    mensagens = [];
    try {
      await conn
          .query("select * from ${widget.table}")
          .then((value) => value.forEach((element) {
                try {
                  //print("'Visualizacao.dart': Mensagem: ${element["conteudo"]}");
                  mensagem = {
                    "conteudo": element["conteudo"],
                    "nome": element["nome_user"],
                    "id_user": element["id_user"]
                  };
                  //mensagens.add(mensagem);
                  mensagens.insert(0, mensagem);
                } catch (e) {
                  print("'Visualizacao.dart': Não foi possível add");
                }
              }));
      if (mensagens.length == 0) {
        print("'Visualizacao.dart': Sem nenhuma mensagem");
      } else {
        print("'Visualizacao.dart': Com mensagem");
        conn.close();
        _streamController.add(mensagens);
        return mensagens;
      }
    } catch (e) {
      print(e);
    }
    mensagens = [];
  }

  Future addMensagens(content, id_user) async {
    var conn = await mysql.MySqlConnection.connect(settings);
    try {
      await conn.query("insert into ${widget.table} values (null, ?, ?, ?)",
          [content, widget.id_user, widget.name]);
      print("'Visualizacao.dart': Texto adicionado: $content");
    } catch (e) {
      print(e);
    }
  }

  void resetar() async {
    setState(() {
      mensagem = {};
      mensagens = [];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    print("----------------- VISUALIZACAO.DART -----------------");
    Timer.periodic(Duration(seconds: 4), (timer) {
      getMensagens();
    });

    _streamController = StreamController(onListen: () => getMensagens());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.grey[200],
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await addMensagens(texto, widget.id_user);
            resetar();
            await getMensagens();
          },
          child: Icon(Icons.chat),
        ),
        appBar: AppBar(
          title: Row(
            children: [
              ClipRRect(
                child: Image.asset(
                  "${widget.imagem}",
                  height: 45,
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.fill,
                  semanticLabel: "Imagem Grupo",
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text("${widget.titulo}"))
            ],
          ),
        ),
        body: StreamBuilder(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                    padding: EdgeInsets.only(bottom: 65),
                    child: ListView.builder(
                        itemCount: mensagens.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              mensagens[index]["nome"] == widget.name
                                  ? Padding(
                                      padding: EdgeInsets.only(left: 120),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Card(
                                            color: Colors.red[700],
                                            child: ListTile(
                                              title: Text(
                                                mensagens[index]["conteudo"],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              subtitle: Text(
                                                  mensagens[index]["nome"],
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            )),
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(right: 120),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Card(
                                            child: ListTile(
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                            child: Image.asset(
                                              "assets/python.png",
                                              width: 40,
                                            ),
                                          ),
                                          title: Text(
                                              mensagens[index]["conteudo"]),
                                          subtitle:
                                              Text(mensagens[index]["nome"]),
                                        )),
                                      ))
                            ],
                          );
                        }));
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        bottomSheet: ClipRRect(
            child: Row(children: [
          Container(
            padding: EdgeInsets.only(left: 10, bottom: 6),
            width: 400.0,
            child: TextField(
              maxLines: 100,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                texto = value;
                print("'Visualizacao.dart': Texto: $texto");
              },
              cursorColor: Colors.red,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "Digite aqui sua dúvida",
                  floatingLabelBehavior: FloatingLabelBehavior.never),
            ),
          ),
        ])));
  }
}

/*FutureBuilder(
          future: getMensagens(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: ListView.builder(
                      itemCount: mensagens.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(mensagens[index]["nome"]),
                          subtitle: Text("$index"),
                        );
                      }));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }), */
