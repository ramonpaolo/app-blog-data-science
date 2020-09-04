import 'package:flutter/material.dart';
import '../routes/home/Home.dart';
import '../routes/pub/AddConteudo.dart';
import '../routes/user/User.dart';

class Nav extends StatefulWidget {
  Nav({Key key, this.github, this.id_user}) : super(key: key);
  final String github;
  final int id_user;

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int index = 0;
  List widgets = [Home(), Users()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Science"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddConteudo(
                            github: widget.github,
                            id_user: widget.id_user,
                          )));
            },
            tooltip: "Adicionar Conteúdo",
          )
        ],
      ),
      body: widgets[index],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (i) {
            setState(() {
              index = i;
            });
          },
          currentIndex: index,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text("Home")),
            BottomNavigationBarItem(
                icon: Icon(Icons.portrait), title: Text("Perfil"))
          ]),
    );
  }
}
