import 'package:flutter/material.dart';

class NavigationService {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  //Method to pop the topmost route from the nav stack.
  void pop() {
    return _navigationKey.currentState.pop();
  }

  // Method to navigate to a given routename with given arguments.
  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState
        .pushNamed(routeName, arguments: arguments);
  }

  // Method to replace the current route and then navigate to a given routename with given arguments.
  Future<dynamic> navigateReplacement(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState
        .pushReplacementNamed(routeName, arguments: arguments);
  }
}
