// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:sliding_master/gen/assets.gen.dart';

Set<Song> songs = {
  // Filenames with whitespace break package:audioplayers on iOS
  // (as of February 2022), so we use no whitespace.
  Song(Assets.music.mrSmithAzul, 'Azul', artist: 'Mr Smith'),
  Song(Assets.music.mrSmithSonorus, 'Sonorus', artist: 'Mr Smith'),
  Song(
    Assets.music.mrSmithSundaySolitude,
    'SundaySolitude',
    artist: 'Mr Smith',
  ),
  Song(
    Assets.music.byteBlast8BitArcadeMusicBackgroundMusicForVideo208780,
    'Blast8Bit',
    artist: 'No Copyright Music',
  ),
};

class Song {
  final String filename;

  final String name;

  final String? artist;

  const Song(this.filename, this.name, {this.artist});

  @override
  String toString() => 'Song<$filename>';
}
