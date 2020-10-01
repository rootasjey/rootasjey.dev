import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:rootasjey/screens/me.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePresentation extends StatefulWidget {
  @override
  _HomePresentationState createState() => _HomePresentationState();
}

class _HomePresentationState extends State<HomePresentation> {
  final width = 600.0;
  bool isNarrow = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        isNarrow = boxConstraints.maxWidth < 600.0;

        return Padding(
          padding: EdgeInsets.all(
            isNarrow
              ? 50.0
              : 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              body(),
            ],
          ),
        );
      }
    );
  }

  Widget body() {
    if (isNarrow) {
      return narrowView();
    }

    return largeView();
  }

  Widget largeView() {
    return Container(
      width: width,
      padding: const EdgeInsets.only(
        top: 100.0,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 60.0,
            ),
            child: titleIntro(),
          ),

          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 40.0,
                ),
                child: profilePicture(),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: profileSummary(),
                    ),

                    socialNetworks(),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget narrowView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 60.0,
            bottom: 60.0,
          ),
          child: profilePicture(),
        ),

        titleIntro(),

        Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            bottom: 20
          ),
          child: profileSummary(),
        ),

        Padding(
          padding: const EdgeInsets.only(
            top: 28.0,
          ),
          child: socialNetworks(),
        ),
      ],
    );
  }

  Widget profilePicture() {
    return Hero(
      tag: 'pp',
      child: Material(
        shape: CircleBorder(),
        child: Ink.image(
          image: AssetImage('assets/images/jeje.jpg',),
          width: 120.0,
          height: 120.0,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Me();
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget profileSummary() {
    return Opacity(
      opacity: 0.7,
      child: Text(
        "I'm a french developer working on my personal projects and as a freelancer. I also like drawings and learning things.",
        style: TextStyle(
          fontSize: 17.0,
        ),
      ),
    );
  }

  Widget socialNetworks() {
    return Wrap(
      children: [
        IconButton(
          icon: Icon(LineAwesomeIcons.github),
          onPressed: () => launch('https://github.com/rootasjey'),
        ),
        IconButton(
          icon: Icon(LineAwesomeIcons.twitter),
          onPressed: () => launch('https://twitter.com/rootasjey'),
        ),
        IconButton(
          icon: Icon(LineAwesomeIcons.instagram),
          onPressed: () => launch('https://instagram.com/rootasjey'),
        ),
        IconButton(
          icon: Icon(LineAwesomeIcons.medium),
          onPressed: () => launch('https://medium.com/@rootasjey'),
        ),
        IconButton(
          icon: Icon(LineAwesomeIcons.hashtag),
          onPressed: () => launch('https://hashnode.com/@rootasjey'),
        ),
      ],
    );
  }

  Widget titleIntro() {
    final text = 'Welcome to rootasjey website. A virtual space about art & development.';

    if (isNarrow) {
      return SizedBox(
        width: width,
        child: Opacity(
          opacity: 0.8,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 50.0,
        ),
      ),
    );
  }
}
