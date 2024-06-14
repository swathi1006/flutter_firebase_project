import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireBaseCrud extends StatefulWidget {
  @override
  State<FireBaseCrud> createState() => _FireBaseCrudState();
}

class _FireBaseCrudState extends State<FireBaseCrud> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  late CollectionReference _userCollection;

  @override
  void initState() {
    _userCollection = FirebaseFirestore
        .instance.collection("users");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text("Add User Data"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 15,),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 15,),
            MaterialButton(
              onPressed: (){
                addUser();
              },
              minWidth: 100,
              color: Colors.pink,
              shape: const StadiumBorder(),
              child: const Text("Add User"),
            ),
            const SizedBox(height: 20,),
            // StreamBuilder listen to the Query Stream (here getUser() method)
            // rebuilds the ui whenever there is a new data
            StreamBuilder<QuerySnapshot>(
                stream: getUser(),
                // result of an asynchronous operation AsyncSnapshot (it contains,
                //  connection state, error, data etc)
                builder: (context, AsyncSnapshot snapshot){
                  if(snapshot.hasError){
                    return Center(
                      child: Text("Error : ${snapshot.error}"),
                    );
                  }if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  // docs.Gets a list of all the documents included
                  // in this snapshot
                  final users = snapshot.data!.docs;

                  return Expanded(child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context,index){
                        final user = users[index];
                        final userId = user.id;
                        final username = user["name"];
                        final usermail = user['email'];
                        return Card(
                          child: ListTile(
                            title: Text(username),
                            subtitle: Text(usermail),
                            trailing: Wrap(children: [
                              IconButton(
                                  onPressed: (){
                                    editUser(userId,username,usermail);
                                  },
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: (){
                                    deleteUser(userId);
                                  },
                                  icon: const Icon(Icons.delete))
                            ],),
                          ),
                        );
                      }));
                })
          ],
        ),
      ),
    );
  }

  Future<void> addUser(){
    return _userCollection
        .add({'name':nameController.text,'email':emailController.text})
        .then((value){
      print("User added Successfully");
      nameController.clear();
      emailController.clear();
    }).catchError((error){
      print("Failed to add User : $error");
    });

  }
  // QuerySnapshot  contains result of query(data from fire store)
  // and metadata (additional information like errors warnings etc)
  Stream<QuerySnapshot> getUser(){
    return _userCollection.snapshots();
  }

  void editUser(userId, username, usermail) {
    showDialog(context: context,
        builder: (context){
          final newnameController = TextEditingController(text: username);
          final newemailController = TextEditingController(text: usermail);
          return AlertDialog(
            title: const Text("Edit User"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: newnameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Name"
                  ),
                ),
                const SizedBox(height: 18,),
                TextField(
                  controller: newemailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Email"
                  ),
                ),

              ],),
            actions: [
              MaterialButton(onPressed: (){
                updateUser(userId,newnameController.text,newemailController.text)
                    .then((v){
                  Navigator.pop(context);
                });
              },
                color: Colors.green,
                minWidth: 80,
                child: const Text("Update User"),
              ),
              MaterialButton(onPressed: (){
                Navigator.pop(context);
              },
                color: Colors.blue,
                minWidth: 80,
                child: const Text("Cancel"),
              ),],
          );
        });
  }

  Future <void> updateUser(String id,String uname, String umail) {
    return _userCollection.doc(id)
        .update({'name':uname,'email':umail})
        .then((value){
      print("User updated successfully");
    }).catchError((error){
      print("Failed to update user $error");
    });
  }

  Future <void> deleteUser(String id) {
    return _userCollection.doc(id).delete().then((v){
      print("User deleted successfully");
    }).catchError((error){
      print("Failed to delete user $error");
    });
  }

}
