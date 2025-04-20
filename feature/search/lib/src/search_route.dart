import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

class SearchRoute implements RouteSearch {
  static const routeName = '/search';

  @override
  void push(BuildContext context, Catalog catalog) {
    Navigator.pushNamed(context, routeName, arguments: catalog);
  }
}
