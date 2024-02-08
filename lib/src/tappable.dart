import 'package:flutter/material.dart';

class Tappable extends StatelessWidget {
  const Tappable(
      {super.key, required this.id, required this.child, required this.onTap});

  final Widget child;
  final int id;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () => onTap(id), child: child);
  }
}
