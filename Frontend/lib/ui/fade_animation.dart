import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    /*final tween = MultiTween([
      Track("opacity").add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
      Track("translateY").add(
          Duration(milliseconds: 500), Tween(begin: -30.0, end: 0.0),
          curve: Curves.easeOut)
    ]);*/

    final tween = MultiTween()
        ..add("opacity", Tween(begin: 0.0, end: 1.0), Duration(milliseconds: 500))
        ..add("translateY", Tween(begin: -30.0, end: 0.0), Duration(milliseconds: 500), Curves.easeOut);

    return CustomAnimation(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, animation) => Opacity(

        opacity: (animation as MultiTweenValues<dynamic>).get("opacity"),
        child: Transform.translate(
            offset: Offset(0, (animation as MultiTweenValues<dynamic>).get("translateY")),
            child: child
        ),
      ),
    );
  }
}