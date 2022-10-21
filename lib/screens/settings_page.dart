import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootasjey/components/application_bar.dart';
import 'package:rootasjey/components/buttons/dark_elevated_button.dart';
import 'package:rootasjey/globals/app_state.dart';
import 'package:rootasjey/screens/undefined_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(AppState.userProvider).firestoreUser;
    if (user == null) {
      return const UndefinedPage();
    }

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        const ApplicationBar(),
        DarkElevatedButton(
          child: Text("logout".tr()),
        ),
      ],
    ));
  }
}
