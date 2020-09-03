import 'package:blog_data_science/routes/visualizacao/Visualizacao.dart';
import 'package:flutter/material.dart';

class Data extends StatefulWidget {
  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  Map dado = {};

  List dados = [];

  @override
  void initState() {
    // TODO: implement initState
    dados.add(dado);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: dados.length,
        itemBuilder: (context, index) {
          return Hero(
              tag: dados[index]["time_pub"],
              child: GestureDetector(
                child: ListTile(
                  title: Text("Dados COVID-19"),
                  leading: CircleAvatar(
                    backgroundImage: AssetImage("assets/python.png"),
                  ),
                ),
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Visualizacao(
                                title: dados[index]["title"],
                                autor: dados[index]["autor"],
                              )));
                },
              ));
        });
  }
}
