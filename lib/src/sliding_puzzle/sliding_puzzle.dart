import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sliding_master/src/config.dart';
import 'package:sliding_master/src/sliding_puzzle/components/sliding_item.dart';

enum PlayState { welcome, playing, paused, win }

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

  late PlayState _playState;

  @override
  FutureOr<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;

    startGame();

    return super.onLoad();
  }

  SlidingItem get blankItem => world.children
      .whereType<SlidingItem>()
      .firstWhere((element) => element.orderNumber == null);

  double get height => size.y;
  double get width => size.x;
  PlayState get playState => _playState;

  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
      case PlayState.paused:
      case PlayState.win:
        overlays.add(playState.name);
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.paused.name);
        overlays.remove(PlayState.win.name);
    }
  }

  void startGame() {
    playState = PlayState.welcome;
    world.removeAll(world.children);
    gameBoard.clear();
    for (int i = 0; i < rows; ++i) {
      gameBoard.add([]);
    }

    final listItem = List.generate(rows * columns - 1, (index) => index + 1);
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

  void checkWin() {
    List<List<int>> gameItemOrder = gameBoard
        .map(
          (row) => row.map((e) => e.orderNumber ?? (rows * columns)).toList(),
        )
        .toList();
    final isWin = isMatrixSorted(gameItemOrder);
    if (isWin) {
      playState = PlayState.win;
    }
  }

  bool isMatrixSorted(List<List<int>> matrix) {
    if (matrix.isEmpty) return true;

    int rows = matrix.length;
    int cols = matrix[0].length;

    //ensure that rows are sorted
    for (int i = 0; i < rows; i++) {
      for (int j = 1; j < cols; j++) {
        if (matrix[i][j] < matrix[i][j - 1]) {
          return false;
        }
      }
    }

    //ensure that columns are sorted
    for (int j = 0; j < cols; j++) {
      for (int i = 1; i < rows; i++) {
        if (matrix[i][j] < matrix[i - 1][j]) {
          return false;
        }
      }
    }

    return true;
  }
}
