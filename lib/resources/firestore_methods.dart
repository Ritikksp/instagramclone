
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram/Model/posts.dart';
import 'package:instagram/resources/Storage.dart';
import 'package:uuid/uuid.dart';

class firestoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadImage(
    String description,
    Uint8List _file,
    String uid,
    String username,
    String profileimage,
  )async{
    String ress="Some error accured";
    try{
      String photoUrl = await StorageMethod().uploadImageToStorage("posts", _file, true);

      String postid = const Uuid().v1();

      Post post= Post(
        datepublished: DateTime.now(),
        uid: uid,
        description: description,
        username: username,
        postId: postid,
        postUrl: photoUrl,
        profImage: profileimage,
        likes: []
      );

      _firestore.collection("posts").doc(postid).set(
        post.tojson(),
      );
      ress="success";
    }catch(err){
      ress=err.toString();
    }
    return ress;
  }

  Future<void> likePost(String postId, String uid, List likes)async{
    try{
      if(likes.contains(uid)){
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
          });
      }
      else{
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }

    }catch(e){
      print(e.toString());
    }
  }

  Future<void> postComment(String postId,String text, String uid,String name,String profilepic)async{
    try{
      if(text.isNotEmpty){
        String commentId= const Uuid().v1();
        await _firestore.collection('posts').doc(postId).collection("comments").doc(commentId).set({
          'profilePic':profilepic,
          'name':name,
          'text':text,
          'uid':uid,
          'commentId':commentId,
          'datePublished':DateTime.now()
        });
      }else{
        print("text is empty");
      }
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId)async{
    try{
      _firestore.collection('posts').doc(postId).delete();
    }catch(e){
      print(e.toString());
    }
  }

}