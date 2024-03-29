import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/actions/user_actions.dart';
import 'package:rootasjey/components/basic_shortcuts.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/router/locations/home_location.dart';
import 'package:rootasjey/screens/settings/username/update_username_page_body.dart';
import 'package:rootasjey/screens/settings/username/update_username_page_header.dart';
import 'package:rootasjey/types/cloud_fun_error.dart';
import 'package:rootasjey/types/cloud_fun_response.dart';
import 'package:rootasjey/types/enums/enum_page_state.dart';

/// Update username page.
class UpdateUsernamePage extends StatefulWidget {
  const UpdateUsernamePage({super.key});

  @override
  State<UpdateUsernamePage> createState() => _UpdateUsernamePageState();
}

class _UpdateUsernamePageState extends State<UpdateUsernamePage> with UiLoggy {
  /// True if the username entered is available.
  bool _isNameAvailable = true;

  /// Password focus node.
  final FocusNode _passwordFocusNode = FocusNode();

  /// Username text controller.
  final TextEditingController _usernameTextController = TextEditingController();

  /// Page's state (e.g. loading, idle, ...).
  EnumPageState _pageState = EnumPageState.idle;

  /// Error message.
  String _errorMessage = "";

  /// Timer to debounce username check.
  Timer? _usernameCheckTimer;

  @override
  void dispose() {
    _usernameTextController.dispose();
    _passwordFocusNode.dispose();
    _usernameCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobileSize = Utils.graphic.isMobileSize(context);

    return BasicShortcuts(
      autofocus: false,
      onCancel: context.beamBack,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            UpdateUsernamePageHeader(
              isMobileSize: isMobileSize,
              onTapLeftPartHeader: onTapLeftPartHeader,
            ),
            UpdateUsernamePageBody(
              isMobileSize: isMobileSize,
              usernameController: _usernameTextController,
              passwordFocusNode: _passwordFocusNode,
              pageState: _pageState,
              errorMessage: _errorMessage,
              onUsernameChanged: onUsernameChanged,
              onTapUpdateButton: tryUpdateUsername,
            ),
          ],
        ),
      ),
    );
  }

  /// Return true if the username entered is in correct format.
  bool isUsernameInCorrectFormat(String text) {
    if (text.isEmpty) {
      _errorMessage = "input.error.empty".tr();
      return false;
    }

    if (text.length < 3) {
      _errorMessage = "input.error.minimum_length".tr(args: ["3"]);
      return false;
    }

    final bool isWellFormatted = UserActions.checkUsernameFormat(text);

    if (!isWellFormatted) {
      _errorMessage = "input.error.alphanumerical".tr();
      return false;
    }

    return true;
  }

  void onTapLeftPartHeader() {
    if (context.canBeamBack) {
      context.beamBack();
      return;
    }

    Beamer.of(context, root: true).beamToNamed(HomeLocation.route);
  }

  /// Called when the username text field changes.
  /// Check for username availability.
  void onUsernameChanged(String newUsername) async {
    final bool isOk = isUsernameInCorrectFormat(newUsername);
    if (!isOk) {
      setState(() {});
      return;
    }

    setState(() {
      _pageState = EnumPageState.checkingUsername;
      _errorMessage = "";
    });

    _usernameCheckTimer?.cancel();
    _usernameCheckTimer = Timer(const Duration(seconds: 1), () async {
      _isNameAvailable =
          await UserActions.checkUsernameAvailability(newUsername);

      if (!_isNameAvailable) {
        setState(() {
          _errorMessage = "input.error.username_not_available".tr();
          _pageState = EnumPageState.idle;
        });

        return;
      }

      setState(() {
        _pageState = EnumPageState.idle;
        _errorMessage = "";
      });
    });
  }

  void tryUpdateUsername() async {
    if (!isUsernameInCorrectFormat(_usernameTextController.text)) {
      setState(() {});
      return;
    }

    setState(() {
      _errorMessage = "";
      _pageState = EnumPageState.loading;
    });

    try {
      _isNameAvailable = await UserActions.checkUsernameAvailability(
        _usernameTextController.text,
      );

      if (!_isNameAvailable) {
        setState(() {
          _pageState = EnumPageState.idle;
          _errorMessage = "input.error.username_not_available".tr();
        });
        return;
      }

      final CloudFunResponse usernameUpdateResp =
          await Utils.state.user.updateUsername(
        _usernameTextController.text,
      );

      if (!usernameUpdateResp.success) {
        final CloudFunError? exception = usernameUpdateResp.error;
        setState(() => _pageState = EnumPageState.idle);
        loggy.error(exception?.message);
        return;
      }

      setState(() {
        _pageState = EnumPageState.idle;
        _usernameTextController.clear();
      });

      if (!mounted) return;
      context.beamBack();
    } catch (error) {
      loggy.error(error);
      setState(() => _pageState = EnumPageState.idle);
    }
  }
}
