import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginscreen/firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginscreen/todo_model.dart';
// import 'package:pro';
import 'package:loginscreen/signinscreen.dart';
import 'package:loginscreen/signupscreen.dart';

class Home extends StatefulWidget {
  Home({super.key, required this.user});
  final User user;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthServices authService = AuthServices();
  final FirestoreServices firestoreServices = FirestoreServices();

  // Controllers for TextField input
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Track whether we're editing an existing todo
  bool isEditing = false;
  String? currentTodoId;

  // Function to clear the form fields and reset the state
  void clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      isEditing = false;
      currentTodoId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 123, 0),
        title: Text(user?.displayName ?? ""),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () async {
              await authService.signOut();
            },
          ),
        ],
        leading: user != null
            ? Container(
                clipBehavior: Clip.hardEdge,
                margin: const EdgeInsets.all(5),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(100)),
                child: Image.network(user.photoURL!),
              )
            : SizedBox(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isNotEmpty &&
                    _descriptionController.text.isNotEmpty) {
                  if (isEditing && currentTodoId != null) {
                    // Update the existing todo
                    await firestoreServices.update(
                      currentTodoId!,
                      TodoModel(
                        title: _titleController.text,
                        des: _descriptionController.text,
                        time: DateTime.now(),
                        description: '',
                      ),
                    );
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Todo updated!')));
                  } else {
                    // Add a new todo
                    await firestoreServices.write(
                      TodoModel(
                        title: _titleController.text,
                        des: _descriptionController.text,
                        time: DateTime.now(),
                        description: '',
                      ),
                    );
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Todo added!')));
                  }

                  // Clear form after submission
                  clearForm();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in both fields')),
                  );
                }
              },
              child: Text(isEditing ? "Update Todo" : "Add Todo"),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot?>(
              stream: firestoreServices.read(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                final data = snapshot.data!;
                return ListView.builder(
                  itemCount: data.docs.length,
                  itemBuilder: (context, index) {
                    final docData = data.docs[index];
                    return ListTile(
                      title: Text(docData["title"]),
                      // subtitle: Text(docData["des"]),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Pre-fill the fields with the selected todo's data
                                setState(() {
                                  _titleController.text = docData["title"];
                                  _descriptionController.text = docData["des"];
                                  isEditing = true;
                                  currentTodoId = docData.id;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await firestoreServices.delete(docData.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Todo deleted!')));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AuthServices {
  signOut() {}
}

// extension on BuildContext {
//   watch() {}
// }


