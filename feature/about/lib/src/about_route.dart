import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

class AboutRoute implements RouteAbout{

  static const routeName = '/about';

  @override
  void push(BuildContext context) {
    Navigator.pushNamed(
      context,
      routeName,
    );
  }
  
}