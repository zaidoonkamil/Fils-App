import 'package:fils/core/%20navigation/navigation.dart';
import 'package:fils/view/auth/register.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class FirstAuth extends StatelessWidget {
  const FirstAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:Scaffold(
      backgroundColor: Colors.white,
          body: Stack(
            children: [
              Image.asset('assets/images/Group 39349.png',width: double.maxFinite,fit: BoxFit.fill,),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){
                      navigateTo(context, Login());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/Sign-in Button.png'),
                      ],
                    ),
                  ),
                  SizedBox(height: 8,),
                  InkWell(
                    onTap: (){
                      navigateTo(context, Register());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/Sign-in Button (1).png'),
                      ],
                    ),
                  ),
                  SizedBox(height: 26,),
                ],
              ),
            ],
          ),
    ));
  }
}
