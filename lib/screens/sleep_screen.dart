import 'package:flutter/material.dart';
import 'dart:async';
import '../services/mining_service.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen>
    with TickerProviderStateMixin {
  final MiningService _miningService = MiningService.instance;
  late AnimationController _pandaAnimationController;
  late AnimationController _zzAnimationController;
  late Animation<double> _pandaFloatAnimation;
  late Animation<double> _zzOpacityAnimation;
  Timer? _timerUpdateTimer;
  String _remainingTime = '12:00:00';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startMining();
    _startTimerUpdates();
  }

  void _initializeAnimations() {
    // Panda floating animation
    _pandaAnimationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _pandaFloatAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _pandaAnimationController,
      curve: Curves.easeInOut,
    ));

    // ZZZ animation
    _zzAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _zzOpacityAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _zzAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _startMining() async {
    if (!_miningService.isMining) {
      await _miningService.startMining();
    }
  }

  void _startTimerUpdates() {
    _updateTimer();
    _timerUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimer();
    });
  }

  void _updateTimer() {
    final remaining = _miningService.getRemainingTime();
    if (remaining != null) {
      final hours = remaining.inHours;
      final minutes = remaining.inMinutes % 60;
      final seconds = remaining.inSeconds % 60;
      
      setState(() {
        _remainingTime = '${hours.toString().padLeft(2, '0')}:'
            '${minutes.toString().padLeft(2, '0')}:'
            '${seconds.toString().padLeft(2, '0')}';
      });

      // If time is up, navigate back
      if (remaining.inSeconds <= 0) {
        _wakeUp();
      }
    }
  }

  void _wakeUp() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _pandaAnimationController.dispose();
    _zzAnimationController.dispose();
    _timerUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < -500) {
            // Swipe up to wake
            _wakeUp();
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A1A2E), // Dark blue
                Color(0xFF0F0F23), // Very dark blue/black
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Timer section
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          'Start next session after\n$_remainingTime',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '"You\'re in Dream Mode. You\'ll wake up with more \$NAP."',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                // Sleeping panda section
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Animated panda
                        AnimatedBuilder(
                          animation: _pandaFloatAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _pandaFloatAnimation.value),
                              child: _buildSleepingPanda(),
                            );
                          },
                        ),
                        // ZZZ animation
                        Positioned(
                          top: 50,
                          right: 80,
                          child: AnimatedBuilder(
                            animation: _zzOpacityAnimation,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _zzOpacityAnimation.value,
                                child: Column(
                                  children: [
                                    _buildZZZ(size: 24, delay: 0),
                                    const SizedBox(height: 8),
                                    _buildZZZ(size: 20, delay: 200),
                                    const SizedBox(height: 8),
                                    _buildZZZ(size: 16, delay: 400),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom section with swipe up
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      const Text(
                        'Swipe Up to Awake',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_up,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSleepingPanda() {
    return SizedBox(
      width: 200,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Branch/log
          Positioned(
            bottom: 20,
            child: Container(
              width: 160,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFF8B4513), // Brown
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          // Panda body
          Positioned(
            bottom: 30,
            child: Container(
              width: 120,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
            ),
          ),
          // Panda head
          Positioned(
            bottom: 70,
            left: 40,
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Ears
                  Positioned(
                    top: 5,
                    left: 10,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 10,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Eye patches (closed eyes)
                  Positioned(
                    top: 25,
                    left: 15,
                    child: Container(
                      width: 15,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 25,
                    right: 15,
                    child: Container(
                      width: 15,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  // Sleeping eyes (lines)
                  Positioned(
                    top: 32,
                    left: 18,
                    child: Container(
                      width: 10,
                      height: 2,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(1)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 32,
                    right: 18,
                    child: Container(
                      width: 10,
                      height: 2,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(1)),
                      ),
                    ),
                  ),
                  // Nose
                  Positioned(
                    top: 45,
                    child: Container(
                      width: 6,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Panda arms/paws
          Positioned(
            bottom: 40,
            left: 20,
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 20,
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZZZ({required double size, required int delay}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 1500 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -value * 20),
          child: Opacity(
            opacity: 1.0 - value,
            child: Text(
              'Z',
              style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        );
      },
    );
  }
}

