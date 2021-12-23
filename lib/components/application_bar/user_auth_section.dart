import 'package:flutter/material.dart';
import 'package:rootasjey/components/application_bar/brightness_button.dart';
import 'package:rootasjey/components/application_bar/create_button.dart';
import 'package:rootasjey/components/application_bar/lang_button.dart';
import 'package:rootasjey/components/avatar/avatar_menu.dart';

class UserAuthSection extends StatelessWidget {
  const UserAuthSection({
    Key key,
    this.compact = false,
    this.trailing = const [],
  }) : super(key: key);

  final bool compact;
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 5.0,
        right: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CreateButton(),
          BrightnessButton(),
          if (!compact) LangButton(),
          ...trailing,
          AvatarMenu(
            isSmall: compact,
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
