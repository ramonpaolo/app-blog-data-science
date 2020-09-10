import 'package:flutter/material.dart';
import './Visualizacao.dart';

class Chat extends StatefulWidget {
  Chat({Key key, this.id_user}) : super(key: key);
  final int id_user;
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List grupos = [
    {
      "nome": "Dúvidas Python",
      "qts_user": "10",
      "bd": "d_p",
      "imagem": "assets/python.png",
      "descricao": "Grupo para tirar dúvidas de Python no geral"
    },
    {
      "nome": "Dúvidas R",
      "qts_user": "8",
      "bd": "d_r",
      "imagem": "assets/r.jpeg",
      "descricao": "Grupo para tirar dúvidas de R no geral"
    },
    {
      "nome": "Dúvidas Machine Learning",
      "qts_user": "10",
      "bd": "d_ml",
      "imagem": "assets/machine.png",
      "descricao":
          "Grupo para Dúvidas de Machine Learning(Scikit-learn, KNN, ...)"
    },
    {
      "nome": "Dúvidas Deep Learning",
      "qts_user": "10",
      "bd": "d_pl",
      "imagem": "assets/deep.png",
      "descricao": "Grupo para Dúvidas de Deep Learning(Tensorflow, spark, ...)"
    },
    {
      "nome": "Networking",
      "qts_user": "10",
      "bd": "n",
      "imagem": "assets/social.png",
      "descricao": "Grupo para ajudar você a construir seu Networking :)"
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    print("----------------- CHAT.DART -----------------");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: grupos.length,
        itemBuilder: (context, index) {
          return SizedBox(
              height: 90,
              child: Card(
                child: ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Visualizacao(
                                  titulo: grupos[index]["nome"],
                                  imagem: grupos[index]["imagem"],
                                  id_user: widget.id_user,
                                  table: grupos[index]["bd"],
                                ))),
                    title: Text(grupos[index]["nome"]),
                    subtitle: Text(grupos[index]["descricao"]),
                    leading: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: ClipRRect(
                        child: Image.asset(
                          grupos[index]["imagem"],
                          width: 50,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
              ));
        });
  }
}
