import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fils/core/%20navigation/navigation.dart';
import 'package:fils/core/widgets/appBar.dart';
import 'package:fils/core/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/themes.dart';
import '../../controllar/cubit.dart';
import '../../controllar/states.dart';

class Withdrawals extends StatelessWidget {
  const Withdrawals({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..getWithdrawalRequest(context: context),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is DeleteWithdrawalRequestSuccessState){
            showToastSuccess(text: 'تمت العملية بنجاح', context: context,);
            navigateBack(context);
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
                      child: ConditionalBuilder(
                          condition: state is !GetWithdrawalRequestLoadingState,
                          builder: (c){
                            return ConditionalBuilder(
                                condition: cubit.withdrawalRequestModel != null,
                                builder: (c){
                                  return Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                            itemCount: cubit.withdrawalRequestModel!.requests.length,
                                            itemBuilder: (c,i){
                                              return Column(
                                                children: [
                                                  SizedBox(height: 8,),
                                                  Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 20,),
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
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(cubit.withdrawalRequestModel!.requests[i].user.id.toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                                                            Text(': رمز الاحالة',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 6,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(cubit.withdrawalRequestModel!.requests[i].user.name,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                                                            Text(': الاسم',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 6,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(cubit.withdrawalRequestModel!.requests[i].user.phone,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                                                            Text(': رقم الهاتف',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 6,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              '${cubit.withdrawalRequestModel!.requests[i].amount}',
                                                              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                                                            Text(': المبلغ المراد سحبه',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 6,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(cubit.withdrawalRequestModel!.requests[i].method,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                                                            Text(': الطريقة',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 6,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(cubit.withdrawalRequestModel!.requests[i].accountNumber,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                                                            Text(': رقم الحساب',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20,),
                                                        GestureDetector(
                                                          onTap: (){
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  backgroundColor: Colors.white,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(8),
                                                                  ),
                                                                  title: Text("هل حقا ترغب في الاتمام ؟",
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
                                                                          cubit.deleteWithdrawalRequest(context: context,
                                                                              id: cubit.withdrawalRequestModel!.requests[i].id.toString());
                                                                        },
                                                                        child: Text("نعم",style: TextStyle(color: Colors.white),),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            );
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
                                                              child: Text('اتمام',
                                                                style: TextStyle(color: Colors.white,fontSize: 18 ),),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                      ),
                                      SizedBox(height: 30,),
                                    ],
                                  );
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
