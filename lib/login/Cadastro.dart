import '../navigation/Nav.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
/*  
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
var j;
  Future _requestTempDirectory() async {
    await rootBundle.loadString("assets/db.json").then((value) {
      dados = {"user": value};
    });
    j = await json.encode(dados);
    //dados = {"user": j};
    print(await dados["user"]["user"]);
    //print(dados["user"]);
  }*/

  final form = GlobalKey<FormState>();
  final snack = GlobalKey<ScaffoldState>();

  Map jsonData;
  String nome;
  String email;
  String senha;
  String github = "https://github.com/";
  String linkedin = "https://linkedin/in/";
  int valores;
  bool user = false;

  GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ["email", "https://www.googleapis.com/auth/cloud-platform"]);

  Future cadastroGoogle() async {
    try {
      await _googleSignIn.signIn();
      senha = DateTime.now().toString();
      await conexaoGoogle();
    } catch (e) {
      print(e);
    }
  }

  Future conexaoGoogle() async {
    await connection(_googleSignIn.currentUser.displayName,
        _googleSignIn.currentUser.email, senha, github, linkedin);
    if (valores == 0) {
      snack.currentState.showSnackBar(
          SnackBar(content: Text("Cadastro realizado com sucesso")));
      Future.delayed(
          Duration(seconds: 2), () => tela(_googleSignIn.currentUser.email));
    } else {
      snack.currentState.showSnackBar(
          SnackBar(content: Text("Esse Email já está sendo utilizado")));
    }
  }

  Future connection(nome, email, senha, github, linkedin) async {
    valores = 0;
    var settings = mysql.ConnectionSettings();
    var conn = await mysql.MySqlConnection.connect(settings);
    var results =
        await conn.query("select email from users where email = ?", [email]);
    results.forEach((element) {
      if (mounted)
        setState(() {
          valores++;
        });
    });
    print(valores);
    if (valores == 0) {
      conn.query(
          "INSERT INTO users (id_user, nome, email, senha, github, linkedin) VALUES (null, ?,?,?,?,?)",
          [nome, email, senha, github, linkedin]);

      user = true;
    } else if (valores == 1) {
      user = false;
      print("Já tem cadastrado: " + valores.toString());
    }
  }

  void tela(email) async {
    Navigator.of(context).popUntil((route) => route.isFirst);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Nav(
                  email: email,
                )));
  }

  @override
  void initState() {
    // TODO: implement initState
    print("----------------- CADASTRO.DART -----------------");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: snack,
        appBar: AppBar(
          title: Text("Data-Science"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                child: Form(
                  key: form,
                  child: Column(
                    children: [
                      Text(
                        "Adicione os dados abaixo para podermos criar a sua conta",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      formulario(false, TextInputType.emailAddress,
                          "Digite seu email:", email, ""),
                      formulario(false, TextInputType.name, "Digite seu nome:",
                          nome, ""),
                      formulario(
                          false,
                          TextInputType.url,
                          "Digite o link do github (opcional):",
                          github,
                          github),
                      formulario(
                          false,
                          TextInputType.url,
                          "Digite seu linkedin (opcional):",
                          linkedin,
                          linkedin),
                      formulario(true, TextInputType.visiblePassword,
                          "Digite aqui sua senha:", senha, ""),
                      RaisedButton(
                          onPressed: () async {
                            if (form.currentState.validate()) {
                              await connection(
                                  nome, email, senha, github, linkedin);
                              if (user) {
                                tela(email);
                              } else {
                                snack.currentState.showSnackBar(
                                    SnackBar(content: Text("Email já em uso")));
                              }
                            } else {
                              print("Formulário com dados faltando.");
                              snack.currentState.showSnackBar(SnackBar(
                                  content:
                                      Text("Formulário com dados faltando")));
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Cadastrar",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          )),
                      Text("Ou"),
                      RaisedButton(
                        onPressed: cadastroGoogle,
                        color: Colors.white,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/google.jpg",
                                width: 40,
                              ),
                              Text(
                                "Cadastrar com o Google",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              )),
        ));
  }

  Widget formulario(bool password, TextInputType tipo, String label,
      String estado, String valorInicial) {
    return TextFormField(
      obscureText: password,
      initialValue: valorInicial,
      validator: (value) {
        if (value.isEmpty) {
          return "Está vazio";
        }
      },
      keyboardType: tipo,
      decoration: InputDecoration(labelText: label),
      onChanged: (context) {
        setState(() {
          if (estado == email) {
            email = context;
            print(email);
          } else if (estado == nome) {
            nome = context;
            print(nome);
          } else if (estado == senha) {
            senha = context;
            print(senha);
          } else if (estado == github) {
            github = context;
            print(github);
          } else {
            linkedin = context;
            print(linkedin);
          }
        });
      },
    );
  }
}
