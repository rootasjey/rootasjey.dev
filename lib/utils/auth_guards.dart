import 'package:flutter/material.dart';
import 'package:rootasjey/screens/signin.dart';
import 'package:rootasjey/state/user_state.dart';

Future<bool> canNavigate({
  @required BuildContext context,
}) async {
  try {
    final userAuth = await userState.userAuth;
    if (userAuth != null) { return true; }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return Signin();
        },
      ),
    );

    return false;

  } catch (error) {
    debugPrint(error.toString());
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return Signin();
        },
      ),
    );

    return false;
  }
}
