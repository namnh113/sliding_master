import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sliding_master/firebase_options.dart';
import 'package:sliding_master/src/game_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const GameApp());
}
