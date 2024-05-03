import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:random_string/random_string.dart';
import 'package:todo_app/db_service/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool personal = true, professional = false;
  bool suggest = false;
  TextEditingController todoController = TextEditingController();
  Stream? todoStream;

  getOnTheLoad() async {
    todoStream =
        await DatabaseService().getTask(personal ? "Personal" : "Professional");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget getWork() {
    return StreamBuilder(
        stream: todoStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData ?
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot docSnap = snapshot.data.docs[index];
                      return CheckboxListTile(
                        activeColor: Colors.greenAccent.shade400,
                        title: Text(docSnap["work"]),
                        value: docSnap["isDone"],
                        onChanged: (newValue) async {
                            await DatabaseService().tickMethod(
                                docSnap["Id"],
                                personal ? "Personal" : "Professional");
                          setState(() {
                            Future.delayed(Duration(seconds: 2), () {
                            DatabaseService().removeMethod(
                                docSnap["Id"],
                                personal ? "Personal" : "Professional"
                            );
                            });
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    }
                ),
              )
              : Center(child: CircularProgressIndicator());
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent.shade400,
        onPressed: () {
          openBox();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 70, left: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.white,
          Colors.white38,
          Colors.white12,
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                'Your TODO\'s',
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                personal
                    ? Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Personal',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          personal = true;
                          professional = false;
                          await getOnTheLoad();
                          setState(() {});
                        },
                        child: Text('Personal',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ),
                professional
                    ? Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Professional',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          personal = false;
                          professional = true;
                          await getOnTheLoad();
                          setState(() {});
                        },
                        child: Text('Professional',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            getWork(),
          ],
        ),
      ),
    );
  }

  Future openBox() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.cancel),
                          ),
                          SizedBox(
                            width: 60,
                          ),
                          Text(
                            'Add ToDo Task',
                            style: TextStyle(
                              color: Colors.greenAccent.shade400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Add Text'),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Colors.black,
                          width: 2,
                        )),
                        child: TextField(
                          controller: todoController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter the Task',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          width: 100,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              String id = randomAlphaNumeric(10);
                              Map<String, dynamic> userTodo = {
                                "work": todoController.text,
                                "Id": id,
                                "isDone" : false,
                              };
                              personal
                                  ? DatabaseService()
                                      .addPersonalTask(userTodo, id)
                                  : DatabaseService()
                                      .addProfessionalTask(userTodo, id);
                              Navigator.pop(context);
                              todoController.clear();
                            },
                            child: Center(
                              child: Text(
                                'Add Task',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
