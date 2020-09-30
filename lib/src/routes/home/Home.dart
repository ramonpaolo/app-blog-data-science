//----
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import 'dart:async';

//---- Screens
import 'package:data_science/src/navigation/Nav.dart';
import 'package:data_science/src/routes/visualizacao/Visualizacao.dart';

class Home extends StatefulWidget {
  Home({Key key, this.grid}) : super(key: key);
  final bool grid;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //---- Variables

  final _streamController = StreamController();

  int valor = 0;
  int limite = 15;

  List projetos = [];
  List projetosPerson = [];

  Map projeto = {};
  Map projetoPerson = {};

  var settings = mysql.ConnectionSettings(
      host: "", user: "", password: "", db: "", port: 0000);
  //---- Variables

  Future<dynamic> getFutureData() async {
    var conn = await mysql.MySqlConnection.connect(settings);
    var results = conn.query("select * from conteudo");
    await results
        .then((value) => {
              value.forEach((element) {
                valor += 1;
                if (valor <= limite) {
                  projeto = {
                    "id": element["id_conteudo"].toString(),
                    "title": element["title"].toString(),
                    "fast_describe": element["rapida_descricao"].toString(),
                    "describe": element["descricao"].toString(),
                    "github": element["github"].toString(),
                    "id_user": element["id_user"].toString()
                  };
                  projetos.insert(0, projeto);
                  setState(() {
                    _streamController.add(projeto);
                  });
                }
              })
            })
        .catchError((onError) => print("Errorr: ${onError}"));
    valor = 0;
    projetos.forEach((element) {
      conn.query("select * from users where id_user = ?", [
        element["id_user"]
      ]).then((value) => value.forEach((element) {
            projetoPerson = {"nome": element["nome"]};
            projetosPerson.add(projetoPerson);
          }));
    });
    return projetos;
  }

  void aumentarVisualizacao() async {
    projetos.clear();
    limite += 15;
    valor = 0;
  }

  @override
  void initState() {
    // TODO: implement initState
    print("----------------- HOME.DART -----------------");
    getFutureData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              aumentarVisualizacao();
            });
          },
          tooltip: "Mostrar publicação mais antigas",
          child: Icon(Icons.refresh),
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              projetos.clear();
              await getFutureData();
            },
            child: StreamBuilder(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  print("'Home.dart': Feito");
                } else if (snapshot.connectionState == ConnectionState.none) {
                  print("'Home.dart': Nada");
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  print("'Home.dart': Carregando");
                } else if (snapshot.connectionState == ConnectionState.active) {
                  print("'Home.dart': Ativo");
                }
                if (snapshot.connectionState == ConnectionState.active) {
                  return ListView.builder(
                      itemCount: projetos.length,
                      itemBuilder: (context, index) {
                        return widget.grid
                            ? Card(
                                child: GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Visualizacao(
                                                  id_post: projetos[index]
                                                      ["id"],
                                                  id_user: projetos[index]
                                                      ["id_user"],
                                                  title: projetos[index]
                                                      ["title"],
                                                  fast_describe: projetos[index]
                                                      ["fast_describe"],
                                                  github: projetos[index]
                                                      ["github"],
                                                  describe: projetos[index]
                                                      ["describe"],
                                                  autor: projetosPerson[index]
                                                      ["nome"],
                                                ))),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/python.png",
                                          height: 100,
                                          filterQuality: FilterQuality.high,
                                        ),
                                        ListTile(
                                          title: Text(projetos[index]['title']
                                              .toString()),
                                          subtitle: Text(projetos[index]
                                                  ['fast_describe']
                                              .toString()),
                                        )
                                      ],
                                    )))
                            : Row(
                                children: [
                                  SizedBox(
                                      width: size.width * 0.5,
                                      height: size.height * 0.22,
                                      child: Card(
                                          child: GestureDetector(
                                              onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Visualizacao(
                                                            id_post:
                                                                projetos[index]
                                                                    ["id"],
                                                            id_user:
                                                                projetos[index]
                                                                    ["id_user"],
                                                            title:
                                                                projetos[index]
                                                                    ["title"],
                                                            fast_describe:
                                                                projetos[index][
                                                                    "fast_describe"],
                                                            github:
                                                                projetos[index]
                                                                    ["github"],
                                                            describe: projetos[
                                                                    index]
                                                                ["describe"],
                                                            autor:
                                                                projetosPerson[
                                                                        index]
                                                                    ["nome"],
                                                          ))),
                                              child: Column(
                                                children: [
                                                  Image.asset(
                                                    "assets/python.png",
                                                    height: 50,
                                                    filterQuality:
                                                        FilterQuality.high,
                                                  ),
                                                  ListTile(
                                                    title: Text(projetos[index]
                                                            ['title']
                                                        .toString()),
                                                    subtitle: Text(projetos[
                                                                index]
                                                            ['fast_describe']
                                                        .toString()),
                                                  )
                                                ],
                                              )))),
                                  SizedBox(
                                      width: size.width * 0.5,
                                      height: size.height * 0.22,
                                      child: Card(
                                          child: GestureDetector(
                                              onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Visualizacao(
                                                            id_post:
                                                                projetos[index]
                                                                    ["id"],
                                                            id_user:
                                                                projetos[index]
                                                                    ["id_user"],
                                                            title:
                                                                projetos[index]
                                                                    ["title"],
                                                            fast_describe:
                                                                projetos[index][
                                                                    "fast_describe"],
                                                            github:
                                                                projetos[index]
                                                                    ["github"],
                                                            describe: projetos[
                                                                    index]
                                                                ["describe"],
                                                            autor:
                                                                projetosPerson[
                                                                        index]
                                                                    ["nome"],
                                                          ))),
                                              child: Column(
                                                children: [
                                                  Image.asset(
                                                    "assets/python.png",
                                                    height: 50,
                                                    filterQuality:
                                                        FilterQuality.high,
                                                  ),
                                                  ListTile(
                                                    title: Text(projetos[index]
                                                            ['title']
                                                        .toString()),
                                                    subtitle: Text(projetos[
                                                                index]
                                                            ['fast_describe']
                                                        .toString()),
                                                  )
                                                ],
                                              )))),
                                ],
                              );
                      });
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AlertDialog(
                        content: Text("Sem conexão com a internet"),
                        actions: [
                          RaisedButton(
                            onPressed: () {},
                            child: Text("Ok"),
                          ),
                          RaisedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Nav()));
                            },
                            child: Text("Recarregar tela"),
                          )
                        ],
                      )
                    ],
                  ));
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )));
  }
}

/*FutureBuilder(
              initialData: "Aguarde",
              future: getFutureDados(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: projetos.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: GestureDetector(
                                child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage("assets/python.png"),
                          ),
                          title: Text(projetos[index]['title'].toString()),
                          subtitle:
                              Text(projetos[index]['fast_describe'].toString()),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Visualizacao(
                                        id_post: projetos[index]["id"],
                                        title: projetos[index]["title"],
                                        fast_describe: projetos[index]
                                            ["fast_describe"],
                                        github: projetos[index]["github"],
                                        describe: projetos[index]["describe"],
                                        autor: projetosPerson[index]["nome"],
                                      ))),
                        )));
                      });
                } else if (snapshot.hasError) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AlertDialog(
                        content: Text("Sem conexão com a internet"),
                        actions: [
                          RaisedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Ok"),
                          ),
                          RaisedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Nav()));
                            },
                            child: Text("Recarregar tela"),
                          )
                        ],
                      )
                    ],
                  ));
                }
              },
            ) */
