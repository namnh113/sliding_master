// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:sliding_master/gen/assets.gen.dart';

List<String> soundTypeToFilename(SfxType type) => switch (type) {
      SfxType.huhsh => [
          Assets.sfx.hash1,
          Assets.sfx.hash2,
          Assets.sfx.hash3,
        ],
      SfxType.wssh => [
          Assets.sfx.wssh1,
          Assets.sfx.wssh2,
          Assets.sfx.dsht1,
          Assets.sfx.ws1,
          Assets.sfx.spsh1,
          Assets.sfx.hh1,
          Assets.sfx.hh2,
          Assets.sfx.kss1,
        ],
      SfxType.buttonTap => [
          Assets.sfx.k1,
          Assets.sfx.k2,
          Assets.sfx.p1,
          Assets.sfx.p2,
        ],
      SfxType.congrats => [
          Assets.sfx.yay1,
          Assets.sfx.wehee1,
          Assets.sfx.oo1,
        ],
      SfxType.erase => [
          Assets.sfx.fwfwfwfwfw1,
          Assets.sfx.fwfwfwfw1,
        ],
      SfxType.swishSwish => [
          Assets.sfx.swishswish1,
        ]
    };

/// Allows control over loudness of different SFX types.
double soundTypeToVolume(SfxType type) {
  switch (type) {
    case SfxType.huhsh:
      return 0.4;
    case SfxType.wssh:
      return 0.2;
    case SfxType.buttonTap:
    case SfxType.congrats:
    case SfxType.erase:
    case SfxType.swishSwish:
      return 1.0;
  }
}

enum SfxType {
  huhsh,
  wssh,
  buttonTap,
  congrats,
  erase,
  swishSwish,
}
