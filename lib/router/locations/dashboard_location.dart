import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:rootasjey/router/locations/signin_location.dart';
import 'package:rootasjey/router/navigation_state_helper.dart';
import 'package:rootasjey/screens/dashboard_page.dart';
import 'package:rootasjey/screens/dashboard_welcome_page.dart';
import 'package:rootasjey/screens/delete_account_page.dart';
import 'package:rootasjey/screens/draft_posts_page.dart';
import 'package:rootasjey/screens/draft_projects_page.dart';
import 'package:rootasjey/screens/edit_image_page.dart';
import 'package:rootasjey/screens/edit_post_page.dart';
import 'package:rootasjey/screens/edit_project_page.dart';
import 'package:rootasjey/screens/my_profile_page.dart';
import 'package:rootasjey/screens/new_post_page.dart';
import 'package:rootasjey/screens/new_project_page.dart';
import 'package:rootasjey/screens/post_page.dart';
import 'package:rootasjey/screens/project_page.dart';
import 'package:rootasjey/screens/published_posts_page.dart';
import 'package:rootasjey/screens/published_projects_page.dart';
import 'package:rootasjey/screens/settings/settings_page.dart';
import 'package:rootasjey/screens/update_email_page.dart';
import 'package:rootasjey/screens/update_password_page.dart';
import 'package:rootasjey/screens/update_username_page.dart';
import 'package:rootasjey/types/globals/globals.dart';

class DashboardLocation extends BeamLocation<BeamState> {
  static const String route = '/dashboard/*';

  @override
  List<Pattern> get pathPatterns => [route];

  @override
  List<BeamGuard> get guards => [
        BeamGuard(
          pathPatterns: [route],
          check: (context, location) {
            final userNotifier = Globals.state.getUserNotifier();
            return userNotifier.isAuthenticated;
          },
          beamToNamed: (origin, target) => SigninLocation.route,
        ),
      ];

  @override
  List<BeamPage> buildPages(context, state) {
    return [
      BeamPage(
        child: DashboardPage(),
        key: ValueKey(route),
        title: 'Dashboard',
        type: BeamPageType.fadeTransition,
      ),
    ];
  }
}

class DashboardLocationContent extends BeamLocation<BeamState> {
  // DashboardLocationContent(RouteInformation information) : super(information);

  static const String route = '/dashboard';

  static const String postsRoute = '${route}/posts';
  static const String publishedPostsRoute = '${postsRoute}published';
  static const String draftPostsRoute = '${postsRoute}draft';
  static const String newPostsRoute = '${postsRoute}new';
  static const String editPostsRoute = '${postsRoute}edit/:postId';
  static const String previewPostsRoute = '${postsRoute}preview/:postId';

  static const String projectsRoute = '${route}/projects';
  static const String publishedProjectsRoute = '${projectsRoute}published';
  static const String draftProjectsRoute = '${projectsRoute}draft';
  static const String newProjectsRoute = '${projectsRoute}new';
  static const String editProjectsRoute = '${projectsRoute}edit/:postId';
  static const String previewProjectsRoute = '${projectsRoute}preview/:postId';

  static const String profileRoute = '$route/profile';

  /// Profile route value for this location.
  static const String editProfilePictureRoute = '$profileRoute/edit/pp';

  /// Settings route value for this location.
  static const String settingsRoute = '$route/settings';

  static const String settingsUpdateRoute = '$settingsRoute/update';

  /// Delete account route value for this location.
  static const String deleteAccountRoute = '$settingsRoute/delete/account';

  /// Statistics route value for this location.
  static const String statisticsRoute = '/dashboard/statistics';

  /// Update email route value for this location.
  static const String updateEmailRoute = '$settingsUpdateRoute/email';

  /// Update password route value for this location.
  static const String updatePasswordRoute = '$settingsUpdateRoute/password';

  /// Update username route value for this location.
  static const String updateUsernameRoute = '$settingsUpdateRoute/username';

