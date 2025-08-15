import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// 1. Make sure to import your dashboard screen
import 'screens/dashboard_screen.dart';
import 'firebase_options.dart';

void main() async {
  // This is the clean way to initialize
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AURAApp());
}

class AURAApp extends StatelessWidget {
  const AURAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AURA Monitor',
      theme: ThemeData(
        // Updated color scheme to match the teal/green gradient
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',

        // Dark theme to match the background
        brightness: Brightness.dark,

        // Updated app bar theme for the dark teal look with app name
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A4A4A), // Dark teal
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true, // Center the app name
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0, // Spacing like in your image
          ),
        ),

        // Compact card theme for desktop view
        cardTheme: const CardTheme(
          elevation: 6,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          color: Colors.white,
          margin: EdgeInsets.all(8), // Smaller margins for compact layout
        ),

        // Text theme for better contrast and compact sizing
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          titleMedium: TextStyle(color: Colors.white, fontSize: 16),
          titleSmall: TextStyle(color: Colors.white, fontSize: 14),
          bodyLarge: TextStyle(color: Colors.white70, fontSize: 14),
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 12),
          bodySmall: TextStyle(color: Colors.white60, fontSize: 10),
        ),

        // Updated color scheme (removed deprecated properties)
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF26A69A), // Teal accent
          secondary: Color(0xFFFF5252), // Red accent for important values
          surface: Colors.white,
          primaryContainer: Color(0xFF1A4A4A),
          secondaryContainer: Color(0xFFFF5252),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black87,
          onPrimaryContainer: Colors.white,
          onSecondaryContainer: Colors.white,
        ),
      ),

      // 2. Set your DashboardScreen as the home screen
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AURA'), // Your app name displayed
        ),
        body: DashboardScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
