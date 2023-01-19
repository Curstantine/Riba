import 'package:flutter/material.dart';
import 'package:riba/routes/home/page.dart';

class Router {
  static const String home = '/';

  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const Home());
    }

    return null;
  }
}
