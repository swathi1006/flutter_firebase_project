// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';
import 'data.dart';
//import 'firebase_options.dart';
import 'homesyll.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.android
  );
  runApp(SyllabusApp());
}

class SyllabusApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syllabus App',
      home: CoursesScreen(),
    );
  }
}

