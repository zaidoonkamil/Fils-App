import 'package:fils/core/%20navigation/navigation.dart';
import 'package:fils/core/widgets/appBar.dart';
import 'package:fils/core/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/themes.dart';
import '../../../controllar/cubit.dart';
import '../../../controllar/states.dart';

class Store extends StatelessWidget {
  const Store({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getIdShop(context: context),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is BuyIdSuccessState){
            showToastSuccess(text: 'تمت عملية الشراء بنجاح سوف يتم تسجيل الخروج لتحديث رمز الاحالة', context: context);
            navigateBack(context);
            AppCubit.get(context).logOut(context: context);
          }else if(state is BuyIdErrorState){
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
                  SizedBox(height: 10,),
                  cubit.getIdShopModel != null ?
                  cubit.getIdShopModel!.isNotEmpty?
                  Expanded(
                    child: ListView.builder(
                        itemCount: cubit.getIdShopModel!.length,
                        itemBuilder: (c,i){
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap:(){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      title: Text("هل حقا ترغب في شراء رمز الاحالة هذا ؟",
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
                                              cubit.buyId(context: context, shopId: cubit.getIdShopModel![i].id.toString(), idForSale: cubit.getIdShopModel![i].idForSale.toString());
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
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                                width: double.maxFinite,
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
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.blue.withOpacity(0.2),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.arrow_back_ios_new),
                                            Text('شراء',style: TextStyle(fontSize: 14),)
                                          ],
                                        )),
                                    Text(cubit.getIdShopModel![i].idForSale.toString(),style: TextStyle(fontSize: 22),),
                                    Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.blue.withOpacity(0.2),
                                        ),
                                        child: Text('ID',style: TextStyle(fontSize: 22),)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                          ],
                        ),
                      );
                    }),
                  ):
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('لم يتم ادراج عناصر بعد'),
                      ],
                    ),
                  ):
                  Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: primaryColor,),
                          ],
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
