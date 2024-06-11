import 'package:flutter/material.dart';

class Piece {
  int currentRow;
  int currentCol;
  final int targetRow;
  final int targetCol;
  final String label;
  AnimationController? controller;
  Animation<Offset>? animation;

  Piece(
    this.currentRow,
    this.currentCol,
    this.targetRow,
    this.targetCol,
    this.label,
  );
}
