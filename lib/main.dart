import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/onboarding_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'services/mining_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize mining service
  await MiningService.instance.initialize();
  
  runApp(const NapcoinApp());
}

class NapcoinApp extends StatelessWidget {
  const NapcoinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NAPCOIN',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Arial',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AppNavigator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  bool _isFirstTime = true;
  bool _isLoggedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAppState();
  }

  Future<void> _checkAppState() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('is_first_time') ?? true;
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    setState(() {
      _isFirstTime = isFirstTime;
      _isLoggedIn = isLoggedIn;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_isFirstTime) {
      return const OnboardingScreen();
    }

    if (!_isLoggedIn) {
      return const WelcomeScreen();
    }

    return const HomeScreen();
  }
}

