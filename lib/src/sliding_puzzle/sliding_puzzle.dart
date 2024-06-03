import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sliding_master/src/config.dart';
import 'package:sliding_master/src/sliding_puzzle/components/sliding_item.dart';

class SlidingPuzzle extends FlameGame with KeyboardEvents {
  SlidingPuzzle({required this.rows, required this.columns})
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  final int columns;
  final int rows;

  List<List<SlidingItem>> gameBoard = [];

  @override
  FutureOr<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;

    gameBoard = List.generate(rows, (_) => []);

    startGame();

    return super.onLoad();
  }

  SlidingItem get blankItem => world.children
      .whereType<SlidingItem>()
      .firstWhere((element) => element.orderNumber == null);

  double get height => size.y;
  double get width => size.x;

  void startGame() {
    final listItem = List.generate(rows * columns, (index) => index + 1);
    listItem.shuffle();
    for (int i = 0; i < rows; ++i) {
      for (int j = 0; j < columns; ++j) {
        final isBlank = i * columns + j == rows * columns - 1;
        final item = SlidingItem(
          position: NotifyingVector2(
            j * (gameWidth / columns),
            i * (gameHeight / rows),
          ),
          color: isBlank
              ? Colors.white
              : Color.fromARGB(
                  255,
                  Random().nextInt(256),
                  Random().nextInt(256),
                  Random().nextInt(256),
                ),
          size: Vector2(gameWidth / columns, gameHeight / rows),
          orderNumber: isBlank ? null : listItem[i * columns + j],
          xIndex: j,
          yIndex: i,
        );
        gameBoard[i].add(item);
        world.add(item);
      }
    }
  }
}
