import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  Map user = {};

  Future<dynamic> getFutureDados() async {
    var settings = ConnectionSettings(
      host: "",
      user: "",
      password: "",
      db: "",
      port: 0000,
    );
    var conn = await MySqlConnection.connect(settings);
    var results = conn.query("select * from users where id_user = ?", [2]);
    await results
        .then((value) => {
              value.forEach((element) {
                if (element["id_user"] != user["id"])
                  return user = {
                    "id": element["id_user"].toString(),
                    "name": element["nome"],
                    "email": element["email"],
                    "github": element["github"],
                    "linkedin": element["linkedin"]
                  };
              })
            })
        .catchError((onError) => print("Errorr: ${onError}"));

    conn.close();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: EdgeInsets.all(20),
      child: Container(
          child: FutureBuilder(
              initialData: "Aguarde",
              future: getFutureDados(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Center(
                          child: ClipRRect(
                        child: Image.asset(
                          "assets/python.png",
                          width: 90,
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(105),
                      )),
                      Text(
                        "Nome: ${user["name"]}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text("Email: ${user["email"]}"),
                      Text("Github: ${user["github"]}"),
                      Text("Linkedin: ${user["linkedin"]}"),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              })),
    ));
  }
}
