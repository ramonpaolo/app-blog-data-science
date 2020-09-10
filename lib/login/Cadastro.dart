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
  final form = GlobalKey<FormState>();
  final snack = GlobalKey<ScaffoldState>();
  String nome;
  String email;
  String senha;
  String github = "https://github.com/";
  String linkedin = "https://linkedin/in/";
  int contasExistentes;
  var settings = mysql.ConnectionSettings(
    host: "mysql669.umbler.com",
    user: "ramon_paolo",
    password: "familiAMaram12.",
    db: "data-science",
    port: 41890,
  );
  GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ["email", "https://www.googleapis.com/auth/cloud-platform"]);

  Future cadastroGoogle() async {
    try {
      await _googleSignIn.signIn();
      senha = DateTime.now().toString();
      await connection(_googleSignIn.currentUser.displayName,
          _googleSignIn.currentUser.email, senha, github, linkedin);
    } catch (e) {
      print(e);
    }
  }

  Future connection(nome, email, senha, github, linkedin) async {
    contasExistentes = 0;
    var conn = await mysql.MySqlConnection.connect(settings);
    var results =
        await conn.query("select email from users where email = ?", [email]);
    results.forEach((element) {
      contasExistentes++;
    });
    if (contasExistentes == 0) {
      conn.query(
          "INSERT INTO users (id_user, nome, email, senha, github, linkedin) VALUES (null, ?,?,?,?,?)",
          [nome, email, senha, github, linkedin]);
    } else {
      print("'Cadastro.dart': Já tem usuário cadastrado com esse Email");
    }
  }

  void snackbar(text) {
    snack.currentState.showSnackBar(SnackBar(content: Text(text)));
  }

  void nextTela(email) async {
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
          title: Text("Data Science"),
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
                              if (contasExistentes == 0) {
                                nextTela(email);
                              } else {
                                snackbar("Email já está sendo utilizado");
                              }
                            } else {
                              print(
                                  "'Cadastro.dart': Formulário com dados faltando.");
                              snackbar("Formulário com dados faltando");
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
                        onPressed: () async {
                          await cadastroGoogle();
                          if (contasExistentes == 0) {
                            snackbar("Cadastro Realizado com sucesso");
                            await Future.delayed(
                                Duration(seconds: 2),
                                () =>
                                    nextTela(_googleSignIn.currentUser.email));
                          } else {
                            snackbar("Esse Email já está sendo utilizado");
                          }
                        },
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

  Widget formulario(bool password, TextInputType type, String label,
      String state, String valueInit) {
    return TextFormField(
      obscureText: password,
      initialValue: valueInit,
      validator: (value) {
        if (value.isEmpty) {
          return "Está vazio";
        }
      },
      keyboardType: type,
      decoration: InputDecoration(labelText: label),
      onChanged: (context) {
        setState(() {
          if (state == email) {
            email = context;
            print("'Cadastro.dart': Email: $email");
          } else if (state == nome) {
            nome = context;
            print("'Cadastro.dart': Nome: $nome");
          } else if (state == senha) {
            senha = context;
            print("'Cadastro.dart': Senha: $senha");
          } else if (state == github) {
            github = context;
            print("'Cadastro.dart': Github: $github");
          } else {
            linkedin = context;
            print("'Cadastro.dart': Linkedin $linkedin");
          }
        });
      },
    );
  }
}
