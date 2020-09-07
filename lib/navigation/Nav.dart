import 'package:flutter/material.dart';
import '../routes/home/Home.dart';
import '../routes/pub/AddConteudo.dart';
import '../routes/user/User.dart';
import '../routes/chat/Chat.dart';
import 'package:mysql1/mysql1.dart' as mysql;

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
  Map user = {};

  Future<dynamic> getFutureDados() async {
    var settings = mysql.ConnectionSettings();
    var conn = await mysql.MySqlConnection.connect(settings);
    var results =
        conn.query("select * from users where email = ?", [widget.email]);
    await results
        .then((value) => {
              value.forEach((element) {
                return user = {
                  "id": element["id_user"],
                  "name": element["nome"],
                  "email": element["email"],
                  "github": element["github"],
                  "linkedin": element["linkedin"]
                };
              }),
            })
        .catchError((onError) => print("'Nav.dart': $onError"));

    conn.close();
    return user;
  }

  @override
  void initState() {
    // TODO: implement initState
    print("----------------- NAV.DART -----------------");
    getFutureDados();
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
                            github: user["github"],
                            id_user: user["id"],
                            email: widget.email,
                          )));
            },
            tooltip: "Adicionar Conteúdo",
          )
        ],
      ),
      body: index == 0
          ? Home()
          : index == 1
              ? Chat(
                  id_user: user["id"],
                )
              : index == 2
                  ? Users(
                      email: widget.email,
                      nome: user["name"],
                      github: user["github"],
                      linkedin: user["linkedin"],
                      id: user["id"].toString(),
                    )
                  : Center(
                      child: Text(
                      "ERROR",
                      style: TextStyle(fontSize: 24),
                    )),
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
                icon: Icon(Icons.message), title: Text("Chat")),
            BottomNavigationBarItem(
                icon: Icon(Icons.portrait), title: Text("Perfil"))
          ]),
    );
  }
}
