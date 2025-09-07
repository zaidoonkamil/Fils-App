import 'package:fils/core/styles/themes.dart';
import 'package:fils/core/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controllar/cubit.dart';
import '../../../controllar/states.dart';
import '../../../core/ navigation/navigation.dart';
import '../../../core/widgets/show_toast.dart';
import 'luck_wheel.dart';

class Fight extends StatelessWidget {
  const Fight({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..lastFinishedGame(context: context),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is JoinGameSuccessState){
            showToastSuccess(
              text: 'تم الدخول الى المباراة بمجرد اكتمال العدد سوف يتم ابلاغك بالنتيجة',
              context: context,
            );
          }
        },
        builder: (context,state){
          var cubit=AppCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Image.asset('assets/images/WhatsApp Image 2025-06-22 at 2.24.56 AM.png',fit: BoxFit.fill,width: double.maxFinite,height: double.maxFinite,),
                  Column(
                    children: [
                      AppbarBack(),
                      SizedBox(height: 20,),
                      GestureDetector(
                          onTap: (){
                            cubit.joinGame(context: context);
                          },
                          child: Image.asset('assets/images/Group 39354.png')),
                      cubit.lastFinishGame != null? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset('assets/images/Group 39355.png'),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 40,),
                                        Text(cubit.lastFinishGame!.players[0].name.toString(),style: TextStyle(color: Colors.white),),
                                      ],
                                    ),
                                    cubit.lastFinishGame!.winnerId != cubit.lastFinishGame!.players[0].id?
                                    Image.asset('assets/images/Group 39359.png',fit: BoxFit.fill,):Container(),                                  ],
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset('assets/images/Group 39356.png'),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 40,),
                                        Text(cubit.lastFinishGame!.players[1].name.toString(),style: TextStyle(color: Colors.white),),
                                      ],
                                    ),
                                    cubit.lastFinishGame!.winnerId != cubit.lastFinishGame!.players[1].id?
                                    Image.asset('assets/images/Group 39359.png',fit: BoxFit.fill,):Container(),                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 80,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset('assets/images/Group 39357.png'),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 40,),
                                        Text(cubit.lastFinishGame!.players[2].name.toString(),style: TextStyle(color: Colors.white),),
                                      ],
                                    ),
                                    cubit.lastFinishGame!.winnerId != cubit.lastFinishGame!.players[2].id?
                                    Image.asset('assets/images/Group 39359.png',fit: BoxFit.fill,):Container(),
                                  ],
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset('assets/images/Group 39358.png'),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 40,),
                                        Text(cubit.lastFinishGame!.players[3].name.toString(),style: TextStyle(color: Colors.white),),
                                      ],
                                    ),
                                    cubit.lastFinishGame!.winnerId != cubit.lastFinishGame!.players[3].id?
                                    Image.asset('assets/images/Group 39359.png',fit: BoxFit.fill,):Container(),                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 50,),
                          ],
                        ),
                      ):Container(),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
