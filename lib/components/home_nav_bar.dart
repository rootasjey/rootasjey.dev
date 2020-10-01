import 'package:flutter/material.dart';
import 'package:rootasjey/router/route_names.dart';
import 'package:rootasjey/router/router.dart';
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
    @required String route,
  }) {
    return FlatButton.icon(
      onPressed: () => FluroRouter.router.navigateTo(context, route),
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
    @required String route,
  }) {
    return SizedBox(
      width: 120.0,
      height: 120.0,
      child: Card(
        elevation: 4.0,
        child: InkWell(
          onTap: () => FluroRouter.router.navigateTo(context, route),
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
            route: EnrollRoute,
          ),

          cardLink(
            context: context,
            icon: Icons.apps,
            titleText: 'Projects',
            route: ProjectsRoute,
          ),

          cardLink(
            context: context,
            icon: Icons.edit,
            titleText: 'Posts',
            route: PostsRoute,
          ),

          cardLink(
            context: context,
            icon: Icons.attach_money,
            titleText: 'Pricing',
            route: PricingRoute,
          ),

          cardLink(
            context: context,
            icon: Icons.email_outlined,
            titleText: 'Contact me',
            route: ContactRoute,
          ),

          cardLink(
            context: context,
            icon: Icons.help_center,
            titleText: 'About',
            route: AboutRoute,
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
              FluroRouter.router.navigateTo(context, EnrollRoute);
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
            route: ProjectsRoute,
          ),

          buttonLink(
            context: context,
            icon: Icons.edit,
            titleText: 'Posts',
            route: PostsRoute,
          ),

          buttonLink(
            context: context,
            icon: Icons.attach_money,
            titleText: 'Pricing',
            route: PricingRoute,
          ),

          buttonLink(
            context: context,
            icon: Icons.email_outlined,
            titleText: 'Contact me',
            route: ContactRoute,
          ),

          buttonLink(
            context: context,
            icon: Icons.help_center,
            titleText: 'About',
            route: AboutRoute,
          ),
        ],
      ),
    );
  }

}
