import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:rootasjey/router/route_names.dart';
import 'package:rootasjey/router/router.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePresentation extends StatelessWidget {
  final width = 600.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: width,
            child: Text(
              'Welcome to rootasjey website. A virtual space about art & development.',
              style: TextStyle(
                fontSize: 50.0,
              ),
            ),
          ),

          Container(
            width: width,
            padding: const EdgeInsets.only(
              top: 100.0,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 40.0,
                  ),
                  child: Material(
                    shape: CircleBorder(),
                    child: Ink.image(
                      image: AssetImage('assets/images/jeje.jpg',),
                      width: 120.0,
                      height: 120.0,
                      child: InkWell(
                        onTap: () {
                          FluroRouter.router.navigateTo(context, MeRoute);
                        },
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 14.0),
                        child: Opacity(
                          opacity: 0.7,
                          child: Text(
                            "I'm a french developer working on my personal projects and as a freelancer. I also like drawings and learning things.",
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                      ),

                      Wrap(
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
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
