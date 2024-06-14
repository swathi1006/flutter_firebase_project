import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_project/google_signin/googlehome.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInPage extends StatelessWidget {
  const GoogleSignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("WELCOME",style: TextStyle(color: Colors.red[900],fontWeight: FontWeight.bold,fontSize: 30),),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 30,),
          MaterialButton(onPressed: (){},
          color: Colors.red[900],
            minWidth: 200,
            child: Text("Login",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
          ),
          SizedBox(height: 20,),
          Text("_______or_______"),
          SizedBox(height: 20,),
          MaterialButton(
            onPressed: ()async{-
              signInWithGoogle();
             // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GoogleHome()));
            },
            minWidth: 200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(
                color: Colors.black, // Border color
                width: 2.0, // Border width
              ),
            ),
          child: Text("Login with Google"),
          )
        ],
      ),
    );
  }

  signInWithGoogle()async{

    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

   AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken:googleAuth?.idToken
    );

   UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);



  print(userCredential.user!.displayName);
  }

}
