import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../routes/visualizacao/Visualizacao.dart';
import 'package:mysql1/mysql1.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final conn = MySqlConnection.connect(null);
  Map projeto = {};
  List projetos = [];

  Future<dynamic> getFutureDados() async {
    var settings = ConnectionSettings(
      host: "",
      user: "",
      password: "",
      db: "",
      port: 0000,
    );
    var conn = await MySqlConnection.connect(settings);
    var results = conn.query("select * from conteudo");
    await results
        .then((value) => {
              value.forEach((element) {
                print(element);
                projeto = {
                  "id": element["id_conteudo"].toString(),
                  "title": element["title"].toString(),
                  "fast_describe": element["rapida_descricao"].toString(),
                  "describe": element["descricao"].toString(),
                  "github": element["github"].toString(),
                };
                projetos.add(projeto);
              })
            })
        .catchError((onError) => print("Errorr: ${onError}"));

    conn.close();
    return projetos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: "Mostrar mais",
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
                        child: Hero(
                            tag: projetos[index]
                                ["id"], //DateTime.now().millisecond
                            child: GestureDetector(
                                child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/python.png"),
                              ),
                              title: Text(projetos[index]['title'].toString()),
                              subtitle: Text(
                                  projetos[index]['fast_describe'].toString()),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Visualizacao(
                                            id_post: projetos[index]["id"],
                                            title: projetos[index]["title"],
                                            fast_describe: projetos[index]
                                                ["fast_describe"],
                                            github: projetos[index]["github"],
                                            describe: projetos[index]
                                                ["describe"],
                                            autor: "Ramon ",
                                          ))),
                            ))));
                  });
            } else {
              return CupertinoActivityIndicator();
            }
          },
        ));
  }
}
