//---- Packages
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import 'package:google_sign_in/google_sign_in.dart';

//---- Screens
import 'package:data_science/src/login/Cadastro.dart';
import 'package:data_science/src/navigation/Nav.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //---- Variables

  bool login = false;

  final snack = GlobalKey<ScaffoldState>();

  GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ["email", "https://www.googleapis.com/auth/cloud-platform"]);

  int valor;

  Map dados;

  String email;
  String senha;

  var settings = mysql.ConnectionSettings(
      host: "", user: "", password: "", db: "", port: 0000);

  //---- Functions

  Future loginGoogle() async {
    try {
      await _googleSignIn.signIn();
      login = true;
      await connect(_googleSignIn.currentUser.email, senha);
    } catch (e) {
      mostrarSnack("login google erro");
      print(e);
    }
  }

  Future connect(email, senha) async {
    if (login) {
      var conn = await mysql.MySqlConnection.connect(settings);
      await conn.query("select * from users where email = ?",
          [_googleSignIn.currentUser.email]).then((value) {
        if (value.length == 0) {
          mostrarSnack("Usuário não cadastrado");
          print("'Login.dart': Usuário não cadastrado pelo google");
        } else {
          value.forEach((element) {
            dados = {"github": element["github"], "id": element["id_user"]};
          });
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Nav(
                  github: dados["github"],
                  id_user: dados["id"],
                  email: _googleSignIn.currentUser.email,
                ),
              ));
        }
      });
    } else {
      var conn = await mysql.MySqlConnection.connect(settings);
      await conn.query("select * from users where email = ? and senha = ?",
          [email, senha]).then((value) {
        if (value.length == 0) {
          mostrarSnack("Usuário não cadastrado");
          print("'Login.dart': Usuário não cadastrado");
        } else {
          value.forEach((element) {
            dados = {"github": element["github"], "id": element["id_user"]};
          });
          print("'login.dart': Usuário cadastrado");
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
  }

  void mostrarSnack(texto) async {
    snack.currentState.showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  void initState() {
    // TODO: implement initState
    print("----------------- LOGIN.DART -----------------");
    super.initState();
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
                    Divider(
                      height: 30,
                    ),
                    Image.asset(
                      "assets/python.png",
                      width: 150,
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.fill,
                    ),
                    Divider(
                      height: 50,
                      color: Colors.white,
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (context) {
                        setState(() {
                          email = context;
                          print("'Login.dart': Email: $email");
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
                          print("'Login.dart': Senha: $senha");
                        });
                      },
                      keyboardType: TextInputType.visiblePassword,
                      decoration:
                          InputDecoration(labelText: "Digite sua senha: "),
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    RaisedButton(
                        onPressed: () async {
                          setState(() async {
                            await connect(email, senha);
                            email = "";
                            senha = "";
                          });
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ])),
                    RaisedButton(
                      onPressed: loginGoogle,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/google.jpg",
                            height: 40,
                          ),
                          Text(
                            "Login com Google",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      color: Colors.white,
                      colorBrightness: Brightness.light,
                    ),
                    Divider(),
                    Text(
                      "Caso não tenha um cadastro",
                      style: TextStyle(fontSize: 18),
                    ),
                    RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Cadastro()));
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Cadastrar",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ]))
                  ],
                ),
              ),
            )));
  }
}
