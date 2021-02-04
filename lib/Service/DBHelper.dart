import 'package:b_to_do/class/Tasks.dart';
import 'package:b_to_do/class/ToDoItem.dart';
import "package:sqflite/sqflite.dart";
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper.internal();

  factory DBHelper() => _instance;

  DBHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await _initDb();
      return _db;
    }
  }

  Future<Database> _initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "To_do_list.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerversion) async {
      await db.execute(
          "CREATE TABLE $taskTable($idColumn INTEGER PRIMARY KEY, $titleColumn TEXT)");
      await db.execute(
          "CREATE TABLE $toDoItemTable($toDoidColumn INTEGER PRIMARY KEY,"
          " $toDotitleColumn TEXT, $stateColumn INTEGER, $toDoItemTaskIdColumn INTEGER)");
    });
  }

  Future<Tasks> saveTasks(Tasks tasks) async {
    Database dbTasks = await db;
    tasks.id = await dbTasks.insert(taskTable, tasks.toMap());
    return tasks;
  }

  Future<Tasks> getTasks(int id) async {
    Database dbTasks = await db;
    List<Map> maps = await dbTasks.query(taskTable,
        columns: [idColumn, titleColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Tasks.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Tasks>> getAllTasks() async {
    Database dbTasks = await db;
    List<Map> maps = await dbTasks.rawQuery("SELECT * FROM $taskTable");
    List<Tasks> taskslist = [];
    for (final map in maps ?? []) taskslist.add(Tasks.fromMap(map));
    return taskslist;
  }

  Future<List<ToDoItem>> getAllToDoItensFromTasks(int id) async {
    Database dbTasks = await db;
    List<Map> maps = await dbTasks.rawQuery("SELECT * FROM $toDoItemTable "
        "where $toDoItemTaskIdColumn = $id");
    List<ToDoItem> list = [];
    for (final map in maps) {
      print(map);
      list.add(ToDoItem.fromMap(map));
    }
    return list;
  }

  Future<int> deleteTasks(int id) async {
    Database dbTasks = await db;
    await dbTasks.delete(taskTable, where: "$idColumn = ?", whereArgs: [id]);
    return await dbTasks.delete(toDoItemTable,
        where: "$toDoItemTaskIdColumn = ?", whereArgs: [id]);
  }

  Future<int> updateTasks(Tasks tasks) async {
    Database dbTasks = await db;
    return await dbTasks.update(taskTable, tasks.toMap(),
        where: "$idColumn = ?", whereArgs: [tasks.id]);
  }

  Future<ToDoItem> saveToDoItens(ToDoItem item1, int id) async {
    Database dbTasks = await db;
    item1.toDoid = await dbTasks.insert(toDoItemTable, item1.toMap(id));
    return item1;
  }

  Future<int> deleteToDoItens(int id) async {
    Database dbTasks = await db;
    return await dbTasks
        .delete(toDoItemTable, where: "$toDoidColumn = ?", whereArgs: [id]);
  }

  Future<int> updateToDoItens(ToDoItem item1, int id) async {
    Database dbTasks = await db;
    return await dbTasks.update(toDoItemTable, item1.toMap(id),
        where: "$toDoidColumn = ?", whereArgs: [item1.toDoid]);
  }
}
