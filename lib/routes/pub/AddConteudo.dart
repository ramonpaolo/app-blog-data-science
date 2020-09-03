import '../../navigation/Nav.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class AddConteudo extends StatefulWidget {
  @override
  _AddConteudoState createState() => _AddConteudoState();
}

final form = GlobalKey<FormState>();

class _AddConteudoState extends State<AddConteudo> {
  final snack = GlobalKey<ScaffoldState>();

  void connection() async {
    var config = ConnectionSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: snack,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Adicionar Conteúdo"),
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                formulario(
                    TextInputType.text, "Digite seu Nome", "Nome não inserido"),
                formulario(TextInputType.emailAddress, "Digite seu Email",
                    "Email não inserido ou errado"),
                formutexto(TextInputType.url,
                    "Digite o link do seu github (opcional)", ""),
                formutexto(TextInputType.url,
                    "Digite o link do projeto no github (opcional)", ""),
                formulario(TextInputType.text, "Digite o Título",
                    "Título não informado"),
                formulario(
                    TextInputType.text, "Uma breve descrição", "Não informado"),
                formulario(TextInputType.text, "Digite o Título",
                    "Título não informado"),
                Tooltip(
                  message: "Fazer publicação desse artigo",
                  child: RaisedButton(
                      onPressed: () {
                        if (form.currentState.validate()) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Nav()));
                        } else {
                          snack.currentState.showSnackBar(SnackBar(
                            content: Text("Algo de errado..."),
                            duration: Duration(seconds: 2),
                          ));
                        }
                      },
                      child: Text(
                        "Fazer Publicação",
                        style: TextStyle(color: Colors.white),
                      )),
                )
              ],
            ),
          ),
        ))));
  }
}

Widget formulario(TextInputType type, String texto, String error) {
  return TextFormField(
    keyboardType: type,
    validator: (value) {
      if (value.isEmpty) {
        return "$error";
      }
      return null;
    },
    decoration: InputDecoration(labelText: "$texto"),
  );
}

Widget formutexto(TextInputType type, String texto, String error) {
  return TextField(
    keyboardType: type,
    decoration: InputDecoration(labelText: "$texto"),
  );
}
