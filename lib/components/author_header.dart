import 'package:flutter/material.dart';
import 'package:rootasjey/components/better_avatar.dart';

class AuthorHeader extends StatefulWidget {
  @override
  _AuthorHeaderState createState() => _AuthorHeaderState();
}

class _AuthorHeaderState extends State<AuthorHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 24.0,
        bottom: 28.0,
      ),
      child: Row(
        children: [
          Hero(
            tag: 'pp',
            child: BetterAvatar(
              size: 60.0,
              image: AssetImage(
                'assets/images/jeje.jpg',
              ),
              colorFilter: ColorFilter.mode(
                Colors.grey,
                BlendMode.saturation,
              ),
              onTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TODO: Use dynamic author.
                Opacity(opacity: 0.8, child: Text("Jérémie CORPINOT")),
                Opacity(opacity: 0.4, child: Text("Dev web & mobile")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
