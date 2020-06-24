
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:taskapp/main.dart';
import 'package:taskapp/model/taskModel.dart';
import 'package:taskapp/view/addEditTaskView.dart';

class SplashScreenView extends StatefulWidget {
  @override
  _SplashScreenViewState createState() => new _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  List<TaskModel> tasks;


  @override
  Widget build(BuildContext context) {

    getDataFromLocalAndSync();

    return new SplashScreen(
        seconds: 5,
        navigateAfterSeconds: new MyHomePage(title: 'Tasks'),
        title: new Text('My Tasks',
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35.0
          ),),
        image: new Image.asset("icon/icon.png"),
        backgroundColor: Colors.deepOrange,
        photoSize: 100.0,
        loaderColor: Colors.white
    );
  }
}

void getDataFromFirebaseAndSync() {

  final userid = fbhelper.userID();
  userid.then((uid){

    print("uid :  $uid");
    if(uid != "") {
      final tasksFuture = fbhelper.getAllTasks();
      tasksFuture.then((result) {
        int count = result.length;
        for (int i = 0; i < count; i++) {
          helper.updateTask(result[i]);
        }
      });
    }

  });

}

void getDataFromLocalAndSync() {

  final dbFuture = helper.initializeDb();
  dbFuture.then((result) {

    final tasksFuture = helper.getAllTasks();
    tasksFuture.then((result) {
      int count = result.length;
      if(count > 0) {
        print("count :  $count");
        for (int i = 0; i < count; i++) {
          fbhelper.addTask(TaskModel.fromObject(result[i]));
        }
      }else{
        getDataFromFirebaseAndSync();
      }

    });

  });
}