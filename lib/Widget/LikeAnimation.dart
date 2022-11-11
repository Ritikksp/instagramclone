

import 'package:flutter/cupertino.dart';

class LikeAnimation extends StatefulWidget{
  final Widget child;
  final bool isAnimation;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallLikes;

  const LikeAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 150),
    required this.isAnimation,
    this.onEnd,
    this.smallLikes=false
    });

  @override
  State<LikeAnimation> createState(){
    return LikeAnimationState();
  }
}

class LikeAnimationState extends State<LikeAnimation> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this,duration: Duration(milliseconds: widget.duration.inMilliseconds ~/2));
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.isAnimation != oldWidget.isAnimation){
      startAnimation();
    }
  }

  startAnimation()async{
    if(widget.isAnimation || widget.smallLikes){
      await controller.forward();
      await controller.reverse();
      await Future.delayed(const Duration(milliseconds: 200,),);

      if(widget.onEnd != null){
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
      );
  }
}