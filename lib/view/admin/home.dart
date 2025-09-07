import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fils/controllar/cubit.dart';
import 'package:fils/controllar/states.dart';
import 'package:fils/core/widgets/show_toast.dart';
import 'package:fils/view/admin/withdrawals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/ navigation/navigation.dart';
import '../../core/styles/themes.dart';
import '../../core/widgets/appBar.dart';
import '../../core/widgets/custom_text_field.dart';


class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  static TextEditingController userIdController = TextEditingController();
  static TextEditingController sawaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is SendSawaSuccessState){
            sawaController.text='';
          }
        },
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 24,),
                            GestureDetector(
                              onTap: (){
                                navigateTo(context, Withdrawals());
                              },
                              child: Container(
                                width: double.infinity,
                                height: 48,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                        offset: const Offset(5, 5),
                                      ),
                                    ],
                                    borderRadius:  BorderRadius.circular(12),
                                    color: primaryColor
                                ),
                                child: Center(
                                  child: Text('السحوبات',
                                    style: TextStyle(color: Colors.white,fontSize: 18 ),),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12,),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    if(userIdController.text.isNotEmpty){
                                      cubit.getUser(context: context, id: userIdController.text.trim());
                                    }else{
                                      showToastInfo(text: 'بأدخال المعرف اولا', context: context);
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    height: 48,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                            offset: const Offset(5, 5),
                                          ),
                                        ],
                                        borderRadius:  BorderRadius.circular(12),
                                        color: primaryColor
                                    ),
                                    child: Center(
                                      child: Text('بحث',
                                        style: TextStyle(color: Colors.white,fontSize: 18 ),),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: CustomTextField(
                                    controller: userIdController,
                                    hintText: 'بحث',
                                    prefixIcon: Icons.person_outline,
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24,),
                            ConditionalBuilder(
                                condition: cubit.profileModel != null,
                                builder: (c){
                                  return Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 14),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: primaryColor,
                                            width: 1.0,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: primaryColor.withOpacity(0.2),
                                              spreadRadius: 4,
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Icon(Icons.person_outline),
                                                    SizedBox(height: 10,),
                                                    Icon(Icons.phone),
                                                    SizedBox(height: 10,),
                                                    Icon(Icons.location_on_outlined),
                                                    SizedBox(height: 10,),
                                                    Icon(Icons.person),
                                                    SizedBox(height: 10,),
                                                    Icon(Icons.currency_pound),
                                                    SizedBox(height: 10,),
                                                    Icon(Icons.grid_goldenratio),
                                                    SizedBox(height: 10,),
                                                    Icon(Icons.currency_exchange_outlined),
                                                  ],
                                                ),
                                                Spacer(),
                                                Column(
                                                  children: [
                                                    Text(cubit.profileModel!.name.toString(),style: TextStyle(fontSize: 18),),
                                                    SizedBox(height: 10,),
                                                    Text(cubit.profileModel!.phone.toString(),style: TextStyle(fontSize: 18),),
                                                    SizedBox(height: 10,),
                                                    Text(cubit.profileModel!.location.toString(),style: TextStyle(fontSize: 18),),
                                                    SizedBox(height: 10,),
                                                    Text(cubit.profileModel!.role.toString(),style: TextStyle(fontSize: 18),),
                                                    SizedBox(height: 10,),
                                                    Text(cubit.profileModel!.sawa.toString(),style: TextStyle(fontSize: 18),),
                                                    SizedBox(height: 10,),
                                                    Text(cubit.profileModel!.jewel.toString(),style: TextStyle(fontSize: 18),),
                                                    SizedBox(height: 10,),
                                                    Text(cubit.profileModel!.dolar.toString(),style: TextStyle(fontSize: 18),),
                                                  ],
                                                ),
                                                Spacer(),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(':الاسم',style: TextStyle(fontSize: 17),),
                                                    SizedBox(height: 10,),
                                                    Text(':الهاتف',style: TextStyle(fontSize: 17),),
                                                    SizedBox(height: 10,),
                                                    Text(':الموقع',style: TextStyle(fontSize: 17),),
                                                    SizedBox(height: 10,),
                                                    Text(':الصلاحياة',style: TextStyle(fontSize: 17),),
                                                    SizedBox(height: 10,),
                                                    Text(': السوا',style: TextStyle(fontSize: 17),),
                                                    SizedBox(height: 10,),
                                                    Text(': الجواهر',style: TextStyle(fontSize: 17),),
                                                    SizedBox(height: 10,),
                                                    Text(': الدينار',style: TextStyle(fontSize: 17),),
                                                  ],
                                                ),
                                              ],
                                            ),

                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      Text('ارسال الكوينز',style: TextStyle(fontSize: 18),),
                                      SizedBox(height: 20,),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              if(sawaController.text.isNotEmpty){
                                                cubit.sendSawaa(context: context, userId: cubit.profileModel!.id.toString(), amount: sawaController.text.trim());
                                              }else{
                                                showToastInfo(text: 'بأدخال قيمة اولا', context: context);
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 20),
                                              height: 48,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.2),
                                                      blurRadius: 10,
                                                      spreadRadius: 2,
                                                      offset: const Offset(5, 5),
                                                    ),
                                                  ],
                                                  borderRadius:  BorderRadius.circular(12),
                                                  color: primaryColor
                                              ),
                                              child: Center(
                                                child: Text('ارسال',
                                                  style: TextStyle(color: Colors.white,fontSize: 18 ),),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Expanded(
                                            child: CustomTextField(
                                              controller: sawaController,
                                              hintText: 'ادخل السوا',
                                              prefixIcon: Icons.currency_pound,
                                              keyboardType: TextInputType.phone,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                                fallback: (c)=>Container()),
                            ConditionalBuilder(
                                condition: cubit.profileModel != null,
                                builder: (c){
                                  return Column(
                                    children: [
                                      cubit.profileModel!.userCounters.isNotEmpty ? ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                          itemCount: cubit.profileModel!.userCounters.length,
                                          itemBuilder: (c,i){
                                        return  Container(
                                          margin: EdgeInsets.only(top: 16),
                                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 14),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: primaryColor,
                                              width: 1.0,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: primaryColor.withOpacity(0.2),
                                                spreadRadius: 4,
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(cubit.profileModel!.userCounters[i].counter.type.toString(),style: TextStyle(fontSize: 18),),
                                                  Text(' : العداد',style: TextStyle(fontSize: 18),),

                                                ],
                                              ),
                                              SizedBox(height: 6,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(cubit.profileModel!.userCounters[i].counter.points.toString(),style: TextStyle(fontSize: 18),),
                                                  Text(' : النقاط',style: TextStyle(fontSize: 18),),

                                                ],
                                              ),
                                              SizedBox(height: 6,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(cubit.profileModel!.userCounters[i].counter.price.toString(),style: TextStyle(fontSize: 18),),
                                                  Text(' : السعر',style: TextStyle(fontSize: 18),),

                                                ],
                                              ),
                                              SizedBox(height: 6,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(cubit.profileModel!.userCounters[i].remainingDays.toString(),style: TextStyle(fontSize: 18),),
                                                  Text(' : الايام المتبيقية',style: TextStyle(fontSize: 18),),

                                                ],
                                              ),
                                              SizedBox(height: 6,),

                                            ],
                                          ),
                                        );
                                      }):
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(child:
                                            Text('لم يقم هذا المستخدم بالاشتراك بأي عداد',
                                               textAlign: TextAlign.center,style: TextStyle(fontSize: 18),)),
                                          ],
                                        ),
                                      ),

                                    ],
                                  );
                                },
                                fallback: (c)=>Container()),
                            const SizedBox(height: 24,),
                          ],
                        ),
                      ),
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
