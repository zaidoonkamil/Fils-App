import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fils/core/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/styles/themes.dart';
import '../../controllar/cubit.dart';
import '../../controllar/states.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getNotification(page: '1', role: 'user',context: context),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=AppCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  AppbarBack(),
                  Expanded(
                    child: ConditionalBuilder(
                        condition: state is !GetAllNotificationLoadingState,
                        builder: (c){
                      return ConditionalBuilder(
                          condition: cubit.allNotification.isNotEmpty,
                          builder: (c){
                            return  ListView.builder(
                                itemCount: cubit.allNotification.length,
                                itemBuilder: (context,index){
                                  DateTime dateTime = DateTime.parse(cubit.allNotification[index].createdAt.toString());
                                  String formattedDate = DateFormat('yyyy/M/d').format(dateTime);
                                  if (index == cubit.allNotification.length - 1 && !cubit.isLastPage) {
                                    cubit.getNotification(page: (cubit.currentPage + 1).toString(),role: 'user',context: context);
                                  }
                                  return Column(
                                    children: [
                                      SizedBox(height: 12,),
                                      Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                                        margin: const EdgeInsets.symmetric(horizontal: 20),
                                        width: double.maxFinite,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 4,
                                              spreadRadius: 1,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    cubit.allNotification[index].title,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 4,),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    cubit.allNotification[index].message,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black54,
                                                    ),
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 6,),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    formattedDate,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: secoundColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          fallback: (c)=>Center(child: Text('لا يوجد بيانات ليتم عرضها')));
                    },
                        fallback: (c)=>Center(child: CircularProgressIndicator()))
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
