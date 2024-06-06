import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_master/app_lifecycle/app_lifecycle.dart';
import 'package:sliding_master/audio/audio_controller.dart';
import 'package:sliding_master/player_progress/player_progress.dart';
import 'package:sliding_master/router.dart';
import 'package:sliding_master/settings/settings.dart';
import 'package:sliding_master/style/palette.dart';

// class App extends StatefulWidget {
//   const App({super.key});

//   @override
//   State<App> createState() => _AppState();
// }

// class _AppState extends State<App> {
//   late final SlidingPuzzle game;

//   @override
//   void initState() {
//     super.initState();
//     game = SlidingPuzzle(
//       axisX: 3,
//       axisY: 4,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         textTheme: GoogleFonts.pressStart2pTextTheme().apply(
//           bodyColor: const Color(0xff184e77),
//           displayColor: const Color(0xff184e77),
//         ),
//       ),
//       home: Scaffold(
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Color(0xffa9d6e5),
//                 Color(0xfff2e8cf),
//               ],
//             ),
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     FittedBox(
//                       child: SizedBox(
//                         width: gameWidth,
//                         height: gameHeight,
//                         child: GameWidget.controlled(
//                           gameFactory: () => game,
//                           // overlayBuilderMap: {
//                           // PlayState.welcome.name: (context, game) => const OverlayScreen(
//                           //   title: 'TAP TO PLAY',
//                           //   subtitle: 'Use arrow keys or swipe',
//                           // ),
//                           // PlayState.gameOver.name: (context, game) => const OverlayScreen(
//                           //   title: 'G A M E   O V E R',
//                           //   subtitle: 'Tap to Play Again',
//                           // ),
//                           // PlayState.won.name: (context, game) => const OverlayScreen(
//                           //   title: 'Y O U   W O N ! ! !',
//                           //   subtitle: 'Tap to Play Again',
//                           // ),
//                           // },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
        // This is where you add objects that you want to have available
        // throughout your game.
        //
        // Every widget in the game can access these objects by calling
        // `context.watch()` or `context.read()`.
        // See `lib/main_menu/main_menu_screen.dart` for example usage.
        providers: [
          Provider(create: (context) => SettingsController()),
          Provider(create: (context) => Palette()),
          ChangeNotifierProvider(create: (context) => PlayerProgress()),
          // Set up audio.
          ProxyProvider2<AppLifecycleStateNotifier, SettingsController,
              AudioController>(
            create: (context) {
              AudioCache.instance = AudioCache(prefix: '');

              return AudioController();
            },
            update: (context, lifecycleNotifier, settings, audio) {
              audio!.attachDependencies(lifecycleNotifier, settings);
              return audio;
            },
            dispose: (context, audio) => audio.dispose(),
            // Ensures that music starts immediately
            lazy: false,
          ),
        ],
        child: Builder(
          builder: (context) {
            final palette = context.watch<Palette>();

            return MaterialApp.router(
              title: 'My Flutter Game',
              theme: ThemeData.from(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: palette.darkPen,
                  surface: palette.backgroundMain,
                ),
                textTheme: TextTheme(
                  bodyMedium: TextStyle(color: palette.ink),
                ),
                useMaterial3: true,
              ).copyWith(
                // Make buttons more fun.
                filledButtonTheme: FilledButtonThemeData(
                  style: FilledButton.styleFrom(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              routerConfig: router,
            );
          },
        ),
      ),
    );
  }
}
