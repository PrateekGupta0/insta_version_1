import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class StorageMethods{
  final FirebaseStorage _storage=FirebaseStorage.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;

  //adding image to firebase storage
  Future<String> uploadImageToStorage(String childName,Uint8List file,bool isPost) async{
    Reference ref= _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if(isPost){// as user can post multiple times so we to store multiple files
      String id=Uuid().v1();
      ref=ref.child(id);
    }
    UploadTask uploadTask= ref.putData(file);// ability to control how our file get upload on firebase storage.
    TaskSnapshot snap= await uploadTask;
    String downloadUrl=await snap.ref.getDownloadURL();//to get download url which will be stored in storage
    return downloadUrl;
  }
}
