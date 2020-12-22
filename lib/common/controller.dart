import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:player/common/states.dart';

abstract class IPlayerController<T> {
  String _link;
  final Duration initDuration;
  final StreamController<IPlayerState> _state = StreamController<IPlayerState>.broadcast();

  T get baseController;

  IPlayerController({String initLink, this.initDuration}) : _link = initLink;

  Stream<IPlayerState> get state => _state.stream;

  String get currentLink => _link;

  @visibleForOverriding
  void onPlaying() {}

  @visibleForOverriding
  void onPlayingError() {}

  bool isPlaying();

  Duration position();

  double aspectRatio();

  Future<void> pause();

  Future<void> play();

  Future<void> seekTo(Duration duration);

  Future<void> seekForward([Duration duration = const Duration(seconds: 5)]) {
    return seekTo(position() + duration);
  }

  Future<void> seekBackward([Duration duration = const Duration(seconds: 5)]) {
    return seekTo(position() - duration);
  }

  void setVolume(double volume);

  Future<void> setStreamUrl(String url);

  void initLink() {
    setVideoLink(_link, initDuration);
  }

  void setVideoLink(String url, [Duration duration]) {
    _changeState(InitIPlayerState());
    setStreamUrl(url).then((value) {
      _link = url;
      _changeState(ReadyToPlayState(url));
      if (duration != null) {
        seekTo(duration);
      }
      play().then((_) {
        onPlaying?.call();
      }).catchError((_) => onPlayingError?.call());
    }).catchError((_) => onPlayingError?.call());
  }

  @mustCallSuper
  void dispose() {
    _state.close();
  }

  // private:
  void _changeState(IPlayerState state) {
    _state.add(state);
  }
}
