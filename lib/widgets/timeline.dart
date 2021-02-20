import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:video_player/video_player.dart';
import 'package:meta/meta.dart';
import 'package:player/common/states.dart';
import 'package:player/controller.dart';

export 'package:video_player_platform_interface/video_player_platform_interface.dart'
    show DurationRange, DataSourceType, VideoFormat;

class LitePlayerTimeline extends StatelessWidget {
  final PlayerController controller;

  const LitePlayerTimeline(this.controller);

  @override
  Widget build(BuildContext context) {
    return PlayerStateListener(controller, builder: (_) {
      return VideoProgressIndicatorVLC(controller.baseController, allowScrubbing: true);
    },
        placeholder:
            const Padding(padding: EdgeInsets.only(top: 5.0), child: LinearProgressIndicator()));
  }
}

class VideoProgressIndicatorVLC extends StatefulWidget {
  VideoProgressIndicatorVLC(
    this.controller, {
    VideoProgressColors colors,
    this.allowScrubbing,
    this.padding = const EdgeInsets.only(top: 5.0),
  }) : colors = colors ?? VideoProgressColors();

  final VlcPlayerController controller;

  final VideoProgressColors colors;

  final bool allowScrubbing;

  final EdgeInsets padding;

  @override
  _VideoProgressIndicatorVLCState createState() => _VideoProgressIndicatorVLCState();
}

class _VideoProgressIndicatorVLCState extends State<VideoProgressIndicatorVLC> {
  _VideoProgressIndicatorVLCState() {
    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  VoidCallback listener;

  VlcPlayerController get controller => widget.controller;

  VideoProgressColors get colors => widget.colors;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void deactivate() {
    controller.removeListener(listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    Widget progressIndicator;
    if (controller.value.isInitialized) {
      final int duration = controller.value.duration.inMilliseconds;
      final int position = controller.value.position.inMilliseconds;
      double result = position / duration;
      if (result.isNaN || result.isInfinite) {
        result = 0;
      }

      progressIndicator = Stack(fit: StackFit.passthrough, children: <Widget>[
        LinearProgressIndicator(
            value: result,
            valueColor: AlwaysStoppedAnimation<Color>(colors.playedColor),
            backgroundColor: Colors.transparent)
      ]);
    } else {
      progressIndicator = LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(colors.playedColor),
          backgroundColor: colors.backgroundColor);
    }
    final Widget paddedProgressIndicator = Padding(
      padding: widget.padding,
      child: progressIndicator,
    );
    if (widget.allowScrubbing) {
      return _VideoScrubber(controller: controller, child: paddedProgressIndicator);
    } else {
      return paddedProgressIndicator;
    }
  }
}

class _VideoScrubber extends StatefulWidget {
  const _VideoScrubber({@required this.child, @required this.controller});

  final Widget child;
  final VlcPlayerController controller;

  @override
  _VideoScrubberState createState() => _VideoScrubberState();
}

class _VideoScrubberState extends State<_VideoScrubber> {
  bool _controllerWasPlaying = false;

  VlcPlayerController get controller => widget.controller;
  VlcPlayerValue get value => widget.controller.value;

  @override
  Widget build(BuildContext context) {
    void seekToRelativePosition(Offset globalPosition) {
      final RenderBox box = context.findRenderObject();
      final Offset tapPos = box.globalToLocal(globalPosition);
      final double relative = tapPos.dx / box.size.width;
      final Duration position = value.duration * relative;
      controller.setTime(position.inMilliseconds);
    }

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragStart: (DragStartDetails details) {
          if (!value.isInitialized) {
            return;
          }
          _controllerWasPlaying = value.playingState == PlayingState.playing;
          if (_controllerWasPlaying) {
            controller.pause();
          }
        },
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          if (!value.isInitialized) {
            return;
          }
          seekToRelativePosition(details.globalPosition);
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          if (_controllerWasPlaying) {
            controller.play();
          }
        },
        onTapDown: (TapDownDetails details) {
          if (!value.isInitialized) {
            return;
          }
          seekToRelativePosition(details.globalPosition);
        },
        child: widget.child);
  }
}
