import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rootasjey/components/footer.dart';
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/screens/pricing.dart';
import 'package:rootasjey/screens/projects.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  final captionOpacity = 0.6;
  final paragraphOpacity = 0.6;
  final titleOpacity = 0.9;

  final largeHorizPadding = 90.0;
  final narrowHorizPadding = 20.0;
  final narrowWidthLimit = 800.0;

  final paragraphStyle = TextStyle(
    fontSize: 18.0,
    height: 1.5,
  );

  final titleStyle = TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.w200,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          HomeAppBar(),
          SliverLayoutBuilder(
            builder: (_, constraints) {
              final padding = constraints.crossAxisExtent < narrowWidthLimit
                  ? narrowHorizPadding
                  : largeHorizPadding;

              return SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: padding,
                      vertical: 90.0,
                    ),
                    child: headerTitle(),
                  ),
                ]),
              );
            },
          ),
          SliverLayoutBuilder(
            builder: (_, constraints) {
              final padding = constraints.crossAxisExtent < narrowWidthLimit
                  ? narrowHorizPadding
                  : largeHorizPadding;

              return SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: padding,
                ),
                sliver: body(),
              );
            },
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 200.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Footer(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget body() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            thePurpose(),
            theDevStack(),
            theWork(),
            theHobbies(),
          ],
        ),
      ]),
    );
  }

  Widget headerTitle() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back),
          ),
        ),
        Text(
          'About',
          style: TextStyle(
            fontSize: 70.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget thePurpose() {
    return Container(
      width: 600.0,
      padding: const EdgeInsets.only(
        top: 40.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Opacity(
              opacity: titleOpacity,
              child: Text(
                'THE PURPOSE',
                style: titleStyle,
              ),
            ),
          ),
          Opacity(
            opacity: paragraphOpacity,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text(
                "This is my personal website where you'll find projects that I'm working on, some hobbies I want to share and how to contact me.",
                style: paragraphStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget theDevStack() {
    return Container(
      width: 600.0,
      padding: const EdgeInsets.only(
        top: 40.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Opacity(
              opacity: titleOpacity,
              child: Text(
                'DEV STACK',
                style: titleStyle,
              ),
            ),
          ),
          Opacity(
            opacity: paragraphOpacity,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text(
                "This website has been crafted by hand with Flutter & Firebase.\nAfter testing multiple solutions, I ended up here because it seems the cheapest and most flexble way for my usage.",
                style: paragraphStyle,
              ),
            ),
          ),
          Opacity(
            opacity: paragraphOpacity,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text(
                "If you want to learn how the technology behind this website, visit the GitHub repository. or stay tuned for future blog posts explanations.",
                style: paragraphStyle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
            ),
            child: TextButton.icon(
              onPressed: () =>
                  launch('https://github.com/rootasjey/rootasjey.dev'),
              icon: Icon(Icons.open_in_browser),
              label: Text(
                'Github',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget theWork() {
    return Container(
      width: 600.0,
      padding: const EdgeInsets.only(
        top: 40.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Opacity(
              opacity: titleOpacity,
              child: Text(
                'MY WORK',
                style: titleStyle,
              ),
            ),
          ),
          Opacity(
            opacity: paragraphOpacity,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text(
                "I work as a freelancer in web and mobile development but I'm currently coding my own applications. You can see them in the projects section. If you want to start a collaboration, go to the work with me page.",
                style: paragraphStyle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                TextButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return Projects();
                      },
                    ),
                  ),
                  icon: Icon(Icons.apps),
                  label: Text(
                    'Projects',
                  ),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return Pricing();
                      },
                    ),
                  ),
                  icon: Icon(Icons.work),
                  label: Text(
                    'Work with me',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Opacity(
              opacity: paragraphOpacity,
              child: Text(
                "Below are my freelancer profiles",
                style: paragraphStyle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                InkWell(
                  onTap: () {
                    launch('https://www.malt.fr/profile/jeremiecorpinot');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      'assets/images/malt-logo-white.png',
                      color: Color(0xFFFF215B),
                      width: 250.0,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    launch(
                        'https://app.comet.co/freelancer/profile/5xe7Awyb7r?params=eyJhbm9ueW1pemUiOmZhbHNlLCJkZXNpZ25Nb2RlIjpmYWxzZSwicmVhZE9ubHkiOnRydWV9');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      'assets/images/comet-logo-wide.jpg',
                      width: 250.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget theHobbies() {
    return Container(
      width: 600.0,
      padding: const EdgeInsets.only(
        top: 40.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Opacity(
              opacity: titleOpacity,
              child: Text(
                'MY HOBBIES',
                style: titleStyle,
              ),
            ),
          ),
          Opacity(
            opacity: paragraphOpacity,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text(
                "I like to draw, play video games, watch movies & TV series, and read.",
                style: paragraphStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
