


import 'package:flutter/cupertino.dart';

class LikeAnimationWidget extends StatefulWidget {

  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;
  const LikeAnimationWidget({super.key, required this.child, required this.isAnimating, required this.duration, required this.onEnd});

  @override
  State<LikeAnimationWidget> createState() => _LikeAnimationWidgetState();
}

class _LikeAnimationWidgetState extends State<LikeAnimationWidget> with SingleTickerProviderStateMixin{

  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();

    final halfDuration = widget.duration.inMilliseconds ~/2;
    controller = AnimationController(vsync: this,duration: Duration(milliseconds: halfDuration));
    scale = Tween<double>(begin: 1,end: 1.2).animate(controller);

  }

  @override
  void didUpdateWidget(covariant LikeAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if(widget.isAnimating != oldWidget.isAnimating){
      animateWidget();
    }
  }

  animateWidget()async{
    if(widget.isAnimating){
      await controller.forward();
      await controller.reverse();

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
    return ScaleTransition(scale: scale,child: widget.child,);
  }
}
