import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskapp/model/taskModel.dart';
import 'package:taskapp/utils/databaseUtility.dart';
import 'package:taskapp/utils/firebaseUtility.dart';

DbHelper helper = DbHelper();
FirebaseUtility fbhelper = FirebaseUtility();


class AddEditTaskView extends StatefulWidget {
  final TaskModel task;

  AddEditTaskView(this.task);

  @override
  State<StatefulWidget> createState() => AddEditTaskViewState(this.task);
}

class AddEditTaskViewState extends State {
  TaskModel task;

  AddEditTaskViewState(this.task);

  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    taskNameController.text = task.taskName;
    taskDescriptionController.text = task.taskDesc;
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            Text((task.taskCreatedOn == null) ? "Add New Task" : "Edit Task"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  TextField(
                    controller: taskNameController,
                    style: textStyle,
                    onChanged: (value) => this.updateName(),
                    decoration: InputDecoration(
                        labelText: "Task Name",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: taskDescriptionController,
                      style: textStyle,
                      onChanged: (value) => this.updateDescription(),
                      decoration: InputDecoration(
                          labelText: "Task Description",
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  CheckboxListTile(
                    title: Text("Task Completed"),
                    value: task.isCompleted,
                    onChanged: (newValue) {
                      setState(() {
                        task.is_C = !task.isCompleted;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                  )
                ],
              ),
              Container(
                height: 50,
                child: Row(
                  children: [
                    (task.taskCreatedOn == null)
                        ? Expanded(
                            flex: 2,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  onPressed: () {},
                                  child: Text("Clear"),
                                )),
                          )
                        : Expanded(
                            flex: 2,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  onPressed: () async {
                                    int result;
                                    Navigator.pop(context, true);
                                    if (task.taskCreatedOn == null) {
                                      return;
                                    }
                                    task.is_D = true;
                                    result = await helper
                                        .updateTask(task);

                                    if (result != 0) {
                                      AlertDialog alertDialog = AlertDialog(
                                        title: Text('Delete Task'),
                                        content:
                                            Text('The Task has been deleted'),
                                      );
                                      showDialog(
                                          context: context,
                                          builder: (_) => alertDialog);
                                    }
                                  },
                                  child: Text("Delete"),
                                )),
                          ),


                    Expanded(
                      flex: 2,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            onPressed: () {
                              if (task.taskCreatedOn != null) {
                                save("update");
                              }
                              else {
                                save("save");
                              }

                            },
                            child: Text("Save"),
                          )),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  void save(String value) {

    if (taskNameController.text.trim() == "") {

      AlertDialog alertDialog = AlertDialog(
        title: Text('Error'),
        content:
        Text('Kindly enter task name'),
      );
      showDialog(
          context: context,
          builder: (_) => alertDialog);
      return;
    }

    if (taskDescriptionController.text.trim() == "") {

      AlertDialog alertDialog = AlertDialog(
        title: Text('Error'),
        content:
        Text('Kindly enter task description'),
      );
      showDialog(
          context: context,
          builder: (_) => alertDialog);
      return;
    }

    task.is_C = task.isCompleted;
    task.T_E = DateTime.now().millisecondsSinceEpoch; // new DateFormat.yMd().format(DateTime.now());

    switch (value){
      case "save":
        print("item save");
        task.T_C = DateTime.now().millisecondsSinceEpoch;
        helper.insertTask(task);
        break;

      case "update":
        print("item update");
        helper.updateTask(task);
        break;

    }

    fbhelper.addTask(task);
    Navigator.pop(context, true);
  }


  void validationCheck(){

  }

  void updateName() {
    task.TN = taskNameController.text;
  }

  void updateDescription() {
    task.TD = taskDescriptionController.text;
  }
}
