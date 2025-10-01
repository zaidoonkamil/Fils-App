import 'package:fils/view/user/profile.dart';
import 'package:flutter/material.dart';

import '../../view/agent/home.dart';
import '../styles/themes.dart';

class BottomNavBarAgents extends StatefulWidget {
  const BottomNavBarAgents({super.key});

  @override
  State<BottomNavBarAgents> createState() => _BottomNavBarAdminState();
}

class _BottomNavBarAdminState extends State<BottomNavBarAgents> {
  int currentIndex = 1;
  List<Widget> screens =
  [
    Profile(),
    HomeAgents(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(70),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 3,
                  offset: Offset(0, -3)
              ),
            ],
          ),
          child: BottomNavigationBar(
            selectedItemColor: primaryColor,
            backgroundColor: Colors.white,
            showUnselectedLabels: true,
            currentIndex: currentIndex,
            items: [
              BottomNavigationBarItem(
                label: "الحساب",
                icon:  currentIndex==0?Icon(Icons.person):
                Icon(Icons.person_outlined),
              ),
              BottomNavigationBarItem(
                label: "الرئيسية",
                icon:  currentIndex==1?Icon(Icons.home):
                Icon(Icons.home_outlined),
              ),
            ],
            onTap: (val) {
              setState(() {
                currentIndex = val;
              });
            },
          ),
        )
        ,
      ),
    );
  }
}