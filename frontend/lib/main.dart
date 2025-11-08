import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/customer_signup_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Make the status bar adapt automatically to system theme
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: const Color(0xFF11121A), // your dark fintech background
      // These two values will automatically adapt to system brightness:
      statusBarIconBrightness: WidgetsBinding.instance.window.platformBrightness == Brightness.dark
          ? Brightness.light  // if system in dark mode → show light icons
          : Brightness.dark,  // if system in light mode → show dark icons
      statusBarBrightness: WidgetsBinding.instance.window.platformBrightness == Brightness.dark
          ? Brightness.dark
          : Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dhannalyze',
      themeMode: ThemeMode.system, // ✅ automatically adapts to system mode
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF4F5F9),
        fontFamily: 'Poppins',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF11121A),
        fontFamily: 'Poppins',
      ),
      home: const CustomerSignupScreen(),
    );
  }
}
