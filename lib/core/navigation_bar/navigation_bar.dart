import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:ionicons/ionicons.dart';

import '../../view/user/home.dart';
import '../../view/user/profile.dart';
import '../../view/user/timer.dart';
import '../styles/themes.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 2;

  final List<Widget> screens = [
    Profile(),
    TimerScreen(),
    Home(),
  ];

  final List<IconData> iconList = [
    Ionicons.person,
    Ionicons.timer,
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),

        backgroundColor: primaryColor,
        child: Image.asset('assets/images/streamline-plump_home-1-solid.png'),
        onPressed: () {
          setState(() {
            currentIndex = 2;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: currentIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        activeColor: Colors.white,
        inactiveColor: Colors.white,
        backgroundColor: secoundColor,
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}
