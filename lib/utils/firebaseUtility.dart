import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:taskapp/model/taskModel.dart';

class FirebaseUtility {
  static final FirebaseUtility _fbHelper = FirebaseUtility._internal();

  final FirebaseAuth auth = FirebaseAuth.instance;


  //named constructor
  FirebaseUtility._internal();

  //Factory constructor
  factory FirebaseUtility(){
    return _fbHelper;
  }

  static final String _rootPath = 'tasks/';
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  final StreamController<List<TaskModel>> _streamController =
  StreamController<List<TaskModel>>();

  Future<void> addTask(TaskModel task) async {
    await _databaseTaskReference().child(await userID()).child("${task.taskCreatedOn}").update(task.toMap());
  }

  Future<void> deleteTask(TaskModel task) async {
    await _databaseTaskReference().child(await userID()).child("${task.taskCreatedOn}").remove();
  }

  @override
  void dispose() {
    _streamController.close();
  }

  Future<List<TaskModel>> getAllTasks() async{
    var snapshot = await _databaseTaskReference().child(await userID()).once();
    List<TaskModel> tasksList = List<TaskModel>();

    if (snapshot.value != null) {
      var result = snapshot.value.values as Iterable;
      for (var value in result) {
      tasksList.add(TaskModel.fromObject(value));

      print("object  - -  $result");
      print("tasksList  - -  ${TaskModel.fromObject(value).taskCreatedOn}");
      }
    }
    return tasksList;
  }




  DatabaseReference _databaseTaskReference() =>
      FirebaseDatabase.instance.reference().child('$_rootPath');

  DatabaseReference _databaseReference() =>
      FirebaseDatabase.instance.reference().child('$_rootPath/$userID');

  Future<String> userID() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return uid;
  }
}