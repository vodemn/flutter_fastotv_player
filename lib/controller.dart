import 'dart:async';

import 'package:flutter/material.dart';
import 'package:player/common/controller.dart';
import 'package:video_player/video_player.dart';

class PlayerController extends IPlayerController<VideoPlayerController> {
  VideoPlayerController _controller;

  PlayerController({@required String initLink, Duration initDuration})
      : super(initLink: initLink, initDuration: initDuration);

  @override
  VideoPlayerController get baseController => _controller;

  @override
  bool isPlaying() {
    if (_controller == null) {
      return false;
    }

    return _controller.value.isPlaying;
  }

  @override
  Duration position() {
    if (_controller == null) {
      return const Duration();
    }
    return _controller.value.position;
  }

  @override
  double aspectRatio() {
    if (_controller == null) {
      return 16 / 9;
    }

    return _controller.value.aspectRatio;
  }

  @override
  Future<void> pause() async {
    if (_controller == null) {
      return Future.error('Invalid state');
    }

    return _controller.pause();
  }

  @override
  Future<void> play() async {
    if (_controller == null) {
      return Future.error('Invalid state');
    }

    return _controller.play();
  }

  @override
  Future<void> seekTo([Duration duration = const Duration(seconds: 5)]) async {
    if (_controller == null) {
      return Future.error('Invalid state');
    }

    return _controller.seekTo(duration);
  }

  @override
  Future<void> setVolume(double volume) {
    if (_controller == null) {
      return Future.error('Invalid state');
    }
    return _controller.setVolume(volume);
  }

  @override
  Future<void> setStreamUrl(String url) async {
    if (url == null) {
      return Future.error('Invalid input');
    }

    final VideoPlayerController controller = VideoPlayerController.network(url,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    final VideoPlayerController old = _controller;
    _controller = controller;
    old?.pause();

    return _controller.initialize().then((_) {
      old?.dispose();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }
}
