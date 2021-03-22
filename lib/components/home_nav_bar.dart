import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/colors.dart';

class HomeNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      if (boxConstraints.maxWidth < 600.0) {
        return narrowView(context);
      }

      return largeView(context);
    });
  }

  Widget buttonLink({
    @required BuildContext context,
    @required IconData icon,
    @required String titleText,
    @required PageRouteInfo routeInfo,
  }) {
    return TextButton.icon(
      onPressed: () {
        context.router.push(routeInfo);
      },
      icon: Icon(icon),
      label: Text(titleText),
    );
  }

  Widget cardLink({
    @required BuildContext context,
    @required IconData icon,
    @required String titleText,
    @required PageRouteInfo routeInfo,
  }) {
    return SizedBox(
      width: 120.0,
      height: 120.0,
      child: Card(
        elevation: 4.0,
        child: InkWell(
          onTap: () {
            context.router.push(routeInfo);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              Text(titleText),
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
            routeInfo: EnrollRoute(),
          ),
          cardLink(
            context: context,
            icon: Icons.apps,
            titleText: 'Projects',
            routeInfo: ProjectsRoute(),
          ),
          cardLink(
            context: context,
            icon: Icons.edit,
            titleText: 'Posts',
            routeInfo: PostsRoute(),
          ),
          cardLink(
            context: context,
            icon: Icons.attach_money,
            titleText: 'Pricing',
            routeInfo: PricingRoute(),
          ),
          cardLink(
            context: context,
            icon: Icons.email_outlined,
            titleText: 'Contact me',
            routeInfo: ContactRoute(),
          ),
          cardLink(
            context: context,
            icon: Icons.help_center,
            titleText: 'About',
            routeInfo: AboutRoute(),
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
          ElevatedButton.icon(
            onPressed: () {
              context.router.push(EnrollRoute());
            },
            style: ElevatedButton.styleFrom(
              primary: stateColors.primary,
              textStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: Icon(Icons.work),
            label: Text(
              'Enroll',
            ),
          ),
          buttonLink(
            context: context,
            icon: Icons.apps,
            titleText: 'Projects',
            routeInfo: ProjectsDeepRoute(children: [ProjectsRoute()]),
          ),
          buttonLink(
            context: context,
            icon: Icons.edit,
            titleText: 'Posts',
            routeInfo: PostsDeepRoute(children: [PostsRoute()]),
          ),
          buttonLink(
            context: context,
            icon: Icons.attach_money,
            titleText: 'Pricing',
            routeInfo: PricingRoute(),
          ),
          buttonLink(
            context: context,
            icon: Icons.email_outlined,
            titleText: 'Contact me',
            routeInfo: ContactRoute(),
          ),
          buttonLink(
            context: context,
            icon: Icons.help_center,
            titleText: 'About',
            routeInfo: AboutRoute(),
          ),
        ],
      ),
    );
  }
}
