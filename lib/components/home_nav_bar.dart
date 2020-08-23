import 'package:flutter/material.dart';
import 'package:rootasjey/rooter/route_names.dart';
import 'package:rootasjey/rooter/router.dart';
import 'package:rootasjey/state/colors.dart';

class HomeNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 60.0,
        left: 100.0,
      ),
      child: Wrap(
        spacing: 40.0,
        runSpacing: 20.0,
        children: [
          RaisedButton.icon(
            onPressed: () {},
            color: stateColors.primary,
            textColor: Colors.white,
            icon: Icon(Icons.work),
            label: Text(
              'Hire me!',
            ),
          ),

          FlatButton.icon(
            onPressed: () {
              FluroRouter.router.navigateTo(context, ProjectsRoute);
            },
            icon: Icon(Icons.apps),
            label: Text(
              'Projects'
            ),
          ),

          FlatButton.icon(
            onPressed: () {
              FluroRouter.router.navigateTo(context, PostsRoute);
            },
            icon: Icon(Icons.edit),
            label: Text(
              'Posts'
            ),
          ),

          FlatButton.icon(
            onPressed: () {},
            icon: Icon(Icons.help),
            label: Text(
              'About'
            ),
          ),
        ],
      ),
    );
  }
}
