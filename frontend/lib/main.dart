import 'package:flutter/material.dart';

import 'package:youtube_chatbot/app_theme.dart';
import 'package:youtube_chatbot/screens/home_page.dart';

void main() {
  runApp(const RagApp());
}

class RagApp extends StatelessWidget {
  const RagApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube RAG Chat',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
