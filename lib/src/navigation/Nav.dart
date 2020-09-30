//---- Packages
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart' as mysql;

//---- Screens
import 'package:data_science/src/routes/home/Home.dart';
import 'package:data_science/src/routes/pub/AddConteudo.dart';
import 'package:data_science/src/routes/user/User.dart';
import 'package:data_science/src/routes/chat/Chat.dart';

class Nav extends StatefulWidget {
  Nav({Key key, this.github, this.id_user, this.email}) : super(key: key);
  final String github;
  final int id_user;
  final String email;

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
//---- Variables

  bool grid = false;

  int index = 0;

  Map user;

  var settings = mysql.ConnectionSettings(
      host: "", user: "", password: "", db: "", port: 0000);

//---- Functions

  Future<dynamic> getFutureDados() async {
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
                  "linkedin": element["linkedin"],
                  "descricao": element["descricao"]
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
          index == 0
              ? IconButton(
                  icon: Icon(Icons.grid_on),
                  onPressed: () {
                    setState(() {
                      grid = !grid;
                    });
                  },
                  tooltip: "Grid",
                )
              : Text(""),
          index == 0
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 90,
                    color: Colors.white38,
                    child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddConteudo(
                                      github: user["github"],
                                      id_user: user["id"],
                                      email: widget.email,
                                    ))),
                        child: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Row(
                              children: [Icon(Icons.add), Text("Add")],
                            ))),
                  ))
              : Text(""),
        ],
      ),
      body: index == 0
          ? Home(grid: grid)
          : index == 1
              ? Chat(id_user: user["id"], name: user["name"])
              : index == 2
                  ? Users(
                      email: widget.email,
                      nome: user["name"],
                      github: user["github"],
                      linkedin: user["linkedin"],
                      id: user["id"].toString(),
                      descricao: user["descricao"],
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
