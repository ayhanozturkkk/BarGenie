import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';
import 'leaderboard_screen.dart';
import 'profile_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    LeaderboardScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          border: Border(
            top: BorderSide(
              color: AppColors.ghostBorder,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            _buildNavItem(Icons.local_bar_outlined, Icons.local_bar, 'ANA SAYFA', 0),
            _buildNavItem(Icons.emoji_events_outlined, Icons.emoji_events, 'LİDERLİK', 1),
            _buildNavItem(Icons.person_outline, Icons.person, 'PROFİL', 2),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, IconData activeIcon, String label, int index) {
    return BottomNavigationBarItem(
      icon: _buildIcon(icon, isSelected: false),
      activeIcon: _buildIcon(activeIcon, isSelected: true),
      label: label,
    );
  }

  Widget _buildIcon(IconData icon, {required bool isSelected}) {
    if (!isSelected) {
      return Icon(icon, size: 26);
    }
    // Gold glow effect for selected tab
    return ShaderMask(
      shaderCallback: (bounds) =>
          AppColors.goldGradient.createShader(bounds),
      child: Container(
        padding: const EdgeInsets.only(bottom: 2),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x40EBC165),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(icon, size: 28, color: Colors.white),
      ),
    );
  }
}
