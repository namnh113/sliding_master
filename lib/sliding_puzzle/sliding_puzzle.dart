import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sliding_master/config.dart';
import 'package:sliding_master/sliding_puzzle/model/piece.dart';

class SlidingPuzzle extends FlameGame with TapDetector, KeyboardEvents {
  final int axisX;
  final int axisY;
  late List<int> grid;
  late double pieceWidth = 0;
  late double pieceHeight = 0;

  double get width => size.x;
  double get height => size.y;

  SlidingPuzzle({
    this.axisX = 3,
    this.axisY = 4,
  }) : super();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    camera.viewfinder.anchor = Anchor.topLeft;
    pieceWidth = size.x / axisX;
    pieceHeight = size.y / axisY;
    initializeGrid();
  }

  Piece get blankPiece => world.children
      .query<Piece>()
      .firstWhere((element) => element.label == '');

  void initializeGrid() {
    world.removeAll(world.children.query<Piece>());
    grid = List<int>.generate(axisX * axisY, (index) => index);
    // grid.shuffle();
    for (var y = 0; y < axisY; y++) {
      for (var x = 0; x < axisX; x++) {
        var index = y * axisX + x;
        world.add(
          Piece(
            position: Vector2(x * pieceWidth, y * pieceHeight),
            size: Vector2(pieceWidth, pieceHeight),
            label: index == 0 ? '' : index.toString(),
            color: index == 0 ? Colors.transparent : brickColors[index],
          ),
        );
      }
    }
  }

  bool checkWinCondition() {
    // TODO: implement checkWinCondition
    return false;
  }

  @override
  void onTap() {
    initializeGrid();
  }

  @override
  Color backgroundColor() => Colors.white;
}
