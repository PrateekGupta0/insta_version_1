import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'dart:typed_data';

import 'package:instagram_clone/resources/storage_methods.dart';
class AuthMethods{
  final FirebaseAuth _auth =FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;


  //to get user details which will be stored in userprovider file
  Future<model.User> getUserDetails() async{
    User currentUser =  _auth.currentUser!;
    DocumentSnapshot snap =await _firestore.collection('users').doc(currentUser.uid).get();// to get snap of urrent user details
    return model.User.fromSnap(snap);
  }
  //sign up user
  Future <String> signUpUser({required String email,required String password,required String username,required String bio,required Uint8List file}) async{
      String res ="Some error occured";
      try{
        if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty || file != null){
          //register the user
          UserCredential cred=await _auth.createUserWithEmailAndPassword(email: email, password: password);
          
          //to upload image to storage
          String photoUrl=await StorageMethods().uploadImageToStorage('profilePics', file, false);

          //add user to firebase               // so that user id is same as collection id can also be done using add
          model.User user=model.User(username: username, uid: cred.user!.uid, photoUrl: photoUrl, email: email, bio: bio, followers: [], following: []);
          await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
          res="success";
        }
      }on FirebaseAuthException catch(err){
        if(err.code == 'invalid-email'){
          res='The email is badly formated';
        }
        else if(err.code == 'weak-password'){
          res='Password should be at least 6 character';
        }
      }

      return res;
  }

  //logging in user
  Future<String> loginUser({required String email,required String password}) async{
    String res="Some error occurred";

    try{
        if(email.isNotEmpty || password.isNotEmpty){
          await _auth.signInWithEmailAndPassword(email: email, password: password);
          res="success";
        }
        else{
          res="Please enter all the fields";
        }
    }
    catch(err){
        res=err.toString();
    }

    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

