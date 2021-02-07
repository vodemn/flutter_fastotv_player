import 'package:flutter/material.dart';
import 'package:player/controller.dart';

abstract class IPlayerState {}

class InitIPlayerState extends IPlayerState {}

class ErrorState extends IPlayerState {}

class ReadyToPlayState extends IPlayerState {
  ReadyToPlayState(this.url);

  final String url;
}

class PlayerStateBuilder extends StatelessWidget {
  final PlayerController controller;
  final Widget Function(BuildContext context, IPlayerState state) builder;

  const PlayerStateBuilder(this.controller, {@required this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<IPlayerState>(
        stream: controller.state,
        initialData: InitIPlayerState(),
        builder: (context, snapshot) {
          return builder(context, snapshot.data);
        });
  }
}

class PlayerStateListener extends StatelessWidget {
  final PlayerController controller;
  final Widget Function(BuildContext) builder;
  final Widget placeholder;

  const PlayerStateListener(this.controller,
      {@required this.builder, this.placeholder = const SizedBox()});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<IPlayerState>(
        stream: controller.state,
        initialData: InitIPlayerState(),
        builder: (context, snapshot) {
          if (snapshot.data is ReadyToPlayState) {
            return builder(context);
          }
          return placeholder;
        });
  }
}
