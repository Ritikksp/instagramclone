import 'package:flutter/material.dart';
import 'package:instagram/Model/user.dart';
import 'package:instagram/provider/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({super.key,required this.snap});

  @override
  State<CommentCard> createState() {
    return CommentCardState();
  }
}

class CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
                widget.snap['profilePic']
                ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: widget.snap['name'],
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: " ${widget.snap['text']}",
                      style: const TextStyle(fontSize: 13)
                    )
                  ])),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: const Icon(Icons.favorite_border,size: 16,),
          )
        ],
      ),
    );
  }
}
