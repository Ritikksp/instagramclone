import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/Widget/post_card.dart';
import 'package:instagram/utils/colors.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() {
    return FeedScreenState();
  }
}

class FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          "assets/images/Instagram-Wordmark-Black-Logo.wine.svg",
          color: primaryColor,
          height: 42,
        ),
        actions: [
           IconButton(
            alignment: Alignment.center,
              onPressed: (){},
                 icon: Icon(Icons.send_rounded),
              ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("posts").orderBy("datepublished",descending: true).snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }  
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return PostCard(
                snap:snapshot.data!.docs[index].data(),
              );
            },
          );       
        },
      ),
    );
  }
}
