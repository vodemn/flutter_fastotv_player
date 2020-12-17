import 'dart:async';

import 'package:flutter/material.dart';
import 'package:player/common/states.dart';

abstract class IPlayerController<T> {
  String link;
  final Duration initDuration;
  final StreamController<IPlayerState> _state = StreamController<IPlayerState>.broadcast();
  final void Function() onPlaying;
  final void Function() onPlayingError;

  T get baseController;

  IPlayerController({this.link, this.initDuration, this.onPlaying, this.onPlayingError});

  
  Stream<IPlayerState> get state => _state.stream;

  bool isPlaying();

  Duration position();

  double aspectRatio();

  Future<void> pause();

  Future<void> play();

  Future<void> seekTo(Duration duration);

  Future<void> seekForward(Duration duration) {
    return seekTo(position() + duration);
  }

  Future<void> seekBackward(Duration duration) {
    return seekTo(position() - duration);
  }

  void setVolume(double volume);

  Future<void> setStreamUrl(String url);

  void setVideoLink(String url) {
    _changeState(InitIPlayerState());
    setStreamUrl(url).then((value) {
      _changeState(ReadyToPlayState(url));
      play().then((_) {
        onPlaying?.call();
      }).catchError((_) => onPlayingError?.call());
    }).catchError((_) => onPlayingError?.call());
  }

  void _changeState(IPlayerState state) {
    _state.add(state);
  }

  @mustCallSuper
  void dispose() {
    _state.close();
  }
}
