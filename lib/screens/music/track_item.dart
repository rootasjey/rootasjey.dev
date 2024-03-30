import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/types/track_data.dart';

class TrackItem extends StatelessWidget {
  const TrackItem({
    super.key,
    required this.track,
    this.isPlaying = false,
    this.isSelected = false,
    this.position = const Duration(seconds: 1),
    this.duration = const Duration(seconds: 1),
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.onTogglePlayPause,
  });

  /// True if the track is currently playing.
  final bool isPlaying;

  /// True if the track is selected.
  final bool isSelected;

  /// Track duration.
  final Duration duration;

  /// Current player position.
  final Duration position;

  /// Spacing around this widget.
  final EdgeInsets margin;

  /// Track data.
  final TrackData track;

  /// Callback fired when tapping on a track.
  final void Function(TrackData track)? onTap;

  /// Callback fired to toggle play/pause playback.
  final void Function(TrackData track)? onTogglePlayPause;

  @override
  Widget build(BuildContext context) {
    final Color? foregroundColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Tooltip(
      waitDuration: const Duration(milliseconds: 1000),
      message: track.name,
      child: Padding(
        padding: margin,
        child: InkWell(
          onTap: () => onTap?.call(track),
          child: Container(
            height: 42.0,
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected)
                  CircleButton(
                    onTap: () => onTogglePlayPause?.call(track),
                    icon: Icon(
                      isPlaying
                          ? TablerIcons.player_pause
                          : TablerIcons.player_play,
                      size: 14.0,
                      color: foregroundColor,
                    ),
                  ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Utils.calligraphy.body(
                          textStyle: TextStyle(
                            fontSize: 14.0,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w200,
                          ),
                        ),
                      ),
                      // if (isPlaying)
                      //   SizedBox(
                      //     height: 6.0,
                      //     width: 200.0,
                      //     child: LinearProgressIndicator(
                      //       value: position.inSeconds / duration.inSeconds,
                      //       // value: position / duration,
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
