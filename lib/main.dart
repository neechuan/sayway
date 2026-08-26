import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'data/services/hive_service.dart';
import 'features/board/board_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait for AAC consistency
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialize local storage
  await HiveService.init();

  runApp(
    const ProviderScope(
      child: SayMyWayApp(),
    ),
  );
}

class SayMyWayApp extends StatelessWidget {
  const SayMyWayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SayMyWay — AAC Communication',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const BoardScreen(),
    );
  }
}
