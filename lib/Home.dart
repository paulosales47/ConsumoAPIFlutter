import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'Post.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _urlBase = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> _recuperarPostagens() async{
    List<Post> postagens = List();

    http.Response response = await http.get("$_urlBase/posts");
    var jsonPosts = jsonDecode(response.body);
    Post post = null;
    
    for(var item in jsonPosts){
      post = Post(
        item["userId"],
        item["id"],
        item["title"],
        item["body"]
      );
      
      postagens.add(post);
    }

    return postagens;

  }

  void _criarPost() async{
    
    http.Response response = await http.post("$_urlBase/posts",
        headers: {
          "Content-type": "application/json; charset=UTF-8"
        }, body: json.encode({
          "userId": 120,
          "id": null,
          "title": "Titulo",
          "body": "Corpo da postagem"
        }));

    print(response.statusCode);
  }

  void _atualizarPost() async{
    
  }

  void _removerPost(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carregando ListView via API"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              RaisedButton(
                child: Text("Salvar"),
                onPressed: _criarPost,
              ),
              RaisedButton(
                child: Text("Atualizar"),
                onPressed: _atualizarPost,
              ),
              RaisedButton(
                child: Text("Remover"),
                onPressed: _removerPost,
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Post>>(
              future: _recuperarPostagens(),
              builder: (context, snapshot){
                String _resultado;

                if(snapshot.hasError){
                  _resultado = "Erro ao carregar os dados";
                }
                else{
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if(snapshot.connectionState == ConnectionState.done){
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index){
                          List<Post> postagens = snapshot.data;
                          Post post = postagens[index];

                          return ListTile(
                            title: Text(post.title),
                            subtitle: Text(post.body),
                          );
                        }
                    );


                  }
                }
                return Center(
                  child: Text(_resultado),
                );
              },
            ),
          )
        ],
      )
    );
  }
}
