import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootasjey/components/application_bar.dart';
import 'package:rootasjey/components/better_avatar.dart';
import 'package:rootasjey/globals/app_state.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/screens/undefined_page.dart';
import 'package:rootasjey/types/user/user_firestore.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserFirestore? user = ref.watch(AppState.userProvider).firestoreUser;
    if (user == null) {
      return const UndefinedPage();
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const ApplicationBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 100.0,
                vertical: 100.0,
              ),
              child: Wrap(
                spacing: 24.0,
                runSpacing: 24.0,
                alignment: WrapAlignment.center,
                children: [
                  SizedBox(
                    width: 200.0,
                    height: 240.0,
                    child: Card(
                      elevation: 4.0,
                      color: Colors.deepPurple.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BetterAvatar(
                              size: 110.0,
                              margin: const EdgeInsets.only(
                                bottom: 8.0,
                              ),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.8),
                                width: 4.0,
                              ),
                              image: NetworkImage(user.getProfilePicture()),
                            ),
                            Text(
                              user.name,
                              textAlign: TextAlign.center,
                              style: Utilities.fonts.body(
                                textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 500.0,
                    height: 240.0,
                    child: Card(
                      elevation: 4.0,
                      color: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bio",
                              style: Utilities.fonts.body(
                                textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              user.bio,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 6,
                              style: Utilities.fonts.body(
                                textStyle: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white.withOpacity(0.6),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200.0,
                    height: 240.0,
                    child: Card(
                      elevation: 4.0,
                      color: Colors.grey.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: Text(
                                "actions",
                                textAlign: TextAlign.center,
                                style: Utilities.fonts.body(
                                  textStyle: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(AppState.userProvider.notifier)
                                    .signOut();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                                backgroundColor: Colors.red.withOpacity(0.1),
                              ),
                              child: Text(
                                "logout".tr(),
                                style: Utilities.fonts.body(
                                  textStyle: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
