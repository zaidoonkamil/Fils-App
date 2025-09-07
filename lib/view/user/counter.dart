import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fils/core/%20navigation/navigation.dart';
import 'package:fils/core/styles/themes.dart';
import 'package:fils/core/widgets/appBar.dart';
import 'package:fils/core/widgets/card_counter.dart';
import 'package:fils/view/user/contect_woner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllar/cubit.dart';
import '../../controllar/states.dart';
import '../../model/ProfileModel.dart';

class Counter extends StatelessWidget {
  const Counter({super.key, required this.counter, required this.monyOfUser});

  final List<UserCounter> counter;
  final String monyOfUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getCounter(context: context),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=AppCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  AppbarBack(),
                  SizedBox(height: 20,),
                  Expanded(
                    child: ConditionalBuilder(
                        condition: cubit.counters != null,
                        builder: (c){
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap:(){
                                        navigateTo(context, ContectWoner());
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.deepOrangeAccent.withOpacity(0.2),
                                          border: Border.all(
                                              color: Colors.deepOrangeAccent
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('الوكلاء',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 18,color: Colors.deepOrangeAccent),),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text('الترقيات المتاحة #${cubit.counters!.length}',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(fontSize: 20,color: Colors.black),),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20,),
                              Expanded(
                                child: ListView.builder(
                                    itemCount: cubit.counters!.length,
                                    itemBuilder: (c,i){
                                      var userCounters = counter.where(
                                            (userCounter) =>
                                        userCounter.counter.id.toString() ==
                                            cubit.counters![i].id.toString(),
                                      ).toList();
                                      return CardCounter(
                                        id: cubit.counters![i].id.toString(),
                                        point: cubit.counters![i].points.toString(),
                                        price: cubit.counters![i].price.toString(),
                                        type: cubit.counters![i].type.toString(),
                                        isSubscribed: userCounters.isNotEmpty,
                                        monyOfUser: monyOfUser,
                                      );
                                    }),
                              ),
                              SizedBox(height: 30,),
                            ],
                          );
                        },
                        fallback: (c)=>Center(child: CircularProgressIndicator())),
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
