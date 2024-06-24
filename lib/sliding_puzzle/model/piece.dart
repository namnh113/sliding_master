import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:sliding_master/sliding_puzzle/sliding_puzzle.dart';

class Piece extends SpriteComponent
    with HasGameRef<SlidingPuzzle>, DragCallbacks, TapCallbacks {
  Piece({
    required Vector2 position,
    required Vector2 size,
    required this.index,
    super.sprite,
  }) : super(
          position: position,
          size: size,
          paint: Paint()
            ..color = Colors.cyan
            ..style = PaintingStyle.fill,
          children: [
            // TextBoxComponent(
            //   text: index.toString(),
            // ),
          ],
          anchor: Anchor.topLeft,
        );

  final int index;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    position.x =
        (position.x + event.localDelta.x).clamp(0, game.width - size.x);
    position.y =
        (position.y + event.localDelta.y).clamp(0, game.height - size.y);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    game.swapPiece(this);
  }

  bool swappable() {
    return game.blankPiece?.position.x.roundToDouble() ==
            position.x.roundToDouble() ||
        game.blankPiece?.position.y.roundToDouble() ==
            position.y.roundToDouble();
  }
}
