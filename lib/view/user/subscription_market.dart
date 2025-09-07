import 'package:fils/core/%20navigation/navigation.dart';
import 'package:fils/core/navigation_bar/navigation_bar.dart';
import 'package:fils/core/widgets/appBar.dart';
import 'package:fils/core/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/styles/themes.dart';
import '../../controllar/cubit.dart';
import '../../controllar/states.dart';
import '../../core/widgets/show_toast.dart';
import '../../model/ProfileModel.dart';

class SubscriptionMarket extends StatelessWidget {
  const SubscriptionMarket({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getSubscriptionMarket(context: context),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is AddCounterBuySuccessState){
            navigateBack(context);
            navigateAndFinish(context, BottomNavBar());
            showToastSuccess(
              text: 'تمت عملية شراء العداد',
              context: context,);
          }
        },
        builder: (context,state){
          var cubit=AppCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  AppbarBack(),
                  Expanded(
                    child: ListView.builder(
                        itemCount: cubit.subscriptionMarketList.length,
                        itemBuilder: (context,index){
                          DateTime dateTime = DateTime.parse(cubit.subscriptionMarketList[index].createdAt.toString());
                          String formattedDate = DateFormat('yyyy/M/d').format(dateTime);
                          return Column(
                            children: [
                              SizedBox(height: 12,),
                              GestureDetector(
                                onTap:(){
                                  if(cubit.subscriptionMarketList[index].userId.toString() == id){
                                    showToastInfo(text: 'انت بالفعل صاحب هذا الاشتراك', context: context);
                                  }else{
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          title: Text("هل حقا ترغب في الشراء ؟",
                                            style: TextStyle(fontSize: 18),
                                            textAlign: TextAlign.center,),
                                          content: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("إلغاء",style: TextStyle(color: primaryColor),),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  cubit.addCounterBuy(
                                                      context: context,
                                                      saleId: cubit.subscriptionMarketList[index].id.toString(),
                                                      buyerId: id
                                                  );
                                                },
                                                child: Text("نعم",style: TextStyle(color: Colors.white),),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );

                                  }
                                },
                                child: Container(
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
                                            child: Row(
                                              children: [
                                                Text(
                                                  'id:',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: secoundColor,
                                                  ),
                                                ),

                                                Text(
                                                  cubit.subscriptionMarketList[index].user.id.toString(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: secoundColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              cubit.subscriptionMarketList[index].user.name,
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
                                      SizedBox(height: 6,),
                                      Container(width: double.maxFinite,height: 2,color: Colors.grey,),
                                      SizedBox(height: 6,),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                cubit.subscriptionMarketList[index].userCounter.type =="points"?
                                                Text(
                                                  'كوينز',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: secoundColor,
                                                  ),
                                                ): Text(
                                                  'جوهرة',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: secoundColor,
                                                  ),
                                                ),

                                                Text(
                                                  cubit.subscriptionMarketList[index].pointsAfterCut.toString(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: secoundColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              ' : عداد',
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
                                      SizedBox(height: 6,),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  'كوينز ',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: secoundColor,
                                                  ),
                                                ),

                                                Text(
                                                  cubit.subscriptionMarketList[index].price.toString(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: secoundColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              ' : السعر',
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
                                      SizedBox(height: 6,),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text('يوم ',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: secoundColor,
                                                  ),
                                                ),
                                                Text(
                                                cubit.subscriptionMarketList[index].remainingDays.toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: secoundColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              ': عدد الايام المتبقية',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
