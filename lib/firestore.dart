import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loginscreen/todo_model.dart';


class FirestoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Write a new Todo to Firestore
  Future write(TodoModel todo) async {
    try {
      final res = await _firestore.collection("todos").doc().set(todo.toJSON());
      return res;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Read all Todos from Firestore
  Stream<QuerySnapshot> read() {
    try {
      final res = _firestore.collection("todos").snapshots();
      return res;
    } catch (e) {
      print(e.toString());
      return Stream.empty();
    }
  }

  // Delete a Todo by ID
  Future delete(String id) async {
    try {
      final res = await _firestore.collection("todos").doc(id).delete();
      return res;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Update a Todo by ID
  Future update(String id, TodoModel todo) async {
    try {
      final res = await _firestore.collection("todos").doc(id).update(todo.toJSON());
      return res;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}