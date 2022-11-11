import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethod{
  final FirebaseStorage _storage =FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; 

  //adding image to FirebaseStorage
  Future<String> uploadImageToStorage(String childName, Uint8List file,bool ispost) async{

    Reference ref= _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if(ispost){
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    UploadTask uploadTask =ref.putData(file);

    TaskSnapshot snapshot= await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}