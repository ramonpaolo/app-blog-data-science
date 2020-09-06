import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../routes/visualizacao/Visualizacao.dart';
import 'package:mysql1/mysql1.dart';
import '../../navigation/Nav.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map projeto = {};
  List projetos = [];
  List projetosPerson = [];
  Map projetoPerson = {};
  int valor = 0;
  int limite = 15;

  Future<dynamic> getFutureDados() async {
    var settings = ConnectionSettings(
      
    );
    var conn = await MySqlConnection.connect(settings);
    var results = conn.query("select * from conteudo");
    await results
        .then((value) => {
              value.forEach((element) {
                valor += 1;
                if (valor <= limite) {
                  //print("Conteúdo Json: $element");
                  projeto = {
                    "id": element["id_conteudo"].toString(),
                    "title": element["title"].toString(),
                    "fast_describe": element["rapida_descricao"].toString(),
                    "describe": element["descricao"].toString(),
                    "github": element["github"].toString(),
                    "criacao": element["criacao"].toString(),
                    "id_user": element["id_user"].toString()
                  };
                  projetos.add(projeto);
                }
              })
            })
        .catchError((onError) => print("Errorr: ${onError}"));
    valor = 0;
    projetos.forEach((element) {
      print(element);
      var resultsPerson = conn.query("select * from users where id_user = ?", [
        element["id_user"]
      ]).then((value) => value.forEach((element) {
            projetoPerson = {"nome": element["nome"]};
            projetosPerson.add(projetoPerson);
          }));
    });

    // conn.close();
    return projetos;
  }

  Future aumentarVisualizacao() async {
    projetos = [];
    limite += 15;
    valor = 0;
  }

  @override
  Widget build(BuildContext context) {
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
        body: FutureBuilder(
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
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Nav()));
                        },
                        child: Text("Recarregar tela"),
                      )
                    ],
                  )
                ],
              ));
            }
          },
        ));
  }
}
