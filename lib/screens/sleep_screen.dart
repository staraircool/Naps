import 'package:flutter/material.dart';
import '../services/mining_service.dart';
import 'dart:async';
import 'dart:math' as math;

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen>
    with TickerProviderStateMixin {
  final MiningService _miningService = MiningService.instance;
  Timer? _timer;
  Duration _remainingTime = const Duration(hours: 12);
  late AnimationController _pandaController;
  late AnimationController _zzzController;
  late AnimationController _parallaxController;
  late AnimationController _breathingController;
  late Animation<double> _pandaAnimation;
  late Animation<double> _zzzAnimation;
  late Animation<Offset> _parallaxAnimation;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pandaController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _zzzController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _parallaxController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _pandaAnimation = Tween<double>(
      begin: -5.0,
      end: 5.0,
    ).animate(CurvedAnimation(
      parent: _pandaController,
      curve: Curves.easeInOut,
    ));

    _zzzAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _zzzController,
      curve: Curves.easeInOut,
    ));

    _parallaxAnimation = Tween<Offset>(
      begin: const Offset(-0.1, 0),
      end: const Offset(0.1, 0),
    ).animate(CurvedAnimation(
      parent: _parallaxController,
      curve: Curves.linear,
    ));

    _breathingAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pandaController.dispose();
    _zzzController.dispose();
    _parallaxController.dispose();
    _breathingController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  Future<void> _wakeUp() async {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < -500) {
            _wakeUp();
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0F0F23),
                Color(0xFF1A1A2E),
                Color(0xFF16213E),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Parallax background elements
              AnimatedBuilder(
                animation: _parallaxAnimation,
                builder: (context, child) {
                  return Positioned.fill(
                    child: Transform.translate(
                      offset: Offset(
                        _parallaxAnimation.value.dx * 50,
                        _parallaxAnimation.value.dy * 50,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: const Alignment(0.3, -0.5),
                            radius: 1.5,
                            colors: [
                              Colors.blue.withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Floating particles
              ...List.generate(20, (index) {
                return AnimatedBuilder(
                  animation: _parallaxController,
                  builder: (context, child) {
                    final offset = math.sin(_parallaxController.value * 2 * math.pi + index) * 20;
                    return Positioned(
                      left: (index * 50.0) % MediaQuery.of(context).size.width,
                      top: 100 + offset + (index * 30.0) % 400,
                      child: Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                );
              }),
              SafeArea(
                child: Column(
                  children: [
                    // Timer section
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: AnimatedBuilder(
                        animation: _breathingAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _breathingAnimation.value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.blue.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'Start next session after\n${_formatDuration(_remainingTime)}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Dream mode message
                    const Text(
                      '"You\'re in Dream Mode. You\'ll wake up with more \$NAP."',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Animated sleeping panda
                            AnimatedBuilder(
                              animation: _pandaAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _pandaAnimation.value),
                                  child: AnimatedBuilder(
                                    animation: _breathingAnimation,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _breathingAnimation.value,
                                        child: Container(
                                          width: 200,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.blue.withOpacity(0.3),
                                                blurRadius: 20,
                                                spreadRadius: 5,
                                              ),
                                            ],
                                          ),
                                          child: ClipOval(
                                            child: Image.asset(
                                              'assets/images/sleeping_panda.jpeg',
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.white,
                                                  child: const Icon(
                                                    Icons.pets,
                                                    size: 100,
                                                    color: Colors.black,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 40),
                            // Animated ZZZ
                            AnimatedBuilder(
                              animation: _zzzAnimation,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: _zzzAnimation.value,
                                  child: Transform.translate(
                                    offset: Offset(
                                      20 + (_zzzAnimation.value * 30),
                                      -20 - (_zzzAnimation.value * 20),
                                    ),
                                    child: Transform.scale(
                                      scale: 0.8 + (_zzzAnimation.value * 0.4),
                                      child: const Text(
                                        'Z Z Z',
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white70,
                                          letterSpacing: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Swipe up to awake
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          const Text(
                            'Swipe Up to Awake',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AnimatedBuilder(
                            animation: _breathingAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _breathingAnimation.value,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.keyboard_arrow_up,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

