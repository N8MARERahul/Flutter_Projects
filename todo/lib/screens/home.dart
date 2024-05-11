import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../components/dialogBox.dart';
import '../components/todo_tiles.dart';
import '../data/database.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //reference to Hive Box
  final _toDoBox = Hive.box('todoBox');

  //Text Controller
  final _controller = TextEditingController();

  //ToDo List
  // List toDoList = [
  //   ["Development", true],
  //   ["Game", false]
  // ];

  //Database Instance
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {

    //if the app runs First Time
    if (_toDoBox.get("TODOLIST") == null) {
      db.createInitializeData();
    } else {
      // If there already exists Data
      db.loadData();
    }

    super.initState();
  }

  void onChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDatabase();
  }

  //Save New Task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  //Create New Task
  void createNewTask() {
    showDialog(context: context, builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  //Delete Task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        centerTitle: true,
        title: Text('ToDo'),
        elevation: 10,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Creating New Task button
          createNewTask();
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0],
            isDone: db.toDoList[index][1],
            onChanged: (value) => onChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }

}
