import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:player/common/controller.dart';
import 'package:player/common/states.dart';
import 'package:screen/screen.dart';

abstract class ILitePlayer extends StatefulWidget {
  final IPlayerController controller;
  final Widget placeholder;

  const ILitePlayer(
      {this.controller,
      this.placeholder = const Center(child: CircularProgressIndicator()),
      Key key})
      : super(key: key);
}

abstract class ILitePlayerState extends State<ILitePlayer> {
  IPlayerController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _setScreen(true);
    controller.setVideoLink(controller.link);
  }

  @override
  void dispose() {
    _setScreen(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: Center(
            child: PlayerStateListener(controller, builder: (_) {
          return player();
        }, placeholder: widget.placeholder)));
  }

  Widget player();

  void _setScreen(bool keepOn) {
    if (!kIsWeb) {
      Screen.keepOn(keepOn);
    }
  }
}
