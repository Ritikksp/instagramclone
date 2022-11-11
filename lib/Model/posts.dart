
import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datepublished;
  final String postUrl;
  final String profImage;
  final likes;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datepublished,
    required this.profImage,
    required this.likes,
    required this.postUrl
  });

  Map<String, dynamic> tojson() =>{
    "description":description,
    "uid":uid,
    "username":username,
    "postId":postId,
    "postUrl":postUrl,
    "datepublished":datepublished,
    "profImage":profImage,
    "likes":likes
  };

  static Post fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot["description"], 
      uid: snapshot["uid"], 
      username: snapshot["username"], 
      postId: snapshot["postId"], 
      datepublished: snapshot["datepublished"], 
      profImage: snapshot["profImage"], 
      likes: snapshot["likes"], 
      postUrl: snapshot["postUrl"]
      );
  }

}