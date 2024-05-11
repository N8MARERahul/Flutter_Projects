import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List toDoList = [];

  //reference to Hive Box
  final _toDoBox = Hive.box('todoBox');

  //Run the method for First time Opening the App
  void createInitializeData() {
    toDoList = [
      ["Development", true],
      ["Game", false]
    ];
  }

  // Load the Data from Database
  void loadData() {
    toDoList = _toDoBox.get("TODOLIST");
  }

  //Update the Database
  void updateDatabase() {
    _toDoBox.put("TODOLIST", toDoList);
  }
}