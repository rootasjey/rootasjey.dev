import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/actions/users.dart';
import 'package:rootasjey/components/full_page_loading.dart';
import 'package:rootasjey/main_web.dart';
import 'package:rootasjey/rooter/router.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/state/user_state.dart';
import 'package:rootasjey/utils/app_local_storage.dart';

void main() {
  runApp(App());
}
class App extends StatefulWidget {
  AppState createState() => AppState();
}

class AppState extends State<App> {
  bool isReady = false;

  AppState() {
    if (kIsWeb) { FluroRouter.setupWebRouter(); }
    else { FluroRouter.setupMobileRouter(); }
  }

  @override
  void initState() {
    super.initState();

    appLocalStorage.initialize().then((value) {
      final savedLang = appLocalStorage.getLang();
      userState.setLang(savedLang);

      autoLogin();

      setState(() {
        isReady = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isReady) {
      return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
          // fontFamily: 'Comfortaa',
          brightness: brightness,
        ),
        themedWidgetBuilder: (context, theme) {
          stateColors.themeData = theme;

          return MainWeb();
          // if (kIsWeb) {
          //   return MainWeb();
          // }

          // return MainMobile();
        },
      );
    }

    return MaterialApp(
      title: 'Out Of Context',
      home: Scaffold(
        body: FullPageLoading(),
      ),
    );
  }

  void autoLogin() async {
    try {
      final credentials = appLocalStorage.getCredentials();

      if (credentials == null) {
        return;
      }

      final email = credentials['email'];
      final password = credentials['password'];

      if ((email == null || email.isEmpty) ||
          (password == null || password.isEmpty)) {
        return;
      }

      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user == null) {
        return;
      }

      appLocalStorage.setUserName(userCredential.user.displayName);
      await userGetAndSetAvatarUrl(userCredential);

      userState.setUserConnected();
      userState.setUserName(userCredential.user.displayName);

    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
