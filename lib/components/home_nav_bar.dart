import 'package:flutter/material.dart';
import 'package:rootasjey/screens/about.dart';
import 'package:rootasjey/screens/contact.dart';
import 'package:rootasjey/screens/enroll.dart';
import 'package:rootasjey/screens/posts.dart';
import 'package:rootasjey/screens/pricing.dart';
import 'package:rootasjey/screens/projects.dart';
import 'package:rootasjey/state/colors.dart';

class HomeNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        if (boxConstraints.maxWidth < 600.0) {
          return narrowView(context);
        }

        return largeView(context);
      }
    );
  }

  Widget buttonLink({
    @required BuildContext context,
    @required IconData icon,
    @required String titleText,
    @required Widget widgetRoute,
  }) {
    return FlatButton.icon(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return widgetRoute;
            },
          ),
        );
      },
      icon: Icon(icon),
      label: Text(
        titleText,
      ),
    );
  }

  Widget cardLink({
    @required BuildContext context,
    @required IconData icon,
    @required String titleText,
    @required Widget widgetRoute,
  }) {
    return SizedBox(
      width: 120.0,
      height: 120.0,
      child: Card(
        elevation: 4.0,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) {
                  return widgetRoute;
                },
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              Text(
                titleText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget narrowView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20.0,
        bottom: 60.0,
        left: 20.0,
      ),
      child: Wrap(
        spacing: 20.0,
        runSpacing: 20.0,
        alignment: WrapAlignment.center,
        children: [
          cardLink(
            context: context,
            icon: Icons.work,
            titleText: 'Enroll',
            widgetRoute: Enroll(),
          ),

          cardLink(
            context: context,
            icon: Icons.apps,
            titleText: 'Projects',
            widgetRoute: Projects(),
          ),

          cardLink(
            context: context,
            icon: Icons.edit,
            titleText: 'Posts',
            widgetRoute: Posts(),
          ),

          cardLink(
            context: context,
            icon: Icons.attach_money,
            titleText: 'Pricing',
            widgetRoute: Pricing(),
          ),

          cardLink(
            context: context,
            icon: Icons.email_outlined,
            titleText: 'Contact me',
            widgetRoute: Contact(),
          ),

          cardLink(
            context: context,
            icon: Icons.help_center,
            titleText: 'About',
            widgetRoute: About(),
          ),
        ],
      ),
    );
  }

  Widget largeView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 60.0,
        left: 100.0,
      ),
      child: Wrap(
        spacing: 40.0,
        runSpacing: 20.0,
        children: [
          RaisedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return Enroll();
                  },
                ),
              );
            },
            color: stateColors.primary,
            textColor: Colors.white,
            icon: Icon(Icons.work),
            label: Text(
              'Enroll',
            ),
          ),

          buttonLink(
            context: context,
            icon: Icons.apps,
            titleText: 'Projects',
            widgetRoute: Projects(),
          ),

          buttonLink(
            context: context,
            icon: Icons.edit,
            titleText: 'Posts',
            widgetRoute: Posts(),
          ),

          buttonLink(
            context: context,
            icon: Icons.attach_money,
            titleText: 'Pricing',
            widgetRoute: Pricing(),
          ),

          buttonLink(
            context: context,
            icon: Icons.email_outlined,
            titleText: 'Contact me',
            widgetRoute: Contact(),
          ),

          buttonLink(
            context: context,
            icon: Icons.help_center,
            titleText: 'About',
            widgetRoute: About(),
          ),
        ],
      ),
    );
  }

}
