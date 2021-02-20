import 'package:flutter/material.dart';
import 'package:player/common/controller.dart';
import 'package:player/common/player.dart';
import 'package:video_player/video_player.dart';

class LitePlayer extends ILitePlayer {
  const LitePlayer(
      {@required IPlayerController controller,
      double aspectRatio = 16 / 9,
      bool keepScreen,
      Widget placeholder = const Center(child: CircularProgressIndicator()),
      Key key})
      : super(
            controller: controller,
            aspectRatio: aspectRatio,
            keepScreen: keepScreen,
            placeholder: placeholder,
            key: key);

  @override
  _LitePlayerState createState() {
    return _LitePlayerState();
  }
}

class _LitePlayerState extends ILitePlayerState {
  @override
  Widget player() {
    return AspectRatio(
        aspectRatio: controller.aspectRatio(), child: VideoPlayer(controller.baseController));
  }
}
