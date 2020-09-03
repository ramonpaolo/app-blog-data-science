import 'package:blog_data_science/routes/data/Data.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Visualizacao extends StatefulWidget {
  Visualizacao(
      {Key key,
      this.title,
      this.autor,
      this.id_post,
      this.fast_describe,
      this.describe,
      this.github})
      : super(key: key);
  final String title;
  final String autor;
  final String fast_describe;
  final String describe;
  final String github;
  final String id_post;

  @override
  _VisualizacaoState createState() => _VisualizacaoState();
}

class _VisualizacaoState extends State<Visualizacao> {
  void launcher(url) async {
    if (await canLaunch("${url}")) {
      launch(url);
    } else {
      throw "Operação não pode ser realizada";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.autor}"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Text(
                  "${widget.title}",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )),
                Divider(
                  indent: 100,
                  endIndent: 110,
                  color: Colors.red,
                  height: 30,
                  thickness: 3.0,
                ),
                Text(
                  "${widget.fast_describe}",
                  style: TextStyle(fontSize: 20, color: Colors.black54),
                ),
                Divider(
                  indent: 10,
                  endIndent: 10.0,
                  thickness: 1.5,
                  color: Colors.red,
                ),
                Text("${widget.describe}",
                    style: TextStyle(
                      fontSize: 16,
                    )),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RaisedButton(
                        onPressed: () {
                          launcher(widget.github);
                        },
                        child: Text(
                          "GitHub",
                          style: TextStyle(color: Colors.white),
                        ),
                        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                        color: Colors.black,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: RaisedButton(
                        onPressed: () {},
                        child: Text(
                          "Linkedin",
                          style: TextStyle(color: Colors.white),
                        ),
                        padding: EdgeInsets.only(left: 45, right: 45),
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        )));
  }
}
