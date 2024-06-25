import 'dart:async';
import 'dart:ui' as ui;
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sliding_master/sliding_puzzle/model/piece.dart';

class SlidingPuzzle extends FlameGame with TapDetector, KeyboardEvents {
  final int axisX;
  final int axisY;
  late List<Piece> _originalPiece;
  late List<Piece> playingPiece;
  late Vector2 pieceSize;
  late ui.Image image;

  double get width => size.x;
  double get height => size.y;

  SlidingPuzzle({
    this.axisX = 3,
    this.axisY = 4,
  }) : super() {
    _originalPiece = [];
  }

  Piece? get blankPiece => world.children
      .query<Piece>()
      .firstWhereOrNull((element) => element.index == 0);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    camera.viewfinder.anchor = Anchor.topLeft;
    pieceSize = Vector2(size.x / axisX, size.y / axisY);

    await initImage();
    initialBoard();
    initializeGrid();
  }

  Future<void> initImage() async {
    final double ratio = width / height;
    image = await Flame.images.load('game.jpg');
    final double imageRatio = image.width / image.height;
    if (size.x > image.width || size.y > image.height) {
      // Todo: handle later
      throw Exception('image is too small');
    }
    if (imageRatio > ratio) {
      // fit in height
      image = await image.resize(Vector2(size.y * imageRatio, size.y));
    } else {
      // fit in width
      image = await image.resize(Vector2(size.x, size.x / imageRatio));
    }
  }

  void initializeGrid() {
    removeAllPieces();
    sufferPiece();
    renderPieces();
  }

  void sufferPiece() {
    playingPiece = List<Piece>.from(_originalPiece);
    playingPiece.shuffle();
    playingPiece = playingPiece
        .asMap()
        .map((index, piece) {
          return MapEntry(
            index,
            Piece(
              position: _originalPiece.elementAt(index).position,
              size: piece.size,
              index: piece.index,
              sprite: piece.sprite,
            ),
          );
        })
        .values
        .toList();
  }

  void removeAllPieces() {
    world.removeAll(world.children.query<Piece>());
  }

  void initialBoard() async {
    int index = 0;

    for (var y = 0; y < axisY; y++) {
      for (var x = 0; x < axisX; x++) {
        final croppedImage = Sprite(
          image,
          srcPosition: Vector2(x * pieceSize.x + 20, y * pieceSize.y),
          srcSize: pieceSize,
        );

        _originalPiece.add(
          Piece(
            position: Vector2(x * pieceSize.x, y * pieceSize.y),
            size: pieceSize,
            index: index,
            sprite: croppedImage,
          ),
        );
        index++;
      }
    }
  }

  void renderPieces() {
    world.addAll(playingPiece);
    blankPiece?.add(OpacityEffect.to(0.2, EffectController(duration: 0.2)));
  }

  // bool checkWinCondition() {
  //   return areListsEqual(pieceIds, _originalPieceIds);
  // }

  @override
  void onTap() {
    // initializeGrid();
  }

  @override
  Color backgroundColor() => Colors.white;

  void swapPiece(Piece piece) {
    if (piece.swappable && blankPiece != null) {
      Vector2 blankPiecePosition = blankPiece!.position;
      Vector2 piecePosition = piece.position;

      blankPiece
          ?.add(MoveEffect.to(piece.position, EffectController(duration: 0.2)));
      piece.add(
        MoveEffect.to(blankPiece!.position, EffectController(duration: 0.2)),
      );

      blankPiece?.position = piecePosition;
      piece.position = blankPiecePosition;

      updateToState(piece);
    }
  }

  void updateToState(Piece piece) {
    int indexBlankPiece = playingPiece.indexOf(blankPiece!);
    int indexPiece = playingPiece.indexOf(piece);

    Piece temp = playingPiece[indexBlankPiece];
    playingPiece[indexBlankPiece] = piece;
    playingPiece[indexPiece] = temp;
  }
}
