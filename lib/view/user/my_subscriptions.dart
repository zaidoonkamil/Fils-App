import 'package:fils/core/%20navigation/navigation.dart';
import 'package:fils/core/navigation_bar/navigation_bar.dart';
import 'package:fils/core/widgets/appBar.dart';
import 'package:fils/core/widgets/constant.dart';
import 'package:fils/core/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/styles/themes.dart';
import '../../controllar/cubit.dart';
import '../../controllar/states.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../model/ProfileModel.dart';

class MySubscriptions extends StatelessWidget {
  const MySubscriptions({super.key, required this.userCounters});

  final List<UserCounter> userCounters;
  static TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is DeleteCounterSuccessState){
            showToastSuccess(
              text: 'تمت عملية حذفه من متجر العدادات',
              context: context,);
            navigateAndFinish(context, BottomNavBar());
          }
          if(state is AddCounterSuccessState){
            showToastSuccess(
              text: 'تمت عملية اضافة العداد الى المتجر',
              context: context,);
            priceController.text='';
            navigateAndFinish(context, BottomNavBar());
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
                        itemCount: userCounters.length,
                        itemBuilder: (context,index){
                          DateTime dateTime = DateTime.parse(userCounters[index].createdAt.toString());
                          String formattedDate = DateFormat('yyyy/M/d').format(dateTime);
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
                                          child: Row(
                                            children: [
                                              Text(
                                                'نقطة',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: secoundColor,
                                                ),
                                              ),

                                              Text(
                                                userCounters[index].counter.points.toString(),
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
                                                'د.ع ',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: secoundColor,
                                                ),
                                              ),

                                              Text(
                                                userCounters[index].counter.price.toString(),
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
                                          child: Text(
                                            formattedDate,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: secoundColor,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            ': تاريخ بداية الاشتراك',
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
                                    SizedBox(height: 6,),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            userCounters[index].remainingDays.toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: secoundColor,
                                            ),
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
                                    SizedBox(height: 12,),
                                    userCounters[index].isForSale == true?
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
                                              title: Text("هل حقا ترغب في الحذف ؟",
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
                                                      cubit.deleteCounterSell(context: context,
                                                          idCountersSall: userCounters[index].counterSales.first.id.toString(),
                                                          userId: id);
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
                                        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 12),
                                        decoration: BoxDecoration(
                                          color: secoundColor,
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: secoundColor.withOpacity(0.5),
                                              spreadRadius: 4,
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('حذف من المتجر',style: TextStyle(fontSize: 16,color: Colors.white),),
                                          ],
                                        ),
                                      ),
                                    ):Container(),
                                    userCounters[index].isForSale != true?
                                    Column(
                                      children: [
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
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text("ادخل سعر العداد",
                                                        style: TextStyle(fontSize: 18),
                                                        textAlign: TextAlign.center,),
                                                      SizedBox(height: 12,),
                                                      CustomTextField(
                                                        controller: priceController,
                                                        hintText: 'سعر العداد',
                                                        prefixIcon: Icons.price_check,
                                                        keyboardType: TextInputType.phone,
                                                      ),
                                                      SizedBox(height: 12,),
                                                      Row(
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
                                                              if(priceController.text.trim() != ''){
                                                                cubit.addCounterSell(context: context,
                                                                    userCounterId: userCounters[index].id.toString(),
                                                                    price: priceController.text.trim());
                                                              }else{
                                                                showToastInfo(
                                                                  text: 'رجائا قم بملئ الحقول اولا',
                                                                  context: context,);
                                                              }

                                                            },
                                                            child: Text("حفظ",style: TextStyle(color: Colors.white),),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 12),
                                            decoration: BoxDecoration(
                                              color: secoundColor,
                                              borderRadius: BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: secoundColor.withOpacity(0.5),
                                                  spreadRadius: 4,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('عرض العداد للبيع',style: TextStyle(fontSize: 16,color: Colors.white),),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 14,),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 16),
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.deepOrangeAccent.withOpacity(0.5),
                                              width: 2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: secoundColor.withOpacity(0.1),
                                                spreadRadius: 4,
                                                blurRadius: 5,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Expanded(child: Text('بعرض العداد للبيع سوف يتم خصم 10 بالمية من قيمة العداد',
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(fontSize: 16,color: Colors.black54),)),
                                                  SizedBox(width: 6,),
                                                  Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8),
                                                          color: Colors.deepOrangeAccent.withOpacity(0.2)
                                                      ),
                                                      padding: EdgeInsets.all(10),
                                                      child: Icon(Icons.info_outline,color: Colors.deepOrangeAccent,size: 32,))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ):Container(),
                                  ],
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
