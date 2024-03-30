import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loggy/loggy.dart';
import 'package:measured/measured.dart';
import 'package:media_kit/media_kit.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/components/square_header.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/router/navigation_state_helper.dart';
import 'package:rootasjey/screens/music/music_page_body.dart';
import 'package:rootasjey/types/alias/firestore/query_doc_snap_map.dart';
import 'package:rootasjey/types/alias/firestore/query_map.dart';
import 'package:rootasjey/types/alias/firestore/query_snap_map.dart';
import 'package:rootasjey/types/enums/enum_page_state.dart';
import 'package:rootasjey/types/track_data.dart';
import 'package:wave_divider/wave_divider.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({
    super.key,
    this.onGoBack,
    this.onGoHome,
  });

  /// Callback to go back to the previous page.
  final void Function()? onGoBack;

  /// Callback to go back to the home page.
  final void Function()? onGoHome;

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> with UiLoggy {
  /// Query order.
  final bool _decending = true;

  /// Skip slider update from player when the user is dragging.
  bool _shouldTrackUpdateSlider = true;

  /// Slider size.
  Size _sliderSize = Size.zero;

  /// Current page state.
  EnumPageState _pageState = EnumPageState.idle;

  /// Interactive slider controller.
  final InteractiveSliderController _sliderController =
      InteractiveSliderController(0.0);

  /// Query limit.
  final int _limit = 20;

  /// Subscription when a track has finished playing.
  StreamSubscription<bool>? _completedSub;

  /// Subscription when the playing state has changed.
  StreamSubscription<bool>? _playingChangedSub;

  /// Subscription when the playing position has changed.
  StreamSubscription<Duration>? _onPositionChangedSub;

  /// Subscription when the playing duration has changed.
  StreamSubscription<Duration>? _onDurationChangedSub;

  /// Debounced seek timer.
  Timer? _seekTimer;

  /// Debounced slider update timer.
  Timer? _positionTimer;

  @override
  void initState() {
    super.initState();
    if (NavigationStateHelper.tracks.isEmpty) {
      fetchTracks();
    }

    _completedSub?.cancel();
    final PlayerStream playerSteam = NavigationStateHelper.player.stream;
    _completedSub = playerSteam.completed.listen(onPlayingEnded);
    _playingChangedSub = playerSteam.playing.listen(onPlayingChanged);
    _onPositionChangedSub = playerSteam.position.listen(onPositionChanged);
    _onDurationChangedSub = playerSteam.duration.listen(onDurationChanged);
  }

  @override
  void dispose() {
    _completedSub?.cancel();
    _playingChangedSub?.cancel();
    _onPositionChangedSub?.cancel();
    _onDurationChangedSub?.cancel();
    _seekTimer?.cancel();
    _positionTimer?.cancel();
    // _sliderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color? foregroundColor = Theme.of(context).textTheme.bodyLarge?.color;
    final bool isMobileSize = Utils.graphic.isMobileSize(context);

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 16.0),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SquareHeader(
                    margin: const EdgeInsets.only(top: 60.0),
                    onGoBack: widget.onGoBack,
                    onGoHome: widget.onGoHome,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      right: 12.0,
                    ),
                    child: FractionallySizedBox(
                      widthFactor: isMobileSize ? 0.8 : 0.6,
                      child: Column(
                        children: [
                          Text(
                            "music.name".tr().toUpperCase(),
                            style: Utils.calligraphy.body2(
                              textStyle: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            "music.subtitle".tr(),
                            textAlign: isMobileSize
                                ? TextAlign.center
                                : TextAlign.start,
                            style: Utils.calligraphy.body(
                              textStyle: TextStyle(
                                fontSize: isMobileSize ? 14.0 : 16.0,
                                fontWeight: FontWeight.w400,
                                color: foregroundColor?.withOpacity(0.5),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 24.0),
                            child: WaveDivider(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: isMobileSize ? 0.8 : 0.6,
                    child: MusicPageBody(
                      pageState: _pageState,
                      tracks: NavigationStateHelper.tracks,
                      onTapTrack: onTapTrack,
                      onTogglePlayPause: onTogglePlayPause,
                      player: NavigationStateHelper.player,
                      currentMedia: NavigationStateHelper.currentMedia,
                      margin: const EdgeInsets.only(bottom: 42.0),
                    ),
                  ),
                ],
              ),
              if (NavigationStateHelper.currentTrack.id.isNotEmpty)
                Positioned(
                  bottom: 12.0,
                  left: 32.0,
                  right: 32.0,
                  child: Card(
                    elevation: 4.0,
                    shape: const StadiumBorder(),
                    margin: const EdgeInsets.only(
                      top: 12.0,
                      left: 12.0,
                      right: 12.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleButton(
                            onTap: () => onTogglePlayPause(
                              NavigationStateHelper.currentTrack,
                            ),
                            radius: 16.0,
                            icon: Icon(
                              NavigationStateHelper.player.state.playing
                                  ? TablerIcons.player_pause
                                  : TablerIcons.player_play,
                              size: 16.0,
                              color: foregroundColor,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    NavigationStateHelper.currentTrack.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: Utils.calligraphy.body(
                                      textStyle: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTapDown: onSliderTapDown,
                                    onTapUp: onSliderTapUp,
                                    onHorizontalDragDown: onSliderDragDown,
                                    child: Measured(
                                      borders: const [],
                                      onChanged: onSliderDimensionsChanged,
                                      child: InteractiveSlider(
                                        controller: _sliderController,
                                        padding: const EdgeInsets.only(),
                                        min: 0.0,
                                        max: NavigationStateHelper
                                            .player.state.duration.inSeconds
                                            .toDouble(),
                                        onProgressUpdated: onPositionUpdated,
                                        startIcon:
                                            const Icon(TablerIcons.square),
                                        endIcon: const Icon(TablerIcons.square),
                                        endIconBuilder: sliderEndIconBuilder,
                                        startIconBuilder:
                                            sliderStartIconBuilder,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
    );
  }

  /// Fetch tracks.
  void fetchTracks() async {
    try {
      setState(() => _pageState = EnumPageState.loading);

      final QueryMap query = FirebaseFirestore.instance
          .collection("tracks")
          .orderBy("created_at", descending: _decending)
          .limit(_limit);

      final QuerySnapMap snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          _pageState = EnumPageState.idle;
          NavigationStateHelper.hasMoreTrackToFetch = false;
        });
        return;
      }

      NavigationStateHelper.tracks.addAll(
        snapshot.docs.map(
          (QueryDocSnapMap doc) => TrackData.fromMap(
            doc.data()..putIfAbsent("id", () => doc.id),
          ),
        ),
      );

      if (!mounted) return;
      setState(() {
        _pageState = EnumPageState.idle;
        NavigationStateHelper.lastDocTrack = snapshot.docs.last;
        NavigationStateHelper.hasMoreTrackToFetch =
            snapshot.docs.length == _limit;
      });
    } catch (error) {
      loggy.error(error);
      if (!mounted) return;
      setState(() => _pageState = EnumPageState.idle);
    }
  }

  /// Fetch tracks.
  void fetchMoreTracks() async {
    final QueryDocSnapMap? doc = NavigationStateHelper.lastDocTrack;
    if (doc == null) return;

    try {
      setState(() => _pageState = EnumPageState.loadingMore);

      final QueryMap query = FirebaseFirestore.instance
          .collection("tracks")
          .orderBy("created_at", descending: _decending)
          .startAfterDocument(NavigationStateHelper.lastDocTrack!)
          .limit(_limit);

      final QuerySnapMap snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          _pageState = EnumPageState.idle;
          NavigationStateHelper.hasMoreTrackToFetch = false;
        });
        return;
      }

      NavigationStateHelper.tracks.addAll(
        snapshot.docs.map(
          (QueryDocSnapMap doc) => TrackData.fromMap(
            doc.data()..putIfAbsent("id", () => doc.id),
          ),
        ),
      );

      if (!mounted) return;
      setState(() {
        _pageState = EnumPageState.idle;
        NavigationStateHelper.hasMoreTrackToFetch =
            snapshot.docs.length == _limit;
      });
    } catch (error) {
      loggy.error(error);
      if (!mounted) return;
      setState(() => _pageState = EnumPageState.idle);
    }
  }

  /// Callback fired when a track is tapped.
  void onTapTrack(TrackData track) {
    loggy.info(NavigationStateHelper.player.state.track.audio.id);
    NavigationStateHelper.currentMedia = Media(
      track.url,
      extras: {
        "id": track.id,
        "track": "0",
        "title": track.name,
      },
    );

    NavigationStateHelper.currentTrack = track;
    NavigationStateHelper.player.open(
      NavigationStateHelper.currentMedia,
    );

    setState(() {});
  }

  /// Callback fired to toggle play/pause playback.
  void onTogglePlayPause(TrackData track) {
    NavigationStateHelper.player.playOrPause();
    setState(() {});
  }

  /// Callback fired when the player has finished playing a track.
  void onPlayingEnded(bool event) {
    if (event) {
      setState(() {});
    }
  }

  /// Called when the player position has changed.
  void onPositionChanged(Duration event) {
    if (!_shouldTrackUpdateSlider) return;

    final double percent =
        event.inSeconds / NavigationStateHelper.player.state.duration.inSeconds;

    if (_positionTimer?.isActive ?? false) return;
    _positionTimer = Timer(
      const Duration(milliseconds: 75),
      () => _sliderController.value = percent,
    );
  }

  /// Callback fired when the player's playing state has changed.
  void onPlayingChanged(bool event) {
    setState(() {});
  }

  /// Callback fired when the player duration has changed when a track is added.
  void onDurationChanged(Duration event) {
    setState(() {});
  }

  /// A callback that runs when the user finishes updating the slider's progress
  void onPositionUpdated(double value) {
    final double trackPosition =
        value * NavigationStateHelper.player.state.duration.inSeconds;
    NavigationStateHelper.player.seek(Duration(seconds: trackPosition.toInt()));
    Future.delayed(
      const Duration(milliseconds: 500),
      () => _shouldTrackUpdateSlider = true,
    );
  }

  void onSliderTapDown(TapDownDetails details) {
    _shouldTrackUpdateSlider = false;
  }

  void onSliderTapUp(TapUpDetails details) {
    final double percent = details.localPosition.dx / _sliderSize.width;
    final double position =
        percent * NavigationStateHelper.player.state.duration.inSeconds;
    NavigationStateHelper.player.seek(Duration(seconds: position.toInt()));
    _shouldTrackUpdateSlider = true;
  }

  void onSliderDimensionsChanged(Size size) {
    _sliderSize = size;
  }

  void onSliderDragDown(DragDownDetails details) {
    _shouldTrackUpdateSlider = false;
  }

  Widget sliderStartIconBuilder(
    BuildContext context,
    double percent,
    Widget? child,
  ) {
    final Duration duration = Duration(
      seconds: (percent * NavigationStateHelper.player.state.duration.inSeconds)
          .toInt(),
    );

    final Jiffy dateTime =
        Jiffy.parseFromDateTime(DateTime(0, 0, 0, 0, 0, duration.inSeconds));

    if (dateTime.hour == 0) {
      return Text(
        "${dateTime.minute}:${dateTime.second}",
        style: const TextStyle(fontSize: 12),
      );
    }

    return Text(dateTime.Hms);
  }

  Widget sliderEndIconBuilder(
    BuildContext context,
    double value,
    Widget? child,
  ) {
    final Duration duration = Duration(
      seconds: NavigationStateHelper.player.state.duration.inSeconds.toInt(),
    );

    final Jiffy dateTime =
        Jiffy.parseFromDateTime(DateTime(0, 0, 0, 0, 0, duration.inSeconds));

    if (dateTime.hour == 0) {
      return Text(
        "${dateTime.minute}:${dateTime.second}",
        style: const TextStyle(fontSize: 12),
      );
    }

    return Text(dateTime.Hms);
  }
}
