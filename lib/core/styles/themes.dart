import 'package:flutter/material.dart';

// const Color primaryColor= Color(0xFFFC7405);
const Color primaryColor= Color(0xFFFA00FF);
const Color secoundColor= Color(0XFF082A5C);

class ThemeService {

  final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: primaryColor,
    fontFamily: 'Cairo',
    brightness: Brightness.light,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        showUnselectedLabels: false
    ),
    buttonTheme: const ButtonThemeData(
        colorScheme: ColorScheme.dark(),
        buttonColor: Colors.black87
    ),
    tabBarTheme: TabBarTheme(
      labelColor: Colors.black87,
      dividerColor: primaryColor,
    ),
  );
}