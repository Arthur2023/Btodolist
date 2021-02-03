
final String toDoItemTable = "toDoItemTable";
final String toDotitleColumn = "toDotitleColumn";
final String stateColumn = "stateColumn";
final String toDoidColumn = "toDoidColumn";
final String toDoItemTaskIdColumn = "toDoItemTaskIdColumn";


class ToDoItem {
  int toDoid;
  String title;
  bool state;
  ToDoItem({this.title = "", this.state = false});

  ToDoItem.fromMap(Map map) {
    toDoid = map[toDoidColumn];
    title = map[toDotitleColumn];
    state = map[stateColumn] == 1;
  }

  Map<String, dynamic> toMap(int id) {
    return {
      toDotitleColumn: title,
      toDoidColumn: toDoid,
      toDoItemTaskIdColumn: id,
      stateColumn: state ? 1 : 0,
    };
  }
}