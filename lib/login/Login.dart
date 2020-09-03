import 'package:flutter/material.dart';
import './Cadastro.dart';
import '../navigation/Nav.dart';
import 'dart:async';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      width: 200,
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.fill,
                    ),
                    Divider(
                      height: 100,
                      color: Colors.white,
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          InputDecoration(labelText: "Digite seu email"),
                    ),
                    TextField(
                      keyboardType: TextInputType.visiblePassword,
                      decoration:
                          InputDecoration(labelText: "Digite sua senha: "),
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Nav()));
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
