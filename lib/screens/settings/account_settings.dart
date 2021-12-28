import 'package:flutter/material.dart';
import 'package:rootasjey/components/fade_in_x.dart';
import 'package:rootasjey/screens/settings/avatar_settings.dart';
import 'package:rootasjey/screens/settings/delete_account_button.dart';
import 'package:rootasjey/screens/settings/email_button.dart';
import 'package:rootasjey/screens/settings/update_password_button.dart';
import 'package:rootasjey/screens/settings/update_username_button.dart';
import 'package:supercharged_dart/supercharged_dart.dart';

class AccountSettings extends StatelessWidget {
  final bool isAuthenticated;
  final String email;
  final String username;
  final String profilePicture;
  final VoidCallback onGoToUpdateEmail;
  final VoidCallback onUploadProfilePicture;
  final VoidCallback onTapProfilePicture;

  const AccountSettings({
    Key? key,
    this.isAuthenticated = false,
    required this.email,
    required this.username,
    required this.onGoToUpdateEmail,
    required this.profilePicture,
    required this.onUploadProfilePicture,
    required this.onTapProfilePicture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isAuthenticated) {
      return Column(
        children: [
          AvatarSettings(
            profilePicture: profilePicture,
            onUploadProfilePicture: onUploadProfilePicture,
            onTapProfilePicture: onTapProfilePicture,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: Wrap(
              spacing: 15.0,
              children: <Widget>[
                FadeInX(
                  delay: 0.milliseconds,
                  beginX: 50.0,
                  child: UpdatePasswordButton(),
                ),
                FadeInX(
                  delay: 100.milliseconds,
                  beginX: 50.0,
                  child: DeleteAccountButton(),
                )
              ],
            ),
          ),
          UpdateUsernameButton(
            username: username,
          ),
          Padding(padding: const EdgeInsets.only(bottom: 24.0)),
          EmailButton(
            email: email,
            onPressed: onGoToUpdateEmail,
          ),
          // Divider(thickness: 1.0, height: 80.0),
        ],
      );
    }

    return Container();
  }
}
