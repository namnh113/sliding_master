import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sliding_master/src/config.dart';
import 'package:sliding_master/src/sliding_puzzle/components/sliding_item.dart';
import 'package:sliding_master/src/sliding_puzzle/model/board_position.dart';

class SlidingPuzzle extends FlameGame with KeyboardEvents {
  SlidingPuzzle({required this.axisY, required this.axisX})
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  final int axisY;
  final int axisX;

  List<int> boardState = [];
  List<int> winBoardState = [];
  BoardPosition blankItem = BoardPosition(0, 0);

  @override
  FutureOr<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;

    boardState = List.generate(axisY * axisX, (index) => index);
    winBoardState = boardState.toList();

    startGame();

    return super.onLoad();
  }

  double get height => size.y;
  double get width => size.x;

  void startGame() {
    for (int y = 0; y < axisY; ++y) {
      for (int x = 0; x < axisX; ++x) {
        // Get the index of the current item
        final stateIndex = boardState[y * axisX + x];

        if (y == blankItem.y && x == blankItem.x) {
          world.add(
            SlidingItem(
              position: NotifyingVector2(
                x * (gameWidth / axisX),
                y * (gameHeight / axisY),
              ),
              color: Colors.white,
              size: Vector2(gameWidth / axisX, gameHeight / axisY),
              orderNumber: null,
              xIndex: x.toDouble(),
              yIndex: y.toDouble(),
            ),
          );
        } else {
          world.add(
            SlidingItem(
              position: NotifyingVector2(
                x * (gameWidth / axisX),
                y * (gameHeight / axisY),
              ),
              color: brickColors[stateIndex],
              size: Vector2(gameWidth / axisX, gameHeight / axisY),
              orderNumber: stateIndex,
              xIndex: x.toDouble(),
              yIndex: y.toDouble(),
            ),
          );
        }
      }
    }
  }
}
