import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:rootasjey/components/loading_view.dart';
import 'package:rootasjey/screens/music/track_item.dart';
import 'package:rootasjey/types/enums/enum_page_state.dart';
import 'package:rootasjey/types/track_data.dart';

class MusicPageBody extends StatelessWidget {
  const MusicPageBody({
    super.key,
    required this.tracks,
    required this.currentMedia,
    required this.player,
    this.margin = EdgeInsets.zero,
    this.onTapTrack,
    this.onTogglePlayPause,
    this.pageState = EnumPageState.idle,
  });

  /// Spacing around this widget.
  final EdgeInsets margin;

  /// Current page state.
  final EnumPageState pageState;

  /// Callback called when a track is tapped.
  final void Function(TrackData track)? onTapTrack;

  /// Callback fired to toggle play/pause playback.
  final void Function(TrackData track)? onTogglePlayPause;

  /// Track list.
  final List<TrackData> tracks;

  /// Current media playing or paused.
  final Media currentMedia;

  /// Media player.
  final Player player;

  @override
  Widget build(BuildContext context) {
    final Color? foregroundColor = Theme.of(context).textTheme.bodyLarge?.color;

    if (pageState == EnumPageState.loading) {
      return LoadingView(
        margin: margin,
        message: "loading".tr(),
      );
    }

    return Padding(
      padding: margin,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: tracks.length,
        itemBuilder: (BuildContext context, int index) {
          final TrackData track = tracks[index];
          final bool isPlaying =
              currentMedia.uri == track.url && player.state.playing;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TrackItem(
                track: track,
                onTap: onTapTrack,
                onTogglePlayPause: onTogglePlayPause,
                isSelected: currentMedia.uri == track.url,
                isPlaying: isPlaying,
                position: player.state.position,
                duration: player.state.duration,
                margin: const EdgeInsets.symmetric(
                  vertical: 12.0,
                ),
              ),
              Divider(
                color: foregroundColor?.withOpacity(0.2),
                indent: 6.0,
                endIndent: 6.0,
              ),
            ],
          );
        },
      ),
    );
  }
}
