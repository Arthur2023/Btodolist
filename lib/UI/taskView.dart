import 'package:b_to_do/Service/DBHelper.dart';
import 'package:b_to_do/class/Tasks.dart';
import 'package:b_to_do/class/ToDoItem.dart';
import 'package:flutter/material.dart';

class TaskPage extends StatefulWidget {
  final Tasks task;

  const TaskPage({Key key, @required this.task}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  final  GlobalKey < ScaffoldState > _scaffoldKey =  new  GlobalKey < ScaffoldState > ();

  final doController = TextEditingController();

  Future<void> addDo() async {
    ToDoItem value = ToDoItem(title: doController.text);
    value = await DBHelper().saveToDoItens(value, widget.task.id);
    setState(() {
      widget.task.toDo.add(value);
    });
  }

  Widget buildItem(BuildContext context, int index) {
    return Dismissible(
      onDismissed: (a) async {
        await DBHelper().deleteToDoItens(widget.task.toDo[index].toDoid);
      },
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.grey[350],
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: Card(
        child: CheckboxListTile(
          activeColor: Colors.grey,
          checkColor: Colors.white,
          title: Text(
            widget.task.toDo[index].title,
            style: TextStyle(color: Colors.black),
          ),
          value: widget.task.toDo[index].state,
          secondary: CircleAvatar(
            child: Icon(
              widget.task.toDo[index].state ? Icons.check : Icons.error,
              color: Colors.grey,
            ),
          ),
          onChanged: (c) async {
            setState(() {
              widget.task.toDo[index].state = c;
            });
            await DBHelper()
                .updateToDoItens(widget.task.toDo[index], widget.task.id);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          widget.task.title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/montain.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: doController,
                      decoration: InputDecoration(
                        labelText: "Nova tarefa",
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 15),
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
                    onPressed: () {
                      if( doController.text.trim() == ""){
                        final snack = SnackBar(
                          content: Text("Sua tarefa precisa de um nome!"),
                          backgroundColor: Colors.grey,
                          duration: Duration(seconds: 2),
                        );
                        _scaffoldKey.currentState.showSnackBar(snack);
                        return;
                      }
                      addDo();
                      doController.text = "";
                    },
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 7),
                    itemCount: widget.task.toDo.length,
                    itemBuilder: buildItem),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
