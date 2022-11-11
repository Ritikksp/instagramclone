import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color backgroundColor;
  final String text;
  final Color textcolor;

  const FollowButton({
    super.key,
    required this.backgroundColor,
    required this.text,
    required this.textcolor,
    this.function
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 14),
      child: TextButton(
        onPressed: function,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: 27,
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(5)),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(color: textcolor),
          ),
        ),
      ),
    );
  }
}
