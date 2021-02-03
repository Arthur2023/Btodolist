import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:b_to_do/UI/taskView.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class Tasks {
  String title;
  List<String> toDo;

  Tasks.test(this.title) {
    toDo = [];
  }
  Tasks(this.title, this.toDo);
}

class _HomePageState extends State<HomePage> {


  final taskcontroller = TextEditingController();

  Tasks t1 = Tasks("fazer", ["a", "b"]);

  List<Tasks> taskList = [Tasks.test("limpar"), Tasks.test("Estudar"),];

  void _addToDo() {
    setState(() {
      taskcontroller.text = '';
      taskList.add(Tasks.test(taskcontroller.text));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Lista de Tarefas",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/montain.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "Nova lista",
                            labelStyle:
                                TextStyle(color: Colors.black, fontSize: 10),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      RaisedButton(
                          child: Text("Adicionar"),
                          color: Colors.white,
                          onPressed: () {}),
                    ],
                  ),
                  for (final task in taskList)
                    Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskPage(
                                task: task,
                              ),
                            ),
                          );
                        },
                        onLongPress: () {},
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,                            children: <Widget>[
                              Text(
                                task.title,
                              ),
                              CircularProgressIndicator(
                                backgroundColor: Colors.grey,
                                strokeWidth: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
