import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:player/common/controller.dart';

class PlayerController extends IPlayerController<VlcPlayerController> {
  VlcPlayerController _controller;
  String url;

  PlayerController({@required String initLink, Duration initDuration})
      : super(initLink: initLink, initDuration: initDuration) {
    _controller = VlcPlayerController(onInit: () {
      _controller.play();
    });
  }

  void addListener(VoidCallback listener) {
    _controller.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    _controller.removeListener(listener);
  }

  @override
  VlcPlayerController get baseController => _controller;

  @override
  bool isPlaying() {
    if (!_controller.initialized) {
      return false;
    }

    return _controller.playingState == PlayingState.PLAYING;
  }

  @override
  Duration position() {
    if (!_controller.initialized) {
      return const Duration();
    }
    return _controller.position;
  }

  @override
  double aspectRatio() {
    return 16 / 9;
  }

  @override
  Future<void> pause() async {
    if (!_controller.initialized) {
      return Future.error('Invalid state');
    }

    return _controller.pause();
  }

  @override
  Future<void> play() async {
    if (!_controller.initialized) {
      return Future.error('Invalid state');
    }

    return _controller.play();
  }

  @override
  Future<void> seekTo([Duration duration = const Duration(seconds: 5)]) async {
    if (!_controller.initialized) {
      return Future.error('Invalid state');
    }

    return _controller.setTime(duration.inMilliseconds);
  }

  @override
  Future<void> setVolume(double volume) {
    if (!_controller.initialized) {
      return Future.error('Invalid state');
    }
    return _controller.setVolume((volume * 100).toInt());
  }

  @override
  Future<void> setStreamUrl(String url) async {
    if (url == null) {
      return Future.error('Invalid input');
    }

    this.url = url;
    return _controller.setStreamUrl(url).then((value) {
      _controller.isPlaying().then((value) {
        if (!value) {
          _controller.play();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }
}
