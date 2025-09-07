import 'package:fils/view/user/profile.dart';
import 'package:flutter/material.dart';

import '../../view/admin/Detail.dart';
import '../../view/admin/home.dart';
import '../styles/themes.dart';

class BottomNavBarAdmin extends StatefulWidget {
  const BottomNavBarAdmin({super.key});

  @override
  State<BottomNavBarAdmin> createState() => _BottomNavBarAdminState();
}

class _BottomNavBarAdminState extends State<BottomNavBarAdmin> {
  int currentIndex = 2;
  List<Widget> screens =
  [
    Profile(),
    Detail(),
    HomeAdmin(),
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
                label: "الاعدادات",
                icon:  currentIndex==1?Image.asset('assets/images/material-symbols_timer-rounded.png'):
                Image.asset('assets/images/ic_outline-timer.png'),
              ),
              BottomNavigationBarItem(
                label: "الرئيسية",
                icon:  currentIndex==2?Image.asset('assets/images/si_home-fill.png'):
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