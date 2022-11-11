import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/Model/user.dart';
import 'package:instagram/Widget/Comment_card.dart';
import 'package:instagram/provider/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/responsive/mobile_screens_layout.dart';
import 'package:instagram/screens/feed_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() {
    return CommentScreenState();
  }
}

class CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentControler = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentControler.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Comments"),
        actions: [
          IconButton(
              padding: EdgeInsets.symmetric(horizontal: 18),
              onPressed: () {},
              icon: SvgPicture.asset(
                  "assets/images/paper-plane-svgrepo-com.svg",
                  color: primaryColor))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished',descending: true)
            .snapshots(),
          builder: (context ,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) => CommentCard(
                snap:(snapshot.data! as dynamic).docs[index].data(),
              ) );
          },
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
                radius: 18, backgroundImage: NetworkImage(user.photoUrl)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: TextField(
                  controller: _commentControler,
                  decoration: InputDecoration(
                      hintText: "comments as ${user.username}..",
                      border: InputBorder.none),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await firestoreMethods().postComment(
                    widget.snap['postId'],
                    _commentControler.text,
                    user.uid,
                    user.username,
                    user.photoUrl);

                    setState(() {
                      _commentControler.text = "";
                    });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Text(
                  "Post",
                  style: TextStyle(color: blueColor),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
