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
        widget.task.toDo.remove(widget.task.toDo[index]);
      },
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.grey[350],
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.black),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: Align(
        child:
        Container(
          height: 80,
          // width: 65,
          decoration: BoxDecoration(
            color: Colors.black,
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
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: CheckboxListTile(
            contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 0),
            activeColor: Colors.green,
            checkColor: Colors.black,
            title: Text(
              widget.task.toDo[index].title,
              style: TextStyle(color: Colors.white),
            ),
            value: widget.task.toDo[index].state,
            secondary: Padding(
              padding: EdgeInsets.fromLTRB(10, 8, 3, 0),
              child:
              CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(
                  widget.task.toDo[index].state ? Icons.check : Icons.error,
                  color: Colors.black,
                ),
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
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.green,
        title: Text(
          widget.task.title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.black,
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
                            TextStyle(color: Colors.grey, fontSize: 15),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        hintStyle: TextStyle(color: Colors.white),
                        disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  RaisedButton(
                    child: Text("Adicionar", style: TextStyle(color:Colors.black)),
                    color: Colors.green,
                    onPressed: () {
                      if( doController.text.trim() == ""){
                        final snack = SnackBar(
                          content: Text("Sua tarefa precisa de um nome!",),
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
