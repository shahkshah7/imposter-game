import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:imposter_game/screens/join_lobby/join_lobby_screen.dart';
import 'package:imposter_game/services/websocket_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid || Platform.isIOS) {
    await WebSocketService.init();
  }

  runApp(const ImposterGameApp());
}

class ImposterGameApp extends StatelessWidget {
  const ImposterGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Imposter Game",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const JoinLobbyScreen(),
    );
  }
}
