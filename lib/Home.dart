import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {



  Future<Map> _recuperarPreco() async{
    String _urlRequisicao = "https://blockchain.info/ticker";
    http.Response response = await http.get(_urlRequisicao);
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: _recuperarPreco(),
      builder: (context, snapshot){
        String _resultado;

        if(snapshot.hasError){
          _resultado = "Erro ao carregar os dados";
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          _resultado = "Carregando...";
        }

        if(snapshot.connectionState == ConnectionState.done){
          _resultado = snapshot.data["BRL"]["buy"].toString();
        }

        return Center(
          child: Text(_resultado),
        );
    },
    );
  }
}
