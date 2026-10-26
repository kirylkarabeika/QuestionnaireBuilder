import 'package:flutter/material.dart';

import 'editor/draft_store.dart';
import 'editor/editor_controller.dart';
import 'editor/editor_screen.dart';

export 'editor/editor_screen.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key, this.draftStore, this.controller});
  final DraftStore? draftStore;
  final EditorController? controller;

  @override
  Widget build(BuildContext context) {
    final colors = ColorScheme.fromSeed(seedColor: const Color(0xFF3057B7));
    return MaterialApp(
      title: 'Questionnaire Builder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colors,
        scaffoldBackgroundColor: const Color(0xFFF6F7FA),
        appBarTheme: AppBarTheme(
          backgroundColor: colors.surface,
          surfaceTintColor: Colors.transparent,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: colors.outlineVariant),
          ),
        ),
        dividerTheme: DividerThemeData(color: colors.outlineVariant),
      ),
      home: EditorScreen(draftStore: draftStore, controller: controller),
    );
  }
}
