import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleHome extends StatelessWidget {
  const GoogleHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Welcome User!",style: TextStyle(color: Colors.green[900],fontWeight: FontWeight.bold,fontSize: 25),),
          SizedBox(height: 50,),
          MaterialButton(onPressed: ()async{
            await GoogleSignIn().signOut();
            FirebaseAuth.instance.signOut();
          },
          color: Colors.red[900],
            child: Text("Sign Out",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
          )
        ],
      ),
    );
  }
}
