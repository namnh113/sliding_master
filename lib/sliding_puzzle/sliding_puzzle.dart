import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sliding_master/sliding_puzzle/model/piece.dart';

class SlidingPuzzle extends FlameGame with PanDetector {
  final int rows = 3;
  final int cols = 4;
  late List<List<Piece?>> grid;
  late Piece? emptySpace;
  late double pieceWidth;
  late double pieceHeight;

  @override
  Future<void> onLoad() async {
    initializeGrid();
    pieceWidth = size.x / cols;
    pieceHeight = size.y / rows;
  }

  void initializeGrid() {
    grid = List.generate(
      rows,
      (row) => List.generate(cols, (col) {
        if (row == rows - 1 && col == cols - 1) {
          emptySpace = Piece(row, col, row, col, '');
          return null; // Empty space
        }
        return Piece(row, col, row, col, '${row * cols + col + 1}');
      }),
    );
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (info.delta.global.x.abs() > info.delta.global.y.abs()) {
      if (info.delta.global.x > 0) {
        slidePiece('right');
      } else {
        slidePiece('left');
      }
    } else {
      if (info.delta.global.y > 0) {
        slidePiece('down');
      } else {
        slidePiece('up');
      }
    }
  }

  void slidePiece(String direction) {
    int row = emptySpace!.currentRow;
    int col = emptySpace!.currentCol;
    int targetRow = row;
    int targetCol = col;

    switch (direction) {
      case 'up':
        targetRow++;
        break;
      case 'down':
        targetRow--;
        break;
      case 'left':
        targetCol++;
        break;
      case 'right':
        targetCol--;
        break;
    }

    if (targetRow >= 0 &&
        targetRow < rows &&
        targetCol >= 0 &&
        targetCol < cols) {
      Piece? piece = grid[targetRow][targetCol];
      if (piece != null) {
        grid[row][col] = piece;
        grid[targetRow][targetCol] = null;
        piece.currentRow = row;
        piece.currentCol = col;
        emptySpace!.currentRow = targetRow;
        emptySpace!.currentCol = targetCol;

        // Add animation
        final oldPosition =
            Offset(piece.currentCol.toDouble(), piece.currentRow.toDouble());
        final newPosition = Offset(targetCol.toDouble(), targetRow.toDouble());

        // piece.controller = AnimationController(
        //   duration: const Duration(milliseconds: 300),
        //   vsync: this,
        // );
        piece.animation = Tween<Offset>(begin: oldPosition, end: newPosition)
            .animate(piece.controller!);
        piece.controller!.forward().then((_) {
          piece.controller!.dispose();
          piece.controller = null;
        });

        if (checkWinCondition()) {
          // print('You won!');
        }
      }
    }
  }

  bool checkWinCondition() {
    for (var row in grid) {
      for (var piece in row) {
        if (piece != null) {
          if (piece.currentRow != piece.targetRow ||
              piece.currentCol != piece.targetCol) {
            return false;
          }
        }
      }
    }
    return true;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (var row in grid) {
      for (var piece in row) {
        if (piece != null) {
          final position = piece.animation?.value ??
              Offset(piece.currentCol.toDouble(), piece.currentRow.toDouble());
          final rect = Rect.fromLTWH(
            position.dx * pieceWidth,
            position.dy * pieceHeight,
            pieceWidth,
            pieceHeight,
          );
          canvas.drawRect(rect, paint);

          final textSpan = TextSpan(
            text: piece.label,
            style: TextStyle(color: Colors.white, fontSize: pieceWidth / 2),
          );
          textPainter.text = textSpan;
          textPainter.layout();
          textPainter.paint(
            canvas,
            Offset(
              rect.center.dx - textPainter.width / 2,
              rect.center.dy - textPainter.height / 2,
            ),
          );
        }
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (var row in grid) {
      for (var piece in row) {
        if (piece?.controller != null && piece!.controller!.isAnimating) {
          piece.controller!.addListener(() {
            // markNeedsPaint();
          });
        }
      }
    }
  }
}
