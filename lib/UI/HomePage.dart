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
                              controller: taskController,
                              decoration: InputDecoration(
                                labelText: "Nova lista",
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 15),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          RaisedButton(
                              child: Text("Adicionar"),
                              color: Colors.white,
                              onPressed: () {
                                if (taskController.text.trim() == "") {
                                  final snack = SnackBar(
                                    content:
                                        Text("Sua lista precisa de um nome!"),
                                    backgroundColor: Colors.grey,
                                    duration: Duration(seconds: 2),
                                  );
                                  _scaffoldKey.currentState.showSnackBar(snack);
                                  return;
                                }
                                _addToDo();
                                taskController.text = "";
                              }),
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
                              ).then((value) => setState(() {}));
                            },
                            onLongPress: () {
                              showAlertDialog1(context, task);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    task.title,
                                  ),
                                  task.checkItems == task.toDo.length
                                      ? Icon(Icons.check)
                                      : CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.black),
                                          value: task.toDo.length == 0
                                              ? 0
                                              : task.checkItems /
                                                  task.toDo.length,
                                          backgroundColor: Colors.grey,
                                          strokeWidth: 2,
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
            )),
      ),
    );
  }

Future<void> populateToDoItems()async{
    for(final element in taskList)
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

  showAlertDialog1(BuildContext context, Tasks tasks) {
    Widget okButton = FlatButton(
      color: Colors.grey[350],
      height: 27,
      child: Text("Confirmar"),
      onPressed: () async {
        await DBHelper().deleteTasks(tasks.id);
        setState(() {
          taskList.remove(tasks);
        });
        Navigator.pop(context);
      },
    );
    Widget cancelButton = FlatButton(
      color: Colors.grey[350],
      height: 27,
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alerta = AlertDialog(
      title: Text("Deseja excluir esta lista?"),
      actions: [
        okButton,
        cancelButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }
}
