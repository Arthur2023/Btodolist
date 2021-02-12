import 'package:b_to_do/Service/DBHelper.dart';
import 'package:b_to_do/class/Tasks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:b_to_do/UI/taskView.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final taskController = TextEditingController();

  List<Tasks> taskList = List();

  Future<void> _addToDo() async {
    Tasks task1 = Tasks.test(taskController.text);
    task1 = await DBHelper().saveTasks(task1);
    setState(() {
      taskList.add(task1);
      taskController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text(
          "Lista de Tarefas",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black,
        child: RefreshIndicator(
            onRefresh: () async {
              DBHelper().getAllTasks().then((value) {
                taskList = value;
                taskList.forEach((element) async {
                  element.toDo =
                      await DBHelper().getAllToDoItensFromTasks(element.id);
                });
                setState(() {});
              });
            },
            child: ListView(
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
                              style: TextStyle(color:Colors.white, fontSize: 15),
                              controller: taskController,
                              decoration: InputDecoration(
                                labelText: "Nova lista",
                                labelStyle: TextStyle(
                                    color: Colors.white, fontSize: 15),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                hintStyle: TextStyle(color: Colors.white),
                                disabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: RaisedButton(
                                  child: Text(
                                    "Adicionar",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.grey[800],
                                  onPressed: () {
                                    if (taskController.text.trim() == "") {
                                      final snack = SnackBar(
                                        content: Text(
                                            "Sua lista precisa de um nome!"),
                                        // possivel alteracao
                                        backgroundColor: Colors.grey,
                                        duration: Duration(seconds: 2),
                                      );
                                      _scaffoldKey.currentState
                                          .showSnackBar(snack);
                                      return;
                                    }
                                    _addToDo();
                                    taskController.text = "";
                                  })),
                        ],
                      ),
                      for (final task in taskList)
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 10, 5, 2),
                          child: Container(
                            height: 75,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[850].withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskPage(
                                      task: task,
                                    ),
                                  ),
                                ).then((value) => setState(() {}));
                              },
                              onLongPress: () {
                                showAlertDialog1(task);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(task.title,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 18)),
                                    task.checkItems == task.toDo.length
                                        ? Icon(Icons.check,
                                            color: Colors.yellow)
                                        : CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.yellow[600]),
                                            value: task.toDo.length == 0
                                                ? 0
                                                : task.checkItems /
                                                    task.toDo.length,
                                            backgroundColor: Colors.grey[600],
                                            strokeWidth: 2,
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Future<void> populateToDoItems() async {
    for (final element in taskList)
      element.toDo = await DBHelper().getAllToDoItensFromTasks(element.id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    DBHelper().getAllTasks().then((list) {
      taskList = list;
      populateToDoItems();
    });
  }

  showAlertDialog1(Tasks tasks) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Deseja excluir esta lista?"),
          actions: [
            FlatButton(
              color: Colors.red[800],
              height: 27,
              child: Text("Confirmar"),
              onPressed: () async {
                await DBHelper().deleteTasks(tasks.id);
                setState(() {
                  taskList.remove(tasks);
                });
                Navigator.pop(context);
              },
            ),
            FlatButton(
              color: Colors.grey[800],
              height: 27,
              child: Text(
                "Cancelar",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
