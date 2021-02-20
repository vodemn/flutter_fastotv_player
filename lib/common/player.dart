import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:player/common/controller.dart';
import 'package:player/common/states.dart';
import 'package:screen/screen.dart';

abstract class ILitePlayer extends StatefulWidget {
  final IPlayerController controller;
  final Widget placeholder;
  final double aspectRatio;
  final bool keepScreen;

  const ILitePlayer(
      {@required this.controller,
      this.aspectRatio,
      bool keepScreen,
      this.placeholder = const Center(child: CircularProgressIndicator()),
      Key key})
      : keepScreen = keepScreen ?? true,
        super(key: key);
}

abstract class ILitePlayerState extends State<ILitePlayer> {
  IPlayerController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    if (widget.keepScreen) {
      _setScreen(true);
    }
    controller.initLink();
  }

  @override
  void dispose() {
    _setScreen(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
            color: Colors.black,
            child: Center(
                child: PlayerStateListener(controller, builder: (_) {
              return player();
            }, placeholder: widget.placeholder))));
  }

  Widget player();

  void _setScreen(bool keepOn) {
    if (!kIsWeb) {
      Screen.keepOn(keepOn);
    }
  }
}
