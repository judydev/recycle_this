import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:recycle_this/src/components/play_area.dart';

const gameWidth = 820.0;
const gameHeight = 640.0;

class MyGame extends FlameGame {
  MyGame()
      : super(
            camera: CameraComponent.withFixedResolution(
                width: gameWidth, height: gameHeight));

  double get width => size.x;
  double get height => size.y;

  late final RouterComponent router;

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(PlayArea());

  }
}
