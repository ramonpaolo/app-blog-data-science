import 'package:flutter/material.dart';
import '../routes/home/Home.dart';
import '../routes/pub/AddConteudo.dart';
import '../routes/user/User.dart';

class Nav extends StatefulWidget {
  Nav({Key key, this.github, this.id_user, this.email}) : super(key: key);
  final String github;
  final int id_user;
  final String email;

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
      body: index == 0
          ? Home()
          : Users(
              email: widget.email,
            ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (i) {
            setState(() {
              index = i;
              print(widget.email);
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
