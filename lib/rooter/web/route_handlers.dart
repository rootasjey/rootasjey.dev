import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/screens/about.dart';
import 'package:rootasjey/screens/home.dart';
import 'package:rootasjey/screens/posts.dart';
import 'package:rootasjey/screens/projects.dart';
import 'package:rootasjey/screens/search.dart';
import 'package:rootasjey/screens/signin.dart';
import 'package:rootasjey/screens/signup.dart';
import 'package:rootasjey/screens/undefined_page.dart';

class WebRouteHandlers {
  static Handler about = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
      About());

  static Handler home = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
      Home());

  static Handler posts = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
      Posts());

  static Handler projects = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
      Projects());

  static Handler search = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
      Search());

  static Handler signin = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
      Signin());

  static Handler signup = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
      Signup());

  static Handler undefined = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
      UndefinedPage(name: params['route'][0],));
}