import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:player/common/controller.dart';

class PlayerController extends IPlayerController<VlcPlayerController> {
  final Completer<void> _creatingCompleter = Completer<void>();
  VlcPlayerController _controller;
  String url;

  PlayerController(
      {@required String link,
      Duration initDuration,
      void Function() onPlaying,
      void Function() onPlayingError})
      : super(
            link: link,
            initDuration: initDuration,
            onPlaying: onPlaying,
            onPlayingError: onPlayingError) {
    _controller = VlcPlayerController(onInit: _handleInit);
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
  Future<void> seekTo(Duration duration) async {
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
    _controller.setStreamUrl(url);
    if (_controller.initialized) {
      return Future.value();
    }
    return _creatingCompleter.future;
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  void _handleInit() {
    _creatingCompleter.complete();
  }
}
