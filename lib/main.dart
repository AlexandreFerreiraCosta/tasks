import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _toDoList = [];
  final _controladorNome = TextEditingController();

 @override
 void initState(){
    super.initState();

    _recuperarDados().then((data){
      setState(() {
        _toDoList = json.decode(data);
      });
    });
 }

  void _addTarefa(){
     setState(() {
       Map<String, dynamic> novaTarefa = new Map();
       novaTarefa["title"] =  _controladorNome.text;
       novaTarefa["ok"] = false;
       _controladorNome.text = "";
       _toDoList.add(novaTarefa);
       _savarDados();
     });
  }

  //TODO PARTE VISUAL DA APLICAÇÃO
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controladorNome,
                    decoration: InputDecoration(
                        labelText: "Nova Tarefa",
                        labelStyle: TextStyle(color: Colors.blueAccent)),
                  ),
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: _addTarefa,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: _toDoList.length,
                itemBuilder: (contexto, index) {
                  return CheckboxListTile(
                    title: Text(_toDoList[index]["title"]),
                    value: _toDoList[index]["ok"],
                    secondary: CircleAvatar(
                      child: Icon( _toDoList[index]["ok"] ? Icons.check : Icons.error,),
                    ),
                    onChanged: (checked){
                      setState(() {
                        _toDoList[index]["ok"] = checked;
                        _savarDados();
                      });
                    },
                  );
                }),
          )
        ],
      ),
    );
  }

  Future<File> _getArquivo() async {
    final diretorio = await getApplicationDocumentsDirectory();

    return File("${diretorio.path}/data.json");
  }

  Future<File> _savarDados() async {
    String data = json.encode(_toDoList);
    final file = await _getArquivo();

    return file.writeAsString(data);
  }

  Future<String> _recuperarDados() async {
    try {
      final file = await _getArquivo();
      return file.readAsString();
    } catch (erro) {
      return null;
    }
  }
}
