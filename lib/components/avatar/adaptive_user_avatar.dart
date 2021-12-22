import 'package:flutter/material.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/state/user.dart';

class AdaptiveUserAvatar extends StatelessWidget {
  const AdaptiveUserAvatar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String avatarURL = stateUser.getPPUrl();
    final String initials = stateUser.getInitialsUsername();

    if (avatarURL.isNotEmpty) {
      return CircleAvatar(
        backgroundColor: stateColors.lightBackground,
        radius: 20.0,
        backgroundImage: NetworkImage(
          stateUser.userFirestore?.pp?.url?.edited ?? '',
        ),
      );
    }

    if (initials.isNotEmpty) {
      return CircleAvatar(
        backgroundColor: stateColors.lightBackground,
        radius: 20.0,
        child: Text(initials),
      );
    }

    return CircleAvatar();
  }
}
