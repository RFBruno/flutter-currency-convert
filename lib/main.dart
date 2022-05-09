
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const KEY = '5c642ffa';
const URL_DEFAULT = 'https://api.hgbrasil.com/finance?format=json&key=$KEY';

void main() async {

  print(await getData());

  return runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
     theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(15),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(15),
          ),
          labelStyle: TextStyle(color: Colors.amber),
          hintStyle: TextStyle(color: Colors.white),
          prefixStyle: TextStyle(color: Colors.amber, fontSize: 25),
        ),
      ),
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

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double? real;
  double? dolar;
  double? euro;

  void _realChanged(String value){
    print(value);
  }

  void _dolarChanged(String value){
    print(value);

  }

  void _euroChanged(String value){
    print(value);
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(" \$ Conversor \$"),
        centerTitle: true,
      ),
      body: FutureBuilder<Map?>(
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
                dolar = snapshot.data!["results"]['currencies']['USD']['buy'];
                euro = snapshot.data!["results"]['currencies']['EUR']['buy'];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children:  [
                     const Icon(Icons.monetization_on, size: 150, color: Colors.amber,),
                     
                     const Divider(),
                     buildTextField('Real', 'R\$', realController, _realChanged),
                     const Divider(),
                     buildTextField('Dólar', '\$', dolarController, _dolarChanged),
                     const Divider(),
                     buildTextField('Euro', '€', euroController, _euroChanged),
                    ],
                  ),
                );
              }
          }
        }),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController controller,  Function callback){
  return TextField(
    controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.amber),
        border: const OutlineInputBorder(),
        prefixText: prefix
      ),
      style: const TextStyle(
        color: Colors.amber,
        fontSize: 25
      ),
      onChanged: callback as void Function(String)?,
      keyboardType: const TextInputType.numberWithOptions(),
    );
}