import 'package:b_to_do/class/ToDoItem.dart';

final String taskTable = "taskTable";
final String titleColumn = "titleColumn";
final String idColumn = "idColumn";

class Tasks {
  int id;
  String title;
  List<ToDoItem> toDo;

  Tasks.test(this.title) {
    toDo = [];
  }

  int get checkItems {
    return toDo.where((element) => element.state).toList().length;
  }

  Tasks.fromMap(Map map) {
    id = map[idColumn];
    title = map[titleColumn];
    toDo = [];
  }

  Map<String, dynamic> toMap() {
    return {
      titleColumn: title,
    };
  }
}