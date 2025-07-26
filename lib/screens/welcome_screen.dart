import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pandaAnimation;
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pandaAnimation = Tween<double>(
      begin: -5.0,
      end: 5.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to Terms & Conditions and Privacy Policy'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB19CD9), // Light purple
              Color(0xFF2D1B3D), // Dark purple/black
            ],
            stops: [0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Panda section
              Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated panda
                      AnimatedBuilder(
                        animation: _pandaAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _pandaAnimation.value),
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Panda ears
                                  Positioned(
                                    top: 20,
                                    left: 50,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 20,
                                    right: 50,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  // Panda face
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Eye patches
                                        Positioned(
                                          top: 25,
                                          left: 20,
                                          child: Container(
                                            width: 25,
                                            height: 35,
                                            decoration: const BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 25,
                                          right: 20,
                                          child: Container(
                                            width: 25,
                                            height: 35,
                                            decoration: const BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Eyes
                                        Positioned(
                                          top: 35,
                                          left: 27,
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 35,
                                          right: 27,
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        // Nose
                                        Positioned(
                                          top: 55,
                                          child: Container(
                                            width: 8,
                                            height: 6,
                                            decoration: const BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(4),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Mouth
                                        Positioned(
                                          top: 65,
                                          child: Container(
                                            width: 20,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.black,
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Panda paw
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.circle,
                                          color: Colors.white,
                                          size: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Welcome text and buttons section
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2D1B3D),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        const Text(
                          'WELCOME TO NAP',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'For the Dreamers, Not the Grinders',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        // Terms checkbox
                        Row(
                          children: [
                            Checkbox(
                              value: _agreeToTerms,
                              onChanged: (value) {
                                setState(() {
                                  _agreeToTerms = value ?? false;
                                });
                              },
                              activeColor: Colors.blue,
                              checkColor: Colors.white,
                            ),
                            Expanded(
                              child: Text(
                                "I agree to Headspace's Terms & Conditions and acknowledge the Privacy Policy.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // Create account button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Create an account',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Log in button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            onPressed: _handleLogin,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              backgroundColor: Colors.white.withOpacity(0.1),
                            ),
                            child: const Text(
                              'Log in',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

