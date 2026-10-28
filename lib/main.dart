import 'package:flutter/material.dart';
import 'screens/a_list_screen.dart';

void main() => runApp(const EodiApp());

class EodiApp extends StatelessWidget {
  const EodiApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: '어디 뒀지?',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      fontFamily: 'NotoSansKR',
      scaffoldBackgroundColor: const Color(0xFFF7F8F4),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF275C48),
        primary: const Color(0xFF275C48),
        surface: const Color(0xFFF7F8F4),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    home: const FindHome(),
  );
}
