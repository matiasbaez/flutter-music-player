import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:musicplayer/src/models/models.dart';
import 'package:musicplayer/src/screens/screens.dart';
import 'package:musicplayer/src/theme/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AudioPlayer())
      ],
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: const MusicPlayerScreen(),
    );
  }
}
