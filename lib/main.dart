import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // ✅ Light Theme
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 1,
        ),
       cardTheme: const CardThemeData(
  color: Colors.white,
  elevation: 3,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
  ),
),

        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo),
          ),
          labelStyle: TextStyle(color: Colors.indigo),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.indigo),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 15),
        ),
      ),

      // ✅ Dark Theme
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.tealAccent,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardTheme: const CardThemeData(
  color: Color(0xFF1E1E1E),
  elevation: 3,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
  ),
),

        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF1E1E1E),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.tealAccent),
          ),
          labelStyle: TextStyle(color: Colors.tealAccent),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.tealAccent),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.tealAccent,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.tealAccent,
          foregroundColor: Colors.black,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 15),
        ),
      ),

      home: const SplashScreen(),
    );
  }
}
