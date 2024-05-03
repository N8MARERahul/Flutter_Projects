import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future addPersonalTask(
      Map<String, dynamic> userPersonalMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('Personal')
        .doc(id)
        .set(userPersonalMap);
  }
  Future addProfessionalTask(
      Map<String, dynamic> userProfessionalMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('Professional')
        .doc(id)
        .set(userProfessionalMap);
  }

  Future <Stream<QuerySnapshot>> getTask(String task) async {
    return await FirebaseFirestore.instance.collection(task).snapshots();
  }

  tickMethod(String id, String task) async {
    return await FirebaseFirestore.instance
        .collection(task).doc(id).update({"isDone" : true});
  }
  removeMethod(String id, String task) async {
    return await FirebaseFirestore.instance
        .collection(task).doc(id).delete();
  }
}
