import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fils/core/widgets/appBar.dart';
import 'package:fils/view/chat/chat_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/styles/themes.dart';
import '../../../controllar/cubit.dart';
import '../../../controllar/states.dart';
import '../../../core/ navigation/navigation.dart';
import '../../../core/navigation_bar/navigation_bar.dart';
import 'fight.dart';
import 'luck_wheel.dart';

class Fun extends StatelessWidget {
  const Fun({super.key, required this.myValue});

  final int myValue;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=AppCubit.get(context);
          return WillPopScope(
            onWillPop: ()async {
              navigateAndFinish(context, BottomNavBar());
              return true;
            },
            child: SafeArea(
              child: Scaffold(
                body: Stack(
                  children: [
                    Image.asset('assets/images/fun.png',fit: BoxFit.fill,width: double.maxFinite,height: double.maxFinite,),
                    Column(
                      children: [
                        AppbarBack(),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                SizedBox(height: 30,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/fun2.png',width: 140,),

                                  ],
                                ),
                                SizedBox(height: 30,),
                                GestureDetector(
                                  onTap: (){
                                    navigateTo(context, Fight());
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/Group 39351.png'),

                                    ],
                                  ),
                                ),
                                SizedBox(height: 20,),
                                GestureDetector(
                                  onTap: (){
                                    navigateTo(context, ChatMainScreen());
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/Group 39352.png'),

                                    ],
                                  ),
                                ),
                                SizedBox(height: 30,),
                                GestureDetector(
                                  onTap: (){
                                    navigateTo(context, LuckWheelPage(myValue: myValue));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/Group 39353.png'),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
