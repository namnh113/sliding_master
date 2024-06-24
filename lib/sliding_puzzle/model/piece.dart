import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:sliding_master/sliding_puzzle/sliding_puzzle.dart';

enum Direction { up, down, left, right }

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
              text: label,
            ),
          ],
          anchor: Anchor.topLeft,
        ) {
    originalPosition = position.clone();
  }

  final String label;

  Direction? direction;
  late Vector2 originalPosition;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (!draggable()) return;
    switch (direction) {
      case Direction.up:
      case Direction.down:
        position.y =
            (position.y + event.localDelta.y).clamp(0, game.height - size.y);
        break;
      case Direction.left:
      case Direction.right:
        position.x =
            (position.x + event.localDelta.x).clamp(0, game.width - size.x);
        break;
      case null:
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);

    // Snap to blank position if close enough
    if (direction != null &&
        position.distanceTo(gameRef.blankPiece.position) <
            gameRef.pieceWidth / 2) {
      swapWithBlank();
    } else {
      resetPosition();
    }
  }

  void swapWithBlank() {
    var temp = originalPosition.clone();
    position = gameRef.blankPiece.position.clone();
    originalPosition = position.clone();
    gameRef.blankPiece.position = temp.clone();
  }

  void resetPosition() {
    position = originalPosition.clone();
  }

  bool draggable() {
    var blankX = gameRef.blankPiece.position.x ~/ gameRef.pieceWidth;
    var blankY = gameRef.blankPiece.position.y ~/ gameRef.pieceHeight;
    var pieceX = position.x ~/ gameRef.pieceWidth;
    var pieceY = position.y ~/ gameRef.pieceHeight;

    if (pieceX == blankX - 1 && pieceY == blankY) {
      direction = Direction.right;
    } else if (pieceX == blankX + 1 && pieceY == blankY) {
      direction = Direction.left;
    } else if (pieceX == blankX && pieceY == blankY - 1) {
      direction = Direction.down;
    } else if (pieceX == blankX && pieceY == blankY + 1) {
      direction = Direction.up;
    }

    switch (direction) {
      case Direction.up:
        return position.y >= gameRef.blankPiece.position.y &&
            position.y <= originalPosition.y;
      case Direction.down:
        return position.y <= gameRef.blankPiece.position.y &&
            position.y >= originalPosition.y;
      case Direction.left:
        return position.x >= gameRef.blankPiece.position.x &&
            position.x <= originalPosition.x;
      case Direction.right:
        return position.x <= gameRef.blankPiece.position.x &&
            position.x >= originalPosition.x;
      case null:
        return false;
    }
  }
}
