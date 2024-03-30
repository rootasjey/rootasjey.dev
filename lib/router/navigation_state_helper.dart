import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:rootasjey/types/alias/firestore/query_doc_snap_map.dart';
import 'package:rootasjey/types/track_data.dart';

class NavigationStateHelper {
  /// Initial browser url.
  /// Necesarry to set app locale somewhere where we've access to a `context`.
  /// We cannot set it in the `main` method because the `context`
  /// is not available there.
  static String initialBrowserUrl = "";

  /// Prefill the login input with this value if it is not empty.
  /// Used on signin or signup page.
  /// ----------------------------------
  /// Case scenario: user start typing in the login input form and then
  /// they want to create a new account.
  static String userEmailInput = "";

  /// Prefill the password input with this value if it is not empty.
  /// Used on signin or signup page.
  /// ----------------------------------
  /// Case scenario: user start typing in the password input form and then
  /// they want to create a new account.
  static String userPasswordInput = "";

  /// Media Player for audio and video playback.
  static Player player = Player();

  /// Current media loaded into the player.
  static Media currentMedia = Media("");

  /// Current track.
  static TrackData currentTrack = TrackData.empty();

  /// List of tracks.
  static List<TrackData> tracks = [];

  /// True if there're more tracks to fetch from the server.
  static bool hasMoreTrackToFetch = true;

  /// Last fetched firestore document track.
  static QueryDocSnapMap? lastDocTrack;

  /// Video Controller.
  static final VideoController videoController = VideoController(player);
}
