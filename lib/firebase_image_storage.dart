import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class ImgStorage extends StatefulWidget {
  const ImgStorage({super.key});

  @override
  State<ImgStorage> createState() => _ImgStorageState();
}

class _ImgStorageState extends State<ImgStorage> {

  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text("Store and Retrive Your Images"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () async{
                    if(await Permission.camera.request().isGranted){
                    open("camera");
                    }else{
                      print("Camera access denied");
                    }
                    },
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text("Camera"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),),
                ElevatedButton.icon(
                  onPressed: () async{
                    if(await Permission.storage.request().isGranted) {
                      open("gallery");
                    }else{
                      print("Gallery access denied");
                    }
                    },
                  icon: const Icon(Icons.photo_camera_back_outlined),
                  label: const Text("Gallery"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),),
              ],
            ),
            const SizedBox(height: 50,),

            Expanded(
                child: FutureBuilder(
                    future: fetchImage(),
                    builder: (context,snapshot){
                      if(snapshot.connectionState == ConnectionState.done){
                        return GridView.builder(
                          itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context,index){
                            final image = snapshot.data![index];
                            return Card(
                              child: Column(
                                children: [
                                  Expanded(child: Image.network(image['imageUrl'])),
                                  Text(image['uploaded_by']),
                                  Text(image['time']),
                                  MaterialButton(
                                    onPressed: () =>  deleteImage(image['path']),
                                  minWidth: 100,
                                  color: Colors.red,
                                  shape: const StadiumBorder(),
                                  child: const Text("Delete"),)
                                ],
                              ),
                            );
                            },
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }))
          ],
        ),
      ),
    );
  }

  Future<void> open(String imgSource) async{

    final imgPicker = ImagePicker();
    XFile? pickedImage;

    try{
      pickedImage = await imgPicker.pickImage(
          source: imgSource == 'camera'
          ? ImageSource.camera
          : ImageSource.gallery);
  // path.basename - extract only the image name from entire path
      final String imgFileName = path.basename(pickedImage!.path);
      File imageFile = File(pickedImage.path); // actual path of image file

   try{
     await storage.ref(imgFileName).putFile(
         imageFile,
         SettableMetadata(
             customMetadata: {
           "uploadedBy" : "xxxxxx",
           "time"  : "${DateTime.now().isUtc}"
         })
     );
   }on FirebaseException catch (error){
     print("Exception occured while uploading picture $error");
   }
    }catch(error){
      print("Exception during file fetching $error");
    }
  }
  Future <List<Map<String,dynamic>>> fetchImage () async{
    List<Map<String,dynamic>> images = [];
    // ListResult class holds the list of values and its metadatas as a result of list listall methods
    final ListResult result = await storage.ref().list();
    // reference of each item stored in firebase storage
    final List<Reference> allFiles = result.items;

    await Future.forEach(allFiles, (singleFile)async {
      final String fileUrl = await singleFile.getDownloadURL();
      final FullMetadata metadata = await singleFile.getMetadata();

      images.add({
        'imageUrl'    : fileUrl,
         'path'       : singleFile.fullPath,
        'uploaded_by' : metadata.customMetadata?['uploadedby'] ?? 'NoData',
        'time'        : metadata.customMetadata?['time'] ?? 'No Data'
      });
    });
    return images;
  }

  Future<void> deleteImage(String imagePath) async{
    await storage.ref(imagePath).delete();
    setState(() {});
  }
}
