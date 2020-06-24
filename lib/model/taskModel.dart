class TaskModel {

  String taskName;
  String taskDesc;
  int taskCreatedOn;
  int taskEditedOn;
  bool isCompleted;
  bool isDeleted;

  //Constructor
  TaskModel(this.taskName, this.taskDesc, this.taskCreatedOn, this.taskEditedOn, this.isCompleted, this.isDeleted);

  //Named constructor
  TaskModel.withID(this.taskName, this.taskDesc, this.taskCreatedOn, this.taskEditedOn, this.isCompleted, this.isDeleted);

//Getters and setters
  String get TN => taskName;
  String get TD => taskDesc;
  int get T_C => taskCreatedOn;
  int get T_E => taskEditedOn;
  bool get is_C => isCompleted;
  bool get is_D => isDeleted;


  set TN(String newPriority) {
    taskName = newPriority;
  }
  set TD(String newPriority) {
    taskDesc = newPriority;
  }
  set T_C(int newPriority) {
    taskCreatedOn = newPriority;
  }
  set T_E(int newPriority) {
    taskEditedOn = newPriority;
  }
  set is_C(bool newPriority) {
    isCompleted = newPriority;
  }
  set is_D(bool newPriority) {
    isDeleted = newPriority;
  }


  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["TN"] = taskName;
    map["TD"] = taskDesc;
    map["T_C"] = taskCreatedOn;;
    map["T_E"] = taskEditedOn;
    map["is_C"] = isCompleted;
    map["is_D"] = isDeleted;

    return map;
  }

  TaskModel.fromObject(dynamic o){
//    print("o$o");
    this.taskName = o["TN"];
    this.taskDesc = o["TD"];
    this.taskCreatedOn = o["T_C"];
    this.taskEditedOn = o["T_E"];

    this.isCompleted = (o["is_C"] == 0) || (o["is_C"] == false) ? false : true;
    this.isDeleted = (o["is_D"] == 0) || (o["is_D"] == false) ? false : true;
  }
}