import "package:animations/animations.dart";
import "package:flutter/material.dart";

import "constants.dart";

typedef PageBuilder = Widget Function();

Route<T> sharedAxis<T>(
	PageBuilder page, [
	SharedAxisTransitionType type = SharedAxisTransitionType.scaled,
	Duration duration = Durations.standard,
]) {
	return PageRouteBuilder<T>(
		transitionDuration: duration,
		pageBuilder: (context, animation, secondaryAnimation) => page(),
		transitionsBuilder: (context, animation, secondaryAnimation, child) => SharedAxisTransition(
			transitionType: type,
			animation: animation,
			secondaryAnimation: secondaryAnimation,
			child: child,
		),
	);
}
