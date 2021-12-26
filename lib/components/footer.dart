import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootasjey/components/app_icon.dart';
import 'package:rootasjey/router/locations/about_location.dart';
import 'package:rootasjey/router/locations/activities_location.dart';
import 'package:rootasjey/router/locations/contact_location.dart';
import 'package:rootasjey/router/locations/dashboard_location.dart';
import 'package:rootasjey/router/locations/posts_location.dart';
import 'package:rootasjey/router/locations/projects_location.dart';
import 'package:rootasjey/router/locations/settings_location.dart';
import 'package:rootasjey/router/locations/signin_location.dart';
import 'package:rootasjey/router/locations/signup_location.dart';
import 'package:rootasjey/router/locations/tos_location.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/globals/globals.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends ConsumerWidget {
  final ScrollController? pageScrollController;
  final bool closeModalOnNav;
  final bool autoNavToHome;

  Footer({
    this.autoNavToHome = true,
    this.pageScrollController,
    this.closeModalOnNav = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;

    final WrapAlignment alignment =
        width < 700.0 ? WrapAlignment.spaceBetween : WrapAlignment.spaceAround;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 60.0,
        vertical: 90.0,
      ),
      child: Wrap(
        runSpacing: 80.0,
        alignment: alignment,
        children: <Widget>[
          Divider(
            height: 20.0,
            thickness: 1.0,
            color: Colors.black38,
          ),
          copyright(context),
          editorialSection(context),
          userSection(context, ref),
          aboutUsSection(context),
        ],
      ),
    );
  }

  Widget copyright(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppIcon(),
        companyNameSection(),
        tosSection(context),
        privacyPolicySection(context),
      ],
    );
  }

  Widget aboutUsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleSection(title: "about".tr().toUpperCase()),
        textLink(
          label: "about_us".tr(),
          onPressed: () {
            Beamer.of(context).beamToNamed(AboutLocation.route);
          },
        ),
        textLink(
          label: "contact_us".tr(),
          onPressed: () {
            Beamer.of(context).beamToNamed(ContactLocation.route);
          },
        ),
        textLink(
          label: "GitHub",
          onPressed: () {
            launch('https://github.com/rootasjey/rootasjey.dev');
          },
        ),
      ],
    );
  }

  Widget editorialSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleSection(title: "editorial".tr().toUpperCase()),
        textLink(
          label: "posts".tr(),
          onPressed: () {
            Beamer.of(context).beamToNamed(PostsLocation.route);
          },
        ),
        textLink(
          label: "projects".tr(),
          onPressed: () {
            Beamer.of(context).beamToNamed(ProjectsLocation.route);
          },
        ),
        textLink(
          label: "activity".tr(),
          onPressed: () {
            Beamer.of(context).beamToNamed(ActivitiesLocation.route);
          },
        ),
      ],
    );
  }

  Widget companyNameSection() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        bottom: 8.0,
      ),
      child: Text.rich(TextSpan(
        children: [
          TextSpan(
            text: "rootasjey ${DateTime.now().year}",
            style: FontsUtils.mainStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Opacity(
                opacity: 0.6,
                child: Icon(
                  UniconsLine.copyright,
                  size: 18.0,
                ),
              ),
            ),
          ),
          TextSpan(
            text: "\nby Jeremie Codes, SASU",
          ),
        ],
      )),
    );
  }

  Widget privacyPolicySection(BuildContext context) {
    return textLink(
      label: "privacy".tr(),
      onPressed: () {
        Beamer.of(context).beamToNamed(TosLocation.route);
      },
    );
  }

  Widget titleSection({required title}) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        bottom: 8.0,
      ),
      child: Opacity(
        opacity: 0.8,
        child: Text(
          title,
          style: FontsUtils.mainStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget textLink({
    VoidCallback? onPressed,
    String? heroTag,
    required String label,
  }) {
    final Widget text = Text(
      label,
      style: FontsUtils.mainStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
      ),
    );

    final Widget textContainer = heroTag != null
        ? Hero(
            tag: label,
            child: text,
          )
        : text;

    return TextButton(
      onPressed: onPressed,
      child: Opacity(
        opacity: 0.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: textContainer,
        ),
      ),
      style: TextButton.styleFrom(
        primary: stateColors.foreground,
      ),
    );
  }

  Widget tosSection(BuildContext context) {
    return textLink(
      label: "tos".tr(),
      heroTag: "tos_hero",
      onPressed: () {
        Beamer.of(context).beamToNamed(TosLocation.route);
      },
    );
  }

  Widget userSection(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleSection(title: "user".tr().toUpperCase()),
        textLink(
          label: "signin".tr(),
          onPressed: () => Beamer.of(context).beamToNamed(
            SigninLocation.route,
          ),
        ),
        textLink(
          label: "signup".tr(),
          onPressed: () => Beamer.of(context).beamToNamed(
            SignupLocation.route,
          ),
        ),
        textLink(
          label: "settings".tr(),
          onPressed: () {
            final user = ref.read(Globals.state.user.notifier);

            if (user.isAuthenticated) {
              Beamer.of(context).beamToNamed(
                DashboardLocationContent.settingsRoute,
              );
              return;
            }

            Beamer.of(context).beamToNamed(SettingsLocation.route);
          },
        ),
      ],
    );
  }
}
