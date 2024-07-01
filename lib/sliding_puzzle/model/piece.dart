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
        ) {
    initOriginalPosition();
  }

  final int index;

  late Vector2 _originalPosition;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (index != game.blankPiece?.index) {
      if (swappableHorizontal && draggable) {
        position.x =
            (position.x + event.localDelta.x).clamp(0, game.width - size.x);
      }

      if (swappableVertical && draggable) {
        position.y =
            (position.y + event.localDelta.y).clamp(0, game.height - size.y);
      }
    }
  }

  @override
  onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (index != game.blankPiece?.index && game.blankPiece != null) {
      if (swappableHorizontal &&
          position.distanceTo(game.blankPiece!.position) <
              gameRef.pieceSize.x / 2) {
        resetPosition();
        game.swapPiece(this);
      } else if (swappableVertical &&
          position.distanceTo(game.blankPiece!.position) <
              gameRef.pieceSize.y / 2) {
        resetPosition();
        game.swapPiece(this);
      } else {
        resetPosition();
      }
      initOriginalPosition();
    }
  }

  // @override
  // void onTapDown(TapDownEvent event) {
  //   super.onTapDown(event);
  //   game.swapPiece(this);
  // }

  bool get swappable => swappableVertical || swappableHorizontal;

  bool get swappableHorizontal =>
      game.blankPiece?.position.y.roundToDouble() == position.y.roundToDouble();

  bool get swappableVertical =>
      game.blankPiece?.position.x.roundToDouble() == position.x.roundToDouble();

  bool get draggable {
    if (gameRef.blankPiece == null || gameRef.blankPiece!.index == index) {
      return false;
    }

    var blankX = gameRef.blankPiece!.position.x ~/ gameRef.pieceSize.x;
    var blankY = gameRef.blankPiece!.position.y ~/ gameRef.pieceSize.y;
    var pieceX = _originalPosition.x ~/ gameRef.pieceSize.x;
    var pieceY = _originalPosition.y ~/ gameRef.pieceSize.y;

    if (pieceX == blankX - 1 && pieceY == blankY) {
      return position.x <= gameRef.blankPiece!.position.x &&
          position.x >= _originalPosition.x &&
          position.y == _originalPosition.y;
    } else if (pieceX == blankX + 1 && pieceY == blankY) {
      return position.x >= gameRef.blankPiece!.position.x &&
          position.x <= _originalPosition.x &&
          position.y == _originalPosition.y;
    } else if (pieceX == blankX && pieceY == blankY - 1) {
      return position.y <= gameRef.blankPiece!.position.y &&
          position.y >= _originalPosition.y &&
          position.x == _originalPosition.x;
    } else if (pieceX == blankX && pieceY == blankY + 1) {
      return position.y >= gameRef.blankPiece!.position.y &&
          position.y <= _originalPosition.y &&
          position.x == _originalPosition.x;
    }

    return false;
  }

  void initOriginalPosition() {
    _originalPosition = position.clone();
  }

  void resetPosition() {
    position = _originalPosition;
  }
}
