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
                icon:  currentIndex==0?Image.asset('assets/images/fluent_person-16-filled (1).png'):
                Image.asset('assets/images/fluent_person-16-regular (1).png'),
              ),
              BottomNavigationBarItem(
                label: "الرئيسية",
                icon:  currentIndex==1?Image.asset('assets/images/si_home-fill.png'):
                Image.asset('assets/images/si_home-line.png'),
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