
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const KEY = '5c642ffa';
const URL_DEFAULT = 'https://api.hgbrasil.com/finance?format=json&key=$KEY';

void main() async {

  print(await getData());

  return runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

Future<Map> getData() async{
  http.Response response = await http.get(Uri.parse(URL_DEFAULT)); 
  return jsonDecode(response.body);
}

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();

}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(" \$ Conversor \$"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text('Carregando Dados...',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 25
                ),
                textAlign: TextAlign.center,),
              );
            default:
              if(snapshot.hasError){
                return const Center(
                  child: Text('Erro ao carregar dados...',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25
                  ),
                  textAlign: TextAlign.center,),
                );
              }else{
                return Container(color: Colors.cyan,);
              }
          }
        }),
    );
  }
}