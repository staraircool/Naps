import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/mining_service.dart';
import 'sleep_screen.dart';
import 'invite_screen.dart';
import 'faq_screen.dart';
import 'welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MiningService _miningService = MiningService.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Refresh the UI every second to update balance
    _startUIUpdateTimer();
  }

  void _startUIUpdateTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {});
        _startUIUpdateTimer();
      }
    });
  }

  Future<void> _navigateToSleep() async {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SleepScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < -500) {
            // Swipe up detected
            _navigateToSleep();
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF4A90E2), // Blue
                Color(0xFF2D5A87), // Darker blue
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header with menu and profile
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      // Profile section
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '@Username',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                              const Text(
                                'FULL NAME',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Menu button
                      GestureDetector(
                        onTap: () => _scaffoldKey.currentState?.openDrawer(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Balance section
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _miningService.currentBalance.toStringAsFixed(6),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'NAP TOKEN',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_miningService.miningRate.toStringAsFixed(5)} NAP/hr',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 60),
                        // Glowing orb effect
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.yellow.withOpacity(0.8),
                                Colors.yellow.withOpacity(0.4),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.7, 1.0],
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: Colors.yellow,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.yellow,
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
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
                        'SWIPE UP TO NAP',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 2,
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

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF2D1B3D),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'NAPCOIN',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24),
            // Menu items
            _buildDrawerItem(Icons.home, 'Home', () {
              Navigator.pop(context);
            }),
            _buildDrawerItem(Icons.person_add, 'Invite', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InviteScreen()),
              );
            }),
            _buildDrawerItem(Icons.account_balance_wallet, 'Withdraw', () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Withdraw feature coming soon!'),
                  backgroundColor: Colors.orange,
                ),
              );
            }, isDisabled: true),
            _buildDrawerItem(Icons.help, 'FAQ', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FAQScreen()),
              );
            }),
            const Spacer(),
            const Divider(color: Colors.white24),
            _buildDrawerItem(Icons.logout, 'Sign Out', () async {
              Navigator.pop(context);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('is_logged_in', false);
              await _miningService.stopMining();
              
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                  (route) => false,
                );
              }
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap,
      {bool isDisabled = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDisabled ? Colors.white38 : Colors.white,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDisabled ? Colors.white38 : Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: isDisabled ? null : onTap,
      enabled: !isDisabled,
    );
  }
}

