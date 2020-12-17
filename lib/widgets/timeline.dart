import 'package:flutter/material.dart';
import 'package:player/common/states.dart';
import 'package:player/controller.dart';
import 'package:video_player/video_player.dart';

class LitePlayerTimeline extends StatelessWidget {
  final PlayerController controller;

  const LitePlayerTimeline(this.controller);

  @override
  Widget build(BuildContext context) {
    return PlayerStateListener(controller, builder: (_) {
      return VideoProgressIndicator(controller.baseController, allowScrubbing: true);
    },
        placeholder:
            const Padding(padding: EdgeInsets.only(top: 5.0), child: LinearProgressIndicator()));
  }
}
