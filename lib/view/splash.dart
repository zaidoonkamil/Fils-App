import 'package:fils/view/auth/first_auth.dart';
import 'package:flutter/material.dart';

import '../../core/ navigation/navigation.dart';
import '../core/navigation_bar/navigation_bar.dart';
import '../core/navigation_bar/navigation_bar_agents.dart';
import '../core/network/local/cache_helper.dart';
import '../core/widgets/constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      Widget? widget;
      if(CacheHelper.getData(key: 'token') == null){
        token='';
        widget = const FirstAuth();
      }else{
        if(CacheHelper.getData(key: 'role') == null){
          widget = const FirstAuth();
          adminOrUser='user';
        }else{
          adminOrUser = CacheHelper.getData(key: 'role');
          if (adminOrUser == 'admin') {
        //    widget = BottomNavBarAdmin();
          } else if (adminOrUser == 'agent') {
            widget = BottomNavBarAgents();
          }else {
            widget = BottomNavBar();
          }
        }
        token = CacheHelper.getData(key: 'token') ;
        id = CacheHelper.getData(key: 'id') ??'' ;
      }
      navigateAndFinish(context, widget!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0XFF2743FD),
                Color(0XFF9D20FF),
                Color(0XFFF56FF8),
                Color(0XFFF56FF8),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.5),
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeOutBack,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: child,
                        );
                      },
                      child: Image.asset('assets/images/Logo (1).png',),
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}