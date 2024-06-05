import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_master/src/sliding_puzzle/sliding_puzzle.dart';
import 'package:sliding_master/src/widgets/overlay_screen.dart';

import 'config.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final SlidingPuzzle game;

  @override
  void initState() {
    super.initState();
    game = SlidingPuzzle(rows: 3, columns: 3);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.pressStart2pTextTheme().apply(
          bodyColor: const Color(0xff184e77),
          displayColor: const Color(0xff184e77),
        ),
      ),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffa9d6e5),
                Color(0xfff2e8cf),
              ],
            ),
          ),
          child: SafeArea(
            child: GestureDetector(
              onTap: () {
                if (game.playState == PlayState.welcome) {
                  game.playState = PlayState.playing;
                } else if (game.playState == PlayState.paused) {
                  game.playState = PlayState.playing;
                } else if (game.playState == PlayState.win) {
                  game.playState = PlayState.playing;
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FittedBox(
                        child: SizedBox(
                          width: gameWidth,
                          height: gameHeight,
                          child: GameWidget.controlled(
                            gameFactory: () => game,
                            overlayBuilderMap: {
                              PlayState.welcome.name: (context, game) =>
                                  const OverlayScreen(
                                    title: 'TAP TO PLAY',
                                    subtitle: 'Click or swipe to play',
                                  ),
                              PlayState.win.name: (context, game) =>
                                  const OverlayScreen(
                                    title: 'YOU WON !!!',
                                    subtitle: 'Tap to Play Again',
                                  ),
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
