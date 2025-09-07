import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fils/controllar/cubit.dart';
import 'package:fils/controllar/states.dart';
import 'package:fils/core/%20navigation/navigation.dart';
import 'package:fils/core/styles/themes.dart';
import 'package:fils/core/widgets/appBar.dart';
import 'package:fils/core/widgets/constant.dart';
import 'package:fils/core/widgets/show_toast.dart';
import 'package:fils/view/user/counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getDaily(context: context, id: id)..getProfile(context: context),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=AppCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Appbar(),
                    SizedBox(height: 24,),
                    GestureDetector(
                      onTap: (){
                        navigateTo(context, Counter(
                          counter: cubit.profileModel!.userCounters,
                          monyOfUser: cubit.profileModel!.dolar.toString(),
                        ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                        margin: const EdgeInsets.symmetric(horizontal: 20,),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: primaryColor,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('متجر العدادات',style: TextStyle(fontSize: 18,color: primaryColor),),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    ConditionalBuilder(
                        condition: cubit.remainingTime != null && cubit.profileModel != null,
                        builder: (c){
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            Container(
                              width: double.maxFinite,
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: primaryColor,
                                  width: 2,
                                ),
                              ),
                              child: Container(
                                width: double.maxFinite,
                                height: 180,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 5,
                                  ),
                                ),
                                child: Container(
                                  width: double.maxFinite,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: secoundColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('متبقي',style: TextStyle(color: Colors.grey),),
                                      SizedBox(height: 10,),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 2),
                                        decoration: BoxDecoration(
                                          color: primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: primaryColor,
                                            width: 2,
                                          ),
                                        ),
                                        child: Text(cubit.remainingTime!,style: TextStyle(color: primaryColor,fontSize: 20),),
                                      ),
                                      SizedBox(height: 10,),
                                      Container(width: 80,height: 2,color: Colors.black,),
                                      SizedBox(height: 10,),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 6,vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text('المكافئات',style: TextStyle(color: Colors.grey),),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                cubit.profileModel!.totalPoints != 0? Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.blue.withOpacity(0.2),
                                      border: Border.all(
                                          color: Colors.blue
                                      )
                                  ),
                                  child: Row(
                                    children: [
                                     Text('فلس',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontSize: 14,color: Colors.blue),),
                                      Text(cubit.profileModel!.totalPoints.toString(),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontSize: 14,color: Colors.blue),),
                                    ],
                                  ),
                                ):Container(),
                                SizedBox(width: 10,),
                                cubit.profileModel!.totalGems != 0? Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.blue.withOpacity(0.2),
                                      border: Border.all(
                                          color: Colors.blue
                                      ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text('جوهرة',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontSize: 14,color: Colors.blue),),
                                      Text('${cubit.profileModel!.totalGems + 30}'.toString(),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontSize: 14,color: Colors.blue),),
                                    ],
                                  ),
                                ):
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.blue.withOpacity(0.2),
                                      border: Border.all(
                                          color: Colors.blue
                                      )
                                  ),
                                  child: Row(
                                    children: [
                                      Text('جوهرة',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontSize: 14,color: Colors.blue),),
                                      Text('30',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontSize: 14,color: Colors.blue),),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.blue.withOpacity(0.2),
                                      border: Border.all(
                                          color: Colors.blue
                                      )
                                  ),
                                  child: Row(
                                    children: [
                                      Text('بطاقة',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontSize: 14,color: Colors.blue),),
                                      Text('1',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontSize: 14,color: Colors.blue),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24,),
                            cubit.canDoAction == true? GestureDetector(
                              onTap:(){
                                cubit.sumDaly( context: context);
                              },
                              child: Image.asset('assets/images/Sign-in Button (7).png')
                            ):
                            GestureDetector(
                              onTap:(){
                                showToastError(text: ' يمكنك المحاولة مجددا بعد ${cubit.remainingTime!} ', context: context);
                              },
                              child: Image.asset('assets/images/Sign-in Button (8).png')
                            ),
                            SizedBox(height: 8,),
                            Text('يمكنك ترقية العداد لزيادة المكافأت', textAlign: TextAlign.end, style: TextStyle(fontSize: 16,color: Colors.blue),),
                            SizedBox(height: 24,),
                          ],
                        ),
                      );
                    },
                        fallback: (c)=>Center(child: CircularProgressIndicator())),
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
