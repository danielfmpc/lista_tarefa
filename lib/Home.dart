import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _list = [];
  TextEditingController _controllerTarefa = TextEditingController();

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");

  }

  _salvarTarefa(){
    String textoDigitado = _controllerTarefa.text;
    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = textoDigitado;
    tarefa["realizada"] = false;
    setState(() {
      _list.add(tarefa);      
    });
    _salvarArquivo();
    _controllerTarefa.text = "";
  }

  _salvarArquivo() async {
    var arquivo = await _getFile();
    String _dados = json.encode(_list);
    arquivo.writeAsString(_dados);
  }

  _lerArquivo() async {
    try {
      final arquivo = await _getFile();
      return arquivo.readAsString(encoding: utf8);
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _lerArquivo().then((_dados){
      setState(() {
       _list = json.decode(_dados);
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tarefas"),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        child: Column(
          children: <Widget>[            
            Expanded(
              child: ListView.builder(
                itemCount: _list.length,
                itemBuilder: (context, index){
                  return CheckboxListTile(
                    title: Text(_list[index]["titulo"]),
                    value: _list[index]["realizada"],
                    onChanged: (valorAlterado){
                      setState(() {
                        _list[index]["realizada"] = valorAlterado;                        
                      });
                      _salvarArquivo();
                    },
                  );

                  /*
                  return ListTile(
                    title: Text(_list[index]["titulo"]),
                  );
                  */
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton.extends(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 20,
        child: Icon(Icons.add),
        // shape: BeveledRectangleBorder(
        //   borderRadius: BorderRadius.circular(2)
        // ), 
        onPressed: () {
          showDialog(
            context: context,
            builder: (contex){
              return AlertDialog(
                title: Text("Adicionar tarefa"),
                content: TextField(
                  controller: _controllerTarefa,
                  decoration: InputDecoration(
                    labelText: "Digite sua tarefa",
                  ),
                  onChanged: (text){
                    
                  },
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("cancelar"),
                    onPressed: ()=> Navigator.pop(context),
                  ),
                  FlatButton(
                    child: Text("Salvar"),
                    onPressed: (){
                      _salvarTarefa();
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            }
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.menu),
            )
          ],
        ),
      ),
    );
  }
}