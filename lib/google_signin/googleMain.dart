import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_project/google_signin/googlehome.dart';
import 'package:flutter_firebase_project/google_signin/loginpage.dart';

import '../firebase_options.dart';
//import 'package:flutter_firebase_project/firebase_phone_auth/phoneMain.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.android
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.data == null){
                return GoogleSignInPage();
              }else{
                return GoogleHome();
              }
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}


