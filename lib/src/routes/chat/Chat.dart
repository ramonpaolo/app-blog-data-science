//---- Packages
import 'package:flutter/material.dart';

//---- Screens
import 'package:data_science/src/routes/chat/Visualizacao.dart';

//---- Datas
import 'package:data_science/src/data/data.dart';

class Chat extends StatefulWidget {
  Chat({Key key, this.id_user, this.name}) : super(key: key);
  final int id_user;
  final String name;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
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
                                  name: widget.name,
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
