
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram/Model/user.dart' as model;
import 'package:instagram/resources/Storage.dart';

class AuthMethods{
  final FirebaseAuth _auth =FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

// get users details ok
  Future<model.User> getUserDetails() async{
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =await _firestore.collection("users").doc(currentUser.uid).get();

    return model.User.fromsnap(snap);
  }

//sign up user
Future<String> signUpUser({
  required String email,
  required String password,
  required String usename,
  required String bio,
  required Uint8List file,
})async{
  String res ="Some error accurred";
  try{
    if(email.isNotEmpty|| password.isNotEmpty||usename.isNotEmpty||bio.isNotEmpty){
      //register user
      UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      String photoUrl = await StorageMethod().uploadImageToStorage("profileImage", file, false);

      //add user to our database

      model.User user = model.User(
        bio: bio,
        username: usename,
        uid: cred.user!.uid,
        email: email,
        photoUrl: photoUrl,
        followers: [],
        following: []
        );
      await _firestore.collection('users').doc(cred.user!.uid).set(user.tojson());
      res ="success";
    }
  }catch(e){
    res =e.toString();
  }
  return res;
}



Future<String> LoginUser({required String email , required String password}) async{

  String res ="some error occured";

  try{
    if(email.isNotEmpty || password.isNotEmpty){
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = 'success';
    }else{
      res ='Plese enter all the Fields';
    }
  }catch(e){
    res = e.toString();
  }

  return res;
}



Future<void> followUser(String cuid,String followId)async {
  try{
    DocumentSnapshot snap =await _firestore.collection("users").doc(cuid).get();
    List following = (snap.data()! as dynamic)['following'];

    if(following.contains(followId)){
      await _firestore.collection('users').doc(followId).update({
        'followers': FieldValue.arrayRemove([cuid])
      });

      await _firestore.collection('users').doc(cuid).update({
        "following": FieldValue.arrayRemove([followId])
      });
    }else{
      await _firestore.collection('users').doc(followId).update({
        'followers': FieldValue.arrayUnion([cuid])
      });

      await _firestore.collection('users').doc(cuid).update({
        "following": FieldValue.arrayUnion([followId])
      });
    }
  }catch(e){
    print(e.toString());
  }
  
}

Future<void> SignOut() async{
  await _auth.signOut();
}

}