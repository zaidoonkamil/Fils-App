import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fils/controllar/cubit.dart';
import 'package:fils/controllar/states.dart';
import 'package:fils/core/%20navigation/navigation.dart';
import 'package:fils/core/styles/themes.dart';
import 'package:fils/view/user/send_points.dart';
import 'package:fils/view/user/store/store.dart';
import 'package:fils/view/user/subscription_market.dart';
import 'package:fils/view/user/withdraw_money.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/widgets/appBar.dart';
import 'contect_woner.dart';
import 'counter.dart';
import 'fun/fun.dart';
import 'my_subscriptions.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..getProfile(context: context)
        ..timeOfDay(context: context),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
          builder: (context,state){
          var cubit=AppCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              body: Column(
                children: [
                  Appbar(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: ConditionalBuilder(
                          condition: cubit.profileModel != null,
                          builder: (c){
                            return Column(
                              children: [
                                const SizedBox(height: 14,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                                  child: Stack(
                                    children: [
                                      cubit.time == 'night'? Center(child: Image.asset('assets/images/Rectangle 42035.png')):
                                      Center(child: Image.asset('assets/images/Rectangle 42039.png')),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 40),
                                        width: double.infinity,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Image.asset('assets/images/noto-v1_full-moon.png'),
                                                const SizedBox(width: 10,),
                                                cubit.time == 'night'? Text('مساء الخير',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),):
                                                Text('صباح الخير',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                            Text(cubit.profileModel!.name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),),
                                            Text('! ابدأ يومك بجمع المكافئات',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8,),
                                SizedBox(
                                  width: double.infinity,
                                  height: 160,
                                  child: Stack(
                                    children: [
                                      Image.asset('assets/images/Sign-in Button (3).png',fit: BoxFit.fill,width: double.maxFinite,height: 160),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                   Image.asset('assets/images/mingcute_currency-dollar-line.png',scale: 0.8,),
                                                    SizedBox(height: 10,),
                                                    Row(
                                                      children: [
                                                        Text(cubit.profileModel!.dolar.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Text('الدولار',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Image.asset('assets/images/Logo (1).png',width: 30,height: 30,),
                                                    SizedBox(height: 10,),
                                                    Text(cubit.profileModel!.sawa.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                                                    SizedBox(height: 4,),
                                                    Text('فلس',style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold),),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                   Image.asset('assets/images/streamline-flex_diamond-1.png',scale: 0.8,),
                                                    SizedBox(height: 10,),
                                                    Text(cubit.profileModel!.jewel.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                                                    SizedBox(height: 10,),
                                                    Text('الجواهر',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                  ],
                                                ),

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: (){
                                                navigateTo(context, Counter(
                                                  counter: cubit.profileModel!.userCounters,
                                                  monyOfUser: cubit.profileModel!.sawa.toString(),
                                                ));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.1),
                                                      spreadRadius: 1,
                                                      blurRadius: 5,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                        padding: EdgeInsets.all(6),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.purple.withOpacity(0.2),
                                                        ),
                                                        child: Image.asset('assets/images/counter.png',width: 40,)),
                                                    SizedBox(height: 10,),
                                                    Text('العدادات',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8,),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: (){
                                                navigateTo(context, MySubscriptions(userCounters: cubit.profileModel!.userCounters,));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.1),
                                                      spreadRadius: 1,
                                                      blurRadius: 5,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                        padding: EdgeInsets.all(6),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.yellowAccent.withOpacity(0.2),
                                                        ),
                                                        child: Image.asset('assets/images/subscription.png',width: 40,)),
                                                    SizedBox(height: 10,),
                                                    Text('اشتراكاتي',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8,),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: (){
                                                 navigateTo(context, Fun(myValue: cubit.profileModel!.jewel,));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.1),
                                                      spreadRadius: 1,
                                                      blurRadius: 5,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                        padding: EdgeInsets.all(6),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.blue.withOpacity(0.2),
                                                        ),
                                                        child: Image.asset('assets/images/theater.png',width: 40,)),
                                                    SizedBox(height: 10,),
                                                    Text('التسلية',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8,),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: (){
                                                navigateTo(context, Store());
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.1),
                                                      spreadRadius: 1,
                                                      blurRadius: 5,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                        padding: EdgeInsets.all(6),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.pink.withOpacity(0.2),
                                                        ),
                                                        child: Image.asset('assets/images/shopping.png',width: 40,)),
                                                    SizedBox(height: 10,),
                                                    Text('المتجر',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8,),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: (){
                                                navigateTo(context, WithdrawMoney());
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.1),
                                                      spreadRadius: 1,
                                                      blurRadius: 5,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                        padding: EdgeInsets.all(6),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.blue.withOpacity(0.2),
                                                        ),
                                                        child: Image.asset('assets/images/money.png',width: 40,)),
                                                    SizedBox(height: 10,),
                                                    Text('التحويلات',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8,),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: (){
                                                navigateTo(context, SubscriptionMarket());
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.1),
                                                      spreadRadius: 1,
                                                      blurRadius: 5,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                        padding: EdgeInsets.all(6),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.lightGreenAccent.withOpacity(0.2),
                                                        ),
                                                        child: Image.asset('assets/images/analytics.png',width: 40,)),
                                                    SizedBox(height: 10,),
                                                    Text('سوق',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8,),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: (){
                                                navigateTo(context, ContectWoner());
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.1),
                                                      spreadRadius: 1,
                                                      blurRadius: 5,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                        padding: EdgeInsets.all(6),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.yellowAccent.withOpacity(0.2),
                                                        ),
                                                        child: Image.asset('assets/images/customer-service (1).png',width: 40,)),
                                                    SizedBox(height: 10,),
                                                    Text('الوكلاء',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8,),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: (){
                                                navigateTo(context, SendPoints(
                                                  sawa: cubit.profileModel!.sawa.toString(),));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.1),
                                                      spreadRadius: 1,
                                                      blurRadius: 5,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                        padding: EdgeInsets.all(6),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.pink.withOpacity(0.2),
                                                        ),
                                                        child: Image.asset('assets/images/send.png',width: 40,)),
                                                    SizedBox(height: 10,),
                                                    Text('ارسال نقاط',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8,),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: (){
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      backgroundColor: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      title: Column(
                                                        children: [
                                                          Image.asset('assets/images/Group 39344.png'),
                                                          SizedBox(height: 8,),
                                                          Text("شارك هذا الكود مع اصدقائك للحصول على مكافأت",
                                                            style: TextStyle(fontSize: 16,color: Colors.black87),
                                                            textAlign: TextAlign.center,),
                                                          SizedBox(height: 20,),
                                                          Container(
                                                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(8),
                                                                color: Colors.grey.withOpacity(0.4)
                                                            ),
                                                            child: Text(
                                                              cubit.profileModel!.id.toString(),
                                                              style: TextStyle(fontSize: 20,color: Colors.black),
                                                              textAlign: TextAlign.center,),
                                                          ),
                                                        ],
                                                      ),
                                                      content: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: primaryColor,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(8),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              navigateBack(context);
                                                            },
                                                            child: Text("اغلاق",style: TextStyle(color: Colors.white),),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.1),
                                                      spreadRadius: 1,
                                                      blurRadius: 5,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                        padding: EdgeInsets.all(6),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.blue.withOpacity(0.2),
                                                        ),
                                                        child: Image.asset('assets/images/barcode.png',width: 40,)),
                                                    SizedBox(height: 10,),
                                                    Text('رمز الاحالة',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 44,),
                              ],
                            );
                          },
                          fallback: (c)=> Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height*0.4,
                              ),
                              Center(child: CircularProgressIndicator(color: primaryColor,)),
                            ],
                          )),
                    ),
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