  static const String postsSegment = 'posts';
  static const String projectsSegment = 'projects';

  @override
  List<Pattern> get pathPatterns => [route, postsRoute];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: DashboardWelcomePage(),
        key: ValueKey(route),
        title: "Dashboard Welcome",
        type: BeamPageType.fadeTransition,
      ),

      // -----
      // Posts
      // -----
      // if (state.pathPatternSegments.contains('posts'))
      //   BeamPage(
      //     child: MyPostsPage(),
      //     key: ValueKey(postsRoute),
      //     title: "My Posts",
      //   ),
      if (isMyPublishedPostsPage(state.pathPatternSegments))
        BeamPage(
          child: PublishedPostsPage(),
          key: ValueKey('published posts page'),
          title: "Published Posts",
        ),
      if (isMyDraftPostsPage(state.pathPatternSegments))
        BeamPage(
          child: DraftPostsPage(),
          key: ValueKey('drafts posts page'),
          title: "Drafts Posts",
        ),
      if (isNewPostPage(state.pathPatternSegments))
        BeamPage(
          child: NewPostPage(),
          key: ValueKey('new post page'),
          title: "New Post",
        ),
      if (isEditPostPage(state.pathPatternSegments))
        BeamPage(
          child: EditPostPage(postId: state.pathParameters['postId']),
          key: ValueKey('edit post page'),
          title: "Edit Post",
        ),
      if (isPreviewPostPage(state.pathPatternSegments))
        BeamPage(
          child: PostPage(postId: state.pathParameters['postId'] ?? ''),
          key: ValueKey('preview post page'),
          title: "Preview Post",
        ),

      // --------
      // Projects
      // --------
      // if (state.pathPatternSegments.contains('projects'))
      //   BeamPage(
      //     child: MyProjectsPage(),
      //     key: ValueKey(projectsRoute),
      //     title: "Projects",
      //   ),
      if (isMyPublishedProjectsPage(state.pathPatternSegments))
        BeamPage(
          child: PublishedProjectsPage(),
          key: ValueKey('published projects page'),
          title: "Published Projects",
        ),
      if (isMyDraftProjectsPage(state.pathPatternSegments))
        BeamPage(
          child: DraftProjectsPage(),
          key: ValueKey('drafts projects page'),
          title: "Drafts Projects",
        ),
      if (isNewProjectPage(state.pathPatternSegments))
        BeamPage(
          child: NewProjectPage(),
          key: ValueKey('new project page'),
          title: "New Project",
        ),
      if (isEditProjectPage(state.pathPatternSegments))
        BeamPage(
          child: EditProjectPage(projectId: state.pathParameters['projectId']),
          key: ValueKey('edit project page'),
          title: "Edit Project",
        ),
      if (isPreviewProjectPage(state.pathPatternSegments))
        BeamPage(
          child: ProjectPage(
            projectId: state.pathParameters['projectId'] ?? '',
          ),
          key: ValueKey('preview project page'),
          title: "Preview Project",
        ),

      // -------
      // Profile
      // -------
      if (state.pathPatternSegments.contains('profile'))
        BeamPage(
          child: MyProfilePage(),
          key: ValueKey('$profileRoute'),
          title: "My Profile",
        ),
      if (isEditPictureProfile(state.pathPatternSegments))
        BeamPage(
          child: EditImagePage(image: NavigationStateHelper.imageToEdit),
          key: ValueKey('$editProfilePictureRoute'),
          title: "Edit Profile Picture",
          type: BeamPageType.fadeTransition,
        ),

      // --------
      // Settings
      // --------
      if (state.pathPatternSegments.contains('settings'))
        BeamPage(
          child: SettingsPage(),
          key: ValueKey('$settingsRoute'),
          title: "Settings",
          type: BeamPageType.fadeTransition,
        ),
      if (isDeleteAccount(state.pathPatternSegments))
        BeamPage(
          child: DeleteAccountPage(),
          key: ValueKey('$deleteAccountRoute'),
          title: "Delete account",
          type: BeamPageType.fadeTransition,
        ),
      if (isUpdateEmail(state.pathPatternSegments))
        BeamPage(
          child: UpdateEmailPage(),
          key: ValueKey('$updateEmailRoute'),
          title: "Update email",
          type: BeamPageType.fadeTransition,
        ),
      if (isUpdatePassword(state.pathPatternSegments))
        BeamPage(
          child: UpdatePasswordPage(),
          key: ValueKey('$updatePasswordRoute'),
          title: "Update password",
          type: BeamPageType.fadeTransition,
        ),
      if (isUpdateUsername(state.pathPatternSegments))
        BeamPage(
          child: UpdateUsernamePage(),
          key: ValueKey('$updateUsernameRoute'),
          title: "Update username",
          type: BeamPageType.fadeTransition,
        ),
    ];
  }

  bool isMyPublishedPostsPage(List<String> pathPatternSegments) {
    return pathPatternSegments.contains(postsSegment) &&
        pathPatternSegments.contains('published');
  }

  bool isMyDraftPostsPage(List<String> pathPatternSegments) {
    return pathPatternSegments.contains(postsSegment) &&
        pathPatternSegments.contains('drafts');
  }

  bool isNewPostPage(List<String> pathPatternSegments) {
    return pathPatternSegments.contains(postsSegment) &&
        pathPatternSegments.contains('new');
  }

  bool isEditPostPage(List<String> pathPatternSegments) {
    return pathPatternSegments.contains(postsSegment) &&
        pathPatternSegments.contains('edit') &&
        pathPatternSegments.contains(':postId');
  }

  bool isPreviewPostPage(List<String> pathPatternSegments) {
    return pathPatternSegments.contains(postsSegment) &&
        pathPatternSegments.contains('preview') &&
        pathPatternSegments.contains(':postId');
  }

  bool isMyPublishedProjectsPage(List<String> pathPatternSegments) {
    return pathPatternSegments.contains(projectsSegment) &&
        pathPatternSegments.contains('published');
  }

  bool isMyDraftProjectsPage(List<String> pathPatternSegments) {
    return pathPatternSegments.contains(projectsSegment) &&
        pathPatternSegments.contains('drafts');
  }

  bool isNewProjectPage(List<String> pathPatternSegments) {
    return pathPatternSegments.contains(projectsSegment) &&
        pathPatternSegments.contains('new');
  }

  bool isEditProjectPage(List<String> pathPatternSegments) {
    return pathPatternSegments.contains(projectsSegment) &&
        pathPatternSegments.contains('edit') &&
        pathPatternSegments.contains(':projectId');
  }

  bool isPreviewProjectPage(List<String> pathPatternSegments) {
    return pathPatternSegments.contains(projectsSegment) &&
        pathPatternSegments.contains('preview') &&
        pathPatternSegments.contains(':projectId');
  }

  /// True if the path match the delete account page.
  bool isEditPictureProfile(List<String> pathPatternSegements) {
    return pathPatternSegements.contains('profile') &&
        pathPatternSegements.contains('edit') &&
        pathPatternSegements.contains('pp');
  }

  /// True if the path match the delete account page.
  bool isDeleteAccount(List<String> pathPatternSegments) {
    return pathPatternSegments.contains('delete') &&
        pathPatternSegments.contains('account');
  }

  /// True if the path match the delete account page.
  bool isUpdateEmail(List<String> pathPatternSegments) {
    return pathPatternSegments.contains('update') &&
        pathPatternSegments.contains('email');
  }

  /// True if the path match the delete account page.
  bool isUpdatePassword(List<String> pathPatternSegments) {
    return pathPatternSegments.contains('update') &&
        pathPatternSegments.contains('password');
  }

  /// True if the path match the delete account page.
  bool isUpdateUsername(List<String> pathPatternSegments) {
    return pathPatternSegments.contains('update') &&
        pathPatternSegments.contains('username');
  }
}
