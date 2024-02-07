import 'package:loggy/loggy.dart';
import 'package:rootasjey/globals/utils/app_state/app_state_user.dart';
import 'package:rootasjey/globals/utils/app_state/app_state_illustrations.dart';

class AppState with UiLoggy {
  AppState();

  final AppStateIllustrations illustrations = AppStateIllustrations();
  final AppStateUser user = AppStateUser();
}
