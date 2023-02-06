import "package:animations/animations.dart";
import "package:flutter/material.dart";

import "constants.dart";

typedef PageBuilder = Function();

Route<T> sharedAxis<T>(
  PageBuilder page, [
  SharedAxisTransitionType type = SharedAxisTransitionType.scaled,
  Duration duration = Durations.normal,
]) {
  return PageRouteBuilder<T>(
    transitionDuration: duration,
    pageBuilder: (context, animation, secondaryAnimation) => page(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SharedAxisTransition(
        transitionType: type,
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      );
    },
  );
}
