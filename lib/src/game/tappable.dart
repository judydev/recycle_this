import 'dart:math';
import 'package:flutter/material.dart';
import 'package:recycle_this/src/game/my_game.dart';

class Tappable extends StatefulWidget {
  const Tappable(
      {super.key, required this.id, required this.child, required this.onTap});

  final int id;
  final Widget child;
  final void Function(int) onTap;

  @override
  State<Tappable> createState() => _TappableState();
}

class _TappableState extends State<Tappable> {
  late final id = widget.id;
  late final child = widget.child;
  late final onTap = widget.onTap;
  final rotationZ = Random().nextDouble() * 2 * pi;

  // state vars
  bool found = false;
  bool wrong = false;

  @override
  Widget build(BuildContext context) {
    final img = Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationZ(rotationZ),
        child: child);

    return GestureDetector(
        onTap: () {
          if (found | wrong) return;
          widget.onTap(widget.id);
          setState(
            () {
              wrong = wrongSetNotifier.value.contains(id);
              found = foundSetNotifier.value.contains(id);
            },
          );
        },
        child: Stack(fit: StackFit.expand, children: [
          (found | wrong)
              ? ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: <Color>[Colors.white30, Colors.white30],
                    ).createShader(bounds);
                  },
                  child: img)
              : img,
          found
              ? Icon(Icons.check_circle_outline,
                  size: 40, color: Colors.green[800]!)
              : const SizedBox.shrink(),
          wrong
              ? Icon(Icons.cancel_outlined, size: 40, color: Colors.red[800]!)
              : const SizedBox.shrink(),
        ]));
  }
}
