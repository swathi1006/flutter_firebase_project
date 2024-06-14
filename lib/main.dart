import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_project/firebase_image_storage.dart';
import 'package:flutter_firebase_project/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebaseCrud.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android
  );
  runApp( MaterialApp(
    home: FireBaseCrud(),
    //home: ImgStorage(),
  ));
}
