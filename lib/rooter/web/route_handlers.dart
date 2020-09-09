import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/screens/about.dart';
import 'package:rootasjey/screens/contact.dart';
import 'package:rootasjey/screens/enroll.dart';
import 'package:rootasjey/screens/home.dart';
import 'package:rootasjey/screens/me.dart';
import 'package:rootasjey/screens/new_post.dart';
import 'package:rootasjey/screens/post_page.dart';
import 'package:rootasjey/screens/posts.dart';
import 'package:rootasjey/screens/pricing.dart';
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

  static Handler contact = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
      Contact());

  static Handler enroll = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
      Enroll());

  static Handler me = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
      Me());

  static Handler newPost = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
      NewPost());

  static Handler post = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
      PostPage(id: params['id'][0],));

  static Handler posts = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
      Posts());

  static Handler pricing = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
      Pricing());

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