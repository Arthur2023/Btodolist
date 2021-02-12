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
        color: Colors.grey[400],
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.black),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: Align(
        child:
        Padding(
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
          child: Container(
            height: 70,
            // width: 65,
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
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: CheckboxListTile(
              contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 0),
              activeColor: Colors.black,
              checkColor: Colors.white,
              title: Text(
                widget.task.toDo[index].title,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 18),
              ),
              value: widget.task.toDo[index].state,
              secondary: Padding(
                padding: EdgeInsets.fromLTRB(10, 8, 3, 0),
                child:
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Icon(
                    widget.task.toDo[index].state ? Icons.check : Icons.error,
                    color: Colors.white,
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
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[800],
        title: Text(
          widget.task.title,
          style: TextStyle(color: Colors.white),
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
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      controller: doController,
                      decoration: InputDecoration(
                        labelText: "Nova tarefa",
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 15),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        hintStyle: TextStyle(color: Colors.white),
                        disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  RaisedButton(
                    child: Text("Adicionar", style: TextStyle(color:Colors.white),),
                    color: Colors.grey[800],
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
