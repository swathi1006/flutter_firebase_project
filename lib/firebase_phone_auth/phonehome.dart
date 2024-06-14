import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final user = FirebaseAuth.instance.currentUser;

  signOut() async{
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text("Welcome ${user!.phoneNumber}",
                style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
          MaterialButton(onPressed: (){
            signOut();
          },
            child: Text("Sign Out"),
            color: Colors.blue,
          )
        ],
      ),

    );
  }
}
