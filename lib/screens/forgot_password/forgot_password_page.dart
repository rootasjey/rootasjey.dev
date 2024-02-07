import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/actions/user_actions.dart';
import 'package:rootasjey/components/application_bar.dart';
import 'package:rootasjey/components/bezier_clipper.dart';
import 'package:rootasjey/components/loading_view.dart';
import 'package:rootasjey/router/locations/home_location.dart';
import 'package:rootasjey/screens/forgot_password/forgot_password_page_body.dart';
import 'package:rootasjey/screens/forgot_password/forgot_password_page_completed.dart';
import 'package:rootasjey/types/intents/escape_intent.dart';
import 'package:rootasjey/utils/snack.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<StatefulWidget> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> with UiLoggy {
  /// If true, the operation is completed (e.g. email has been sent).
  bool isCompleted = false;

  /// True if the server is sending a new email to recover lost password.
  bool loading = false;

  /// Error message to display next to the email input.
  /// If this is empty, there's no error for this specific input.
  String _emailErrorMessage = "";

  /// Input controller to follow, validate & submit user email value.
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double windowWidth = MediaQuery.of(context).size.width;

    const shortcuts = <SingleActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.escape): EscapeIntent(),
    };

    final actions = <Type, Action<Intent>>{
      EscapeIntent: CallbackAction(
        onInvoke: (Intent intent) => onCancel(),
      ),
    };

    if (isCompleted) {
      return Shortcuts(
        shortcuts: shortcuts,
        child: Actions(
          actions: actions,
          child: ForgotPasswordPageCompleted(
            windowWidth: windowWidth,
          ),
        ),
      );
    }

    if (loading) {
      return LoadingView.scaffold(
        message: "sending_password_recovery_email".tr(),
      );
    }

    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: actions,
        child: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.8,
                  child: ClipPath(
                    clipper: const BezierClipper(1),
                    child: Container(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              CustomScrollView(slivers: [
                const ApplicationBar(),
                ForgotPasswordPageBody(
                  emailController: _emailController,
                  emailErrorMessage: _emailErrorMessage,
                  onCancel: onCancel,
                  onEmailChanged: onEmailChanged,
                  onSubmit: trySendResetLink,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  /// Check for input validity: emptyness, format, availability.
  /// Poppulate email error message if there's an error in one of those steps.
  bool checkEmail(String email) {
    email = email.trim();

    if (email.isEmpty) {
      setState(() {
        _emailErrorMessage = "email_error.empty".tr();
      });

      Snack.error(
        context,
        title: "email".tr(),
        message: "email_empty_no_valid".tr(),
      );

      return false;
    }

    final bool isWellFormatted = UserActions.checkEmailFormat(email);

    if (!isWellFormatted) {
      setState(() {
        _emailErrorMessage = "email_error.format".tr();
      });

      Snack.error(
        context,
        title: "email".tr(),
        message: "email_not_valid".tr(),
      );

      return false;
    }

    return true;
  }

  /// Navigate back to previous or home page.
  void onCancel() {
    if (Beamer.of(context).beamingHistory.isNotEmpty) {
      Beamer.of(context).beamBack();
      return;
    }

    Beamer.of(context, root: true).beamToNamed(HomeLocation.route);
  }

  /// React to email changes and call `checkEmail(email)` method.
  void onEmailChanged(String email) async {
    checkEmail(email);
  }

  void trySendResetLink(String email) async {
    final bool isEmailOk = checkEmail(email);

    if (!isEmailOk) {
      return;
    }

    try {
      setState(() {
        loading = true;
        isCompleted = false;
      });

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      setState(() {
        loading = false;
        isCompleted = true;
      });
    } catch (error) {
      loggy.error(error);
      setState(() => loading = false);
      if (!mounted) return;

      Snack.error(
        context,
        title: "email".tr(),
        message: "email_doesnt_exist".tr(),
      );
    }
  }
}
