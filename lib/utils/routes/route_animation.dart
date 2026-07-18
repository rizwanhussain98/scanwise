import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedRoute extends PageRouteBuilder {
  final Widget widget;
  final AxisDirection direction;

  AnimatedRoute({required this.widget, this.direction = AxisDirection.left})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionDuration: const Duration(milliseconds: 400 ),
          reverseTransitionDuration: const Duration(milliseconds: 400),
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions
    return SlideTransition(
      position: Tween<Offset>(begin: getBeginOffset(), end: Offset.zero).animate(animation),
      child: child,
    );
  }

  Offset getBeginOffset() {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.right:
        return const Offset(-1, 0);
      case AxisDirection.left:
        return const Offset(1, 0);
      }
  }
}
