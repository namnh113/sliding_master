import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:sliding_master/src/sliding_puzzle/sliding_puzzle.dart';

class SlidingItem extends RectangleComponent
    with HasGameReference<SlidingPuzzle>, TapCallbacks {
  SlidingItem({
    required NotifyingVector2 position,
    required Color color,
    required Vector2 size,
    required this.orderNumber,
    required this.xIndex,
    required this.yIndex,
  }) : super(
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.fill,
          size: size,
          position: position,
        );

  final int? orderNumber;

  int xIndex;
  int yIndex;

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    add(_buildItemName());
  }

  @override
  void onTapUp(TapUpEvent event) {
    final blankItem = game.blankItem;
    if (_isAdjacentToBlank()) {
      _swapToBlankItem(blankItem);
    }
    game.checkWin();
  }

  bool get isBlank => orderNumber == null;

  Component _buildItemName() {
    return TextComponent(
      text: orderNumber != null ? orderNumber.toString() : '',
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xff000000),
          fontSize: 40,
        ),
      ),
      position: Vector2(size.x / 2, size.y / 2),
    );
  }

  bool _isAdjacentToBlank() {
    List<int> x = [-1, 0, 1, 0];
    List<int> y = [0, 1, 0, -1];
    for (int i = 0; i < 4; ++i) {
      if (xIndex + x[i] < 0 ||
          xIndex + x[i] >= game.columns ||
          yIndex + y[i] < 0 ||
          yIndex + y[i] >= game.rows) {
        continue;
      }
      if (game.gameBoard[yIndex + y[i]][xIndex + x[i]].isBlank) {
        return true;
      }
    }
    return false;
  }

  void _swapToBlankItem(SlidingItem blankItem) {
    //Change position in the coordinates
    final Vector2 currentPosition = Vector2(position.x, position.y);
    position = blankItem.position;
    blankItem.position = currentPosition;

    //Change position in the gameBoard
    final currentXIndex = xIndex;
    final currentYIndex = yIndex;
    xIndex = game.blankItem.xIndex;
    yIndex = game.blankItem.yIndex;
    blankItem.xIndex = currentXIndex;
    blankItem.yIndex = currentYIndex;
    game.gameBoard[yIndex][xIndex] = this;
    game.gameBoard[blankItem.yIndex][blankItem.xIndex] = blankItem;
  }
}
