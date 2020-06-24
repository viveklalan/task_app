import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:taskapp/model/taskModel.dart';

class DbHelper{
  static final DbHelper _dbHelper = DbHelper._internal();
  String taskTable = "TASKS";
  String taskName = "TN";
  String taskDesc = "TD";
  String taskCreatedOn = "T_C";
  String taskEditedOn = "T_E";
  String isDeleted = "is_D";
  String isCompleted = "is_C";


  //named constructor
  DbHelper._internal();

  //Factory constructor
  factory DbHelper(){
    return _dbHelper;
  }
  static Database _db;
  Future<Database> get db async{
    if(_db == null){
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb()async{
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "tasks.db";
    var dbTasks = await openDatabase(path, version: 1,onCreate: _createDb);
    return dbTasks;
  }
  void _createDb(Database db, int newVersion) async{
    await db.execute(
        "CREATE TABLE $taskTable($taskCreatedOn INTEGER PRIMARY KEY, $taskName TEXT, " +
            "$taskDesc TEXT, $taskEditedOn INTEGER, $isCompleted BOOLEAN, $isDeleted BOOLEAN)"
    );
  }


  Future<int> insertTask(TaskModel task)async{
    Database db = await this.db;
    var result = await db.insert(taskTable, task.toMap());
    return result;
  }


  Future<List> getAllTasks() async{
    var cond = true;
    Database db = await this.db;
    var result = await db.query('$taskTable', orderBy: '"$taskCreatedOn ASC"', where: '"$isDeleted" = ?', whereArgs: [0]);

//    var result = await db.rawQuery("SELECT * FROM $taskTable ORDER BY $taskCreatedOn ASC WHERE $taskName = ?");
    return result;
  }


  Future<int> getCount() async{
    Database db = await this.db;
    var result = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT (*) FROM $taskTable ", ));
    return result;
  }


  Future<int> updateTask(TaskModel  task) async {
    var db = await this.db;

    print("object 1234 ${[task.taskCreatedOn]}         tomap ${task.toMap()} ");

    var result = await db.update(taskTable, task.toMap(), where: "$taskCreatedOn = ?",
        whereArgs: [task.taskCreatedOn]);
    return result;
  }


//  Future<int> deleteTask(int id) async{
//    int result;
//    var db = await this.db;
//    result = await db.rawDelete("DELETE FROM $taskTable WHERE  $taskCreatedOn = $id");
//    return result;
//  }
}