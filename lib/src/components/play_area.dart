import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:recycle_this/src/my_game.dart';

class PlayArea extends RectangleComponent with HasGameReference<MyGame> {
  PlayArea() : super(paint: Paint()..color = const Color(0xfff2e8cf));

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    size = Vector2(game.width, game.height);
  }
}
