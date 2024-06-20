import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:sliding_master/sliding_puzzle/sliding_puzzle.dart';

class Piece extends RectangleComponent
    with HasGameRef<SlidingPuzzle>, DragCallbacks {
  Piece({
    required Vector2 position,
    required Vector2 size,
    required Color color,
    required this.label,
  }) : super(
          position: position,
          size: size,
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.fill,
          children: [
            TextBoxComponent(
              // align: Anchor.center,
              text: label,
            ),
          ],
          anchor: Anchor.topLeft,
        );

  final String label;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    position.x =
        (position.x + event.localDelta.x).clamp(0, game.width - size.x);
    position.y =
        (position.y + event.localDelta.y).clamp(0, game.height - size.y);
  }

  bool draggable() {
    game.blankPiece;
    return label.isEmpty;
  }
}
