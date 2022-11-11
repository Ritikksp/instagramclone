import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Widget/follow_Button.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/screens/LogIn.dart';
import 'package:instagram/utils/colors.dart';

class ProfileScreens extends StatefulWidget {
  final String uid;
  const ProfileScreens({super.key, required this.uid});

  @override
  State<ProfileScreens> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreens> {
  var userData = {};
  var userPosts = 0;
  var follower = 0;
  var following = 0;
  bool isFollowing = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var Usersnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();
      userData = Usersnap.data()!;
      //getposts
      var postsSnap = await FirebaseFirestore.instance
          .collection("posts")
          .where("uid", isEqualTo: widget.uid)
          .get();
      userPosts = postsSnap.docs.length;
      follower = Usersnap.data()!["followers"].length;
      following = Usersnap.data()!["following"].length;
      isFollowing = Usersnap.data()!['follower']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
            ),
            body: ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 35,
                              backgroundImage:
                                  NetworkImage(userData['photoUrl'])),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStateColum(userPosts, "Posts"),
                                    buildStateColum(follower, "Follower"),
                                    buildStateColum(following, "Following")
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 4),
                        child: Text(
                          userData['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 2),
                        child: Text(
                          userData['bio'],
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FirebaseAuth.instance.currentUser!.uid == widget.uid
                              ? FollowButton(
                                  backgroundColor:
                                      const Color.fromARGB(255, 27, 27, 27),
                                  text: "Edit Profile",
                                  textcolor: primaryColor,
                                  function: () async {
                                    await AuthMethods().SignOut();
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => LogIn()));
                                  },
                                )
                              : isFollowing
                                  ? FollowButton(
                                      backgroundColor: primaryColor,
                                      text: "Unfollow",
                                      textcolor: Colors.black,
                                      function: () async {
                                        await AuthMethods().followUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            userData['uid']);

                                        setState(() {
                                          isFollowing = false;
                                          follower--;
                                        });
                                      },
                                    )
                                  : FollowButton(
                                      backgroundColor: Colors.blue,
                                      text: "Follow",
                                      textcolor: Colors.white,
                                      function: () async {
                                        await AuthMethods().followUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            userData['uid']);
                                        setState(() {
                                          isFollowing = true;
                                          follower++;
                                        });
                                      },
                                    ),
                        ],
                      )
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("posts")
                        .where("uid", isEqualTo: widget.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GridView.builder(
                          shrinkWrap: true,
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                (snapshot.data! as dynamic).docs[index];

                            return Container(
                              child: Image(
                                image: NetworkImage(snap['postUrl']),
                                fit: BoxFit.cover,
                              ),
                            );
                          });
                    })
              ],
            ),
          );
  }

  Column buildStateColum(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontSize: 16),
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.w400, color: Colors.grey, fontSize: 14),
          ),
        )
      ],
    );
  }
}
