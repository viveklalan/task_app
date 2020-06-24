import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:taskapp/model/taskModel.dart';
import 'package:taskapp/utils/databaseUtility.dart';
import 'package:taskapp/view/addEditTaskView.dart';

class TaskListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TaskListViewState();
}

class TaskListViewState extends State {
  DbHelper helper = DbHelper();
  List<TaskModel> tasks;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (tasks == null) {
      tasks = List<TaskModel>();
      getData();
    }
    return Scaffold(
      appBar: AppBar(title: Text("My Tasks"),),
      body: (count > 0) ? taskListItems() : noTaskView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          navigateToDetail(TaskModel("", "", null, null, false, false));
        },
        tooltip: "Add new task",
        child: new Icon(Icons.add),
      ),
    );
  }

  Widget noTaskView(){
    return Center(child: Text("No task, kindly add task"),);
  }

  StaggeredGridView taskListItems() {

    var colorList = [Colors.cyan[900],Colors.red[900],
      Colors.green[700],Colors.brown[900],
      Colors.indigo[700],Colors.deepPurple[900],
      Colors.purple[900],Colors.pink[900],];

    return  StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: count,
      itemBuilder: (BuildContext context, int index) =>  Card(
          color: colorList[Random().nextInt(colorList.length)],
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: new InkWell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Center(child: Text(this.tasks[index].taskName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                SizedBox(height: 4),
                Divider(height: 1,color: Colors.white,),
                SizedBox(height: 10),
                Text(this.tasks[index].taskDesc,style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200),),

                SizedBox(height: 8),

                Divider(height: 1,color: Colors.white,),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text("Created: ",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),),
                    AutoSizeText(readTimestamp(this.tasks[index].T_C),style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200, fontSize: 10),minFontSize: 7,),
                  ],
                ),
                Row(
                  children: [
                    Text("Last Updated: ",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),),
                    AutoSizeText(readTimestamp(this.tasks[index].T_E),style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200, fontSize: 10),minFontSize: 7,),
                  ],
                ),

              ],
            ),

            onTap: () {
              debugPrint("Tapped on " + this.tasks[index].taskName.toString());
              navigateToDetail(this.tasks[index]);
            },
          ),
        ),
      ),

      staggeredTileBuilder: (int index) =>
      new StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );




  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final tasksFuture = helper.getAllTasks();
      tasksFuture.then((result) {
        List<TaskModel> tasksList = List<TaskModel>();
        count = result.length;
        for (int i = 0; i < count; i++) {
          tasksList.add(TaskModel.fromObject(result[i]));
          debugPrint(tasksList[i].taskName);
        }
        setState(() {
          tasks = tasksList;
          count = count;
        });
        debugPrint("Items " + count.toString());
      });
    });
  }

  void navigateToDetail(TaskModel task) async{
    bool result = await Navigator.push(context,
      MaterialPageRoute(
          builder: (context) => AddEditTaskView(task)
      ),
    );
    if(result == true){
      getData();
    }
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('hh:mm a');
    var oldFormat = DateFormat('dd MMM, hh:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      time = oldFormat.format(date);
    }
    return time;
  }
}