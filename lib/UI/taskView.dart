import 'package:flutter/material.dart';
import 'package:b_to_do/UI/HomePage.dart';

class TaskPage extends StatefulWidget {
  final Tasks task;

  const TaskPage({Key key, @required this.task}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final doController = TextEditingController();

  void addDo() {
    setState(() {});
  }

  Widget buildItem(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.grey,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.black),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(widget.task.toDo[index]),
        value: true,
        secondary: CircleAvatar(
            child: Icon(
          true ? Icons.check : Icons.error,
          color: Colors.grey[700],
        )),
        onChanged: (c) {
          setState(() {
            c = c;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      decoration: InputDecoration(
                        labelText: "Nova tarefa",
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
                    onPressed: () {},
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
              for (final String in widget.task.toDo)
                Card(
                  child: InkWell(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
