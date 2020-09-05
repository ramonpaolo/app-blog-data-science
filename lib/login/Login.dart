import 'package:flutter/material.dart';
import './Cadastro.dart';
import '../navigation/Nav.dart';
import 'package:mysql1/mysql1.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final snack = GlobalKey<ScaffoldState>();

  String email;
  String senha;
  int valor;
  Map dados;

  Future connect(email, senha) async {
    var settings = ConnectionSettings(
      host: "mysql669.umbler.com",
      user: "ramon_paolo",
      password: "familiAMaram12.",
      db: "data-science",
      port: 41890,
    );
    var conn = await MySqlConnection.connect(settings);
    conn.query("select * from users where email = ? and senha = ?",
        [email, senha]).then((value) {
      if (value.length == 0) {
        mostrarSnack();
        //print("Usuário não cadastrado");
      } else {
        value.forEach((element) {
          dados = {"github": element["github"], "id": element["id_user"]};
        });

        print("Usuário cadastrado");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Nav(
                github: dados["github"],
                id_user: dados["id"],
                email: email,
              ),
            ));
      }
    });
  }

  void mostrarSnack() async {
    snack.currentState
        .showSnackBar(SnackBar(content: Text("Usuário não cadastrado")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: snack,
        appBar: AppBar(
          title: Text("Data-Science"),
          backgroundColor: Colors.red,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/python.png",
                      width: 150,
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.fill,
                    ),
                    Divider(
                      height: 100,
                      color: Colors.white,
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (context) {
                        setState(() {
                          email = context;
                          print("Email: $email");
                        });
                      },
                      decoration:
                          InputDecoration(labelText: "Digite seu email"),
                    ),
                    TextField(
                      obscureText: true,
                      onChanged: (context) {
                        setState(() {
                          senha = context;
                          print("Senha: $senha");
                        });
                      },
                      keyboardType: TextInputType.visiblePassword,
                      decoration:
                          InputDecoration(labelText: "Digite sua senha: "),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        await connect(email, senha);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Divider(),
                    Text("Caso não tenha um cadastro"),
                    RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Cadastro()));
                      },
                      child: Text(
                        "Cadastrar",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
