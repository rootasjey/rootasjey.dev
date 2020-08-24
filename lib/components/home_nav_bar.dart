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
            onPressed: () {
              FluroRouter.router.navigateTo(context, ContactRoute);
            },
            color: stateColors.primary,
            textColor: Colors.white,
            icon: Icon(Icons.work),
            label: Text(
              'Contact me',
            ),
          ),

          FlatButton.icon(
            onPressed: () {
              FluroRouter.router.navigateTo(context, ProjectsRoute);
            },
            icon: Opacity(
              opacity: 0.6,
              child: Icon(Icons.apps),
            ),
            label: Text(
              'Projects'
            ),
          ),

          FlatButton.icon(
            onPressed: () {
              FluroRouter.router.navigateTo(context, PostsRoute);
            },
            icon: Opacity(
              opacity: 0.6,
              child: Icon(Icons.edit),
            ),
            label: Text(
              'Posts'
            ),
          ),

          FlatButton.icon(
            onPressed: () {
              FluroRouter.router.navigateTo(context, PricingRoute);
            },
            icon: Opacity(
              opacity: 0.6,
              child: Icon(Icons.attach_money),
            ),
            label: Text(
              'Pricing'
            ),
          ),

          FlatButton.icon(
            onPressed: () {
              FluroRouter.router.navigateTo(context, AboutRoute);
            },
            icon: Opacity(
              opacity: 0.6,
              child: Icon(Icons.help),
            ),
            label: Text(
              'About'
            ),
          ),
        ],
      ),
    );
  }
}
