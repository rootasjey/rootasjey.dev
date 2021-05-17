import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';

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
      style: TextButton.styleFrom(
        primary: stateColors.foreground,
        padding: const EdgeInsets.all(16.0),
      ),
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
            icon: UniconsLine.bag,
            titleText: "hire_me".tr(),
            routeInfo: EnrollPageRoute(),
          ),
          cardLink(
            context: context,
            icon: UniconsLine.apps,
            titleText: "projects".tr(),
            routeInfo: ProjectsPageRoute(),
          ),
          cardLink(
            context: context,
            icon: UniconsLine.newspaper,
            titleText: "posts",
            routeInfo: PostsPageRoute(),
          ),
          cardLink(
            context: context,
            icon: UniconsLine.bill,
            titleText: "pricing".tr(),
            routeInfo: PricingPageRoute(),
          ),
          cardLink(
            context: context,
            icon: UniconsLine.envelope,
            titleText: "contact_me".tr(),
            routeInfo: ContactPageRoute(),
          ),
          cardLink(
            context: context,
            icon: UniconsLine.question,
            titleText: "about".tr(),
            routeInfo: AboutPageRoute(),
          ),
        ],
      ),
    );
  }

  Widget largeView(BuildContext context) {
    return Observer(builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: 60.0,
          left: 100.0,
        ),
        child: Wrap(
          spacing: 40.0,
          runSpacing: 20.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                context.router.push(EnrollPageRoute());
              },
              style: ElevatedButton.styleFrom(
                primary: stateColors.primary,
                textStyle: FontsUtils.mainStyle(
                  color: Colors.white,
                ),
              ),
              icon: Icon(UniconsLine.bag),
              label: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 12.0,
                ),
                child: Text("hire_me".tr()),
              ),
            ),
            buttonLink(
              context: context,
              icon: UniconsLine.apps,
              titleText: "projects".tr(),
              routeInfo: ProjectsRouter(),
            ),
            buttonLink(
              context: context,
              icon: UniconsLine.newspaper,
              titleText: "posts".tr(),
              routeInfo: PostsRouter(children: []),
            ),
            buttonLink(
              context: context,
              icon: UniconsLine.bill,
              titleText: "pricing".tr(),
              routeInfo: PricingPageRoute(),
            ),
            buttonLink(
              context: context,
              icon: UniconsLine.envelope,
              titleText: "contact_me".tr(),
              routeInfo: ContactPageRoute(),
            ),
            buttonLink(
              context: context,
              icon: UniconsLine.question,
              titleText: "about".tr(),
              routeInfo: AboutPageRoute(),
            ),
          ],
        ),
      );
    });
  }
}
