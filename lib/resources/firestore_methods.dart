import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = "some error occured";
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('posts', file, true); //stored in storage
      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          likes: [],
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profImage: profImage);

      _firestore
          .collection('posts')
          .doc(postId)
          .set(post.toJson()); // to store in firestore
      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      // if likes contain the uid of the user then it means that user have liked the post and now he is disliking it
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes':
              FieldValue.arrayRemove([uid]), //to remove this uid from like list
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]), //to add this uid to like list
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {// creating or seting the comment of the post in the firebase.
      String res='Some error occurred';
      try{
        if(text.isNotEmpty){
          String commentId=const Uuid().v1();
          await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set(
              {
                'profilePic': profilePic,
                'name': name,
                'uid': uid,
                'text': text,
                'commentId': commentId,
                'datePublished': DateTime.now(),
              });
          res="success";
        }
        else{
          res="Please enter text";
        }
      }catch(e){
          res=e.toString();
      }
      return res;
  }

  //deleting a post

  Future<String> deletePost(String postId) async{
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(
      String uid,
      String followId
      ) async {
    try {
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }

    } catch(e) {
      print(e.toString());
    }
  }
}
