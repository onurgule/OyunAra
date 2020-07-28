import 'package:OyunAra/main.dart';
import 'package:OyunAra/screens/filters_screen.dart';
import 'package:OyunAra/screens/home_screen.dart';
import 'package:OyunAra/screens/main2.dart';
import 'package:OyunAra/splash.dart';
import 'package:flutter/material.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.INITIAL_ROUTE:
        return MaterialPageRoute(builder: (_) => IntroScreen());
      case Routes.SPLASH:
        return MaterialPageRoute(builder: (_) => Splash());
      case Routes.ONBOARDING:
        return MaterialPageRoute(builder: (_) => IntroScreen());
      case Routes.HOME:
        return MaterialPageRoute(builder: (_) => MyAppHome());
      case Routes.FILTER_SCREEN:
        return MaterialPageRoute(builder: (_) => FiltersScreen());
      case Routes.ERROR:
        return MaterialPageRoute(builder: (_) => MyHomePage());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}

class HomeScreen {}

class Routes {
  static const String INITIAL_ROUTE = "/";
  static const String HOME = "/mainPage";
  static const String SPLASH = "/splash";
  static const String ONBOARDING = "/onboarding";
  static const String FILTER_SCREEN = "/filter";
    static const String ERROR = "/errorPage";
}
