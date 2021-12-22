import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/avatar/better_avatar.dart';
import 'package:rootasjey/types/user_firestore.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/cloud.dart';

class AuthorHeader extends StatefulWidget {
  final String authorId;

  const AuthorHeader({
    Key key,
    @required this.authorId,
  }) : super(key: key);

  @override
  _AuthorHeaderState createState() => _AuthorHeaderState();
}

class _AuthorHeaderState extends State<AuthorHeader> {
  UserFirestore _user = UserFirestore.empty();

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    final avatarUrl = _user.urls.image.isNotEmpty
        ? _user.urls.image
        : "https://img.icons8.com/plasticine/100/000000/flower.png";

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
              image: NetworkImage(avatarUrl),
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
                Opacity(opacity: 0.8, child: Text(_user.name)),
                Opacity(opacity: 0.4, child: Text(_user.job)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void fetch() async {
    try {
      final resp =
          await Cloud.fun('users-fetchUser').call({'userId': widget.authorId});

      final hashMap = LinkedHashMap.from(resp.data);
      final data = Cloud.convertFromFun(hashMap);

      setState(() => _user = UserFirestore.fromJSON(data));
    } catch (error) {
      appLogger.e(error);
    }
  }
}
