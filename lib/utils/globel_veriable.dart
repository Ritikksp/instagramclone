import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/add_post_screem.dart';
import 'package:instagram/screens/feed_screen.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/screens/search_screen.dart';

const webScreenSize =600;

 List<Widget> HomeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text("favorite"),
  ProfileScreens(uid: FirebaseAuth.instance.currentUser!.uid,)
];
