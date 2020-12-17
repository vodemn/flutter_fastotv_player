import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:player/common/player.dart';
import 'package:player/controller.dart';

class LitePlayer extends ILitePlayer {
  const LitePlayer(
      {Key key, @required PlayerController controller,
      Widget placeholder = const Center(child: CircularProgressIndicator())})
      : super(controller: controller, placeholder: placeholder, key: key);

  @override
  _LitePlayerState createState() {
    return _LitePlayerState();
  }
}

class _LitePlayerState extends ILitePlayerState {
  @override
  Widget player() {
    final options = ['--no-skip-frames'];
    return VlcPlayer(
        url: controller.currentLink,
        aspectRatio: controller.aspectRatio(),
        controller: controller.baseController,
        placeholder: widget.placeholder,
        hwAcc: HwAcc.FULL,
        options: options,
        isLocalMedia: false);
  }
}
