import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fils/core/%20navigation/navigation.dart';
import 'package:fils/core/styles/themes.dart';
import 'package:fils/core/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllar/cubit.dart';
import '../../controllar/states.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/show_toast.dart';

class WithdrawMoney extends StatelessWidget {
  const WithdrawMoney({super.key, });

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController priceController = TextEditingController();
  static TextEditingController numbersController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is AddWithdrawMoneySuccessState){
            priceController.text='';
            numbersController.text='';
            showToastSuccess(text: 'تم ارسال طلبك وسوف يتم الرد عليك قريبا', context: context);
            navigateBack(context);
          }
        },
        builder: (context,state){
          var cubit=AppCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      AppbarBack(),
                      SizedBox(height: 40,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                        margin: const EdgeInsets.symmetric(horizontal: 20,),
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
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
                                Expanded(child: Text('علما ان عمولة السحب 0 فلس من قيمة المبلغ الاجمال واقل قيمة للسحب 6400 فلس',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: 12,color: Colors.black54),)),
                                SizedBox(width: 6,),
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.deepOrangeAccent.withOpacity(0.2)
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Icon(Icons.info_outline,color: Colors.deepOrangeAccent,size: 32,))
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: priceController,
                              hintText: 'القيمة المراد سحبها',
                              prefixIcon: Icons.price_check,
                              keyboardType: TextInputType.phone,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'رجائا اخل القيمة المراد سحبها';
                                }
                              },
                            ),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: numbersController,
                              hintText: 'رقم البطاقة او رقم الهاتف',
                              prefixIcon: Icons.numbers,
                              keyboardType: TextInputType.phone,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'رجائا اكتب رقم البطاقة او رقم الهاتف';
                                }
                              },
                            ),
                            SizedBox(height: 20,),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: ()  {
                          cubit.funTypeOfCash(1);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
                          margin: const EdgeInsets.symmetric(horizontal: 20,),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:cubit.typeOfCash == 1?
                              primaryColor.withOpacity(0.5)
                                  : Colors.grey.withOpacity(0.5) ,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: secoundColor.withOpacity(0.1),
                                spreadRadius: 4,
                                blurRadius: 5,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                      child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(' زين كاش ',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(fontSize: 14,color: Colors.black),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Text('اسحب اموالك عن طريق زين كاش',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(fontSize: 12,color: Colors.black),),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                  ),
                                  SizedBox(width: 12,),
                                  Image.asset('assets/images/unnamed 1.png',width: 70,height: 70,)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: ()  {
                          cubit.funTypeOfCash(2);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
                          margin: const EdgeInsets.symmetric(horizontal: 20,),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:cubit.typeOfCash == 2?
                                primaryColor.withOpacity(0.5):
                              Colors.grey.withOpacity(0.5),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: secoundColor.withOpacity(0.1),
                                spreadRadius: 4,
                                blurRadius: 5,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                      child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(' ماستر كارد ',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(fontSize: 14,color: Colors.black),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Text('اسحب اموالك عن طريق ماستر كارد',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(fontSize: 12,color: Colors.black),),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                  ),
                                  SizedBox(width: 12,),
                                  Image.asset('assets/images/mastercard.png',width: 70,height: 70,)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: ()  {
                          cubit.funTypeOfCash(3);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
                          margin: const EdgeInsets.symmetric(horizontal: 20,),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:cubit.typeOfCash == 3?
                                primaryColor.withOpacity(0.5):
                              Colors.grey.withOpacity(0.5),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: secoundColor.withOpacity(0.1),
                                spreadRadius: 4,
                                blurRadius: 5,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                      child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text('USDT',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(fontSize: 14,color: Colors.black),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Text('USDT اسحب اموالك عن طريق',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(fontSize: 12,color: Colors.black),),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                  ),
                                  SizedBox(width: 12,),
                                  Image.asset('assets/images/11a3582468209cea14a442d4078bf5f5 1 (1).png',width: 70,height: 70,)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 40,),
                      ConditionalBuilder(
                          condition: state is !AddWithdrawMoneyLoadingState,
                          builder: (c){
                            return GestureDetector(
                              onTap: ()  {
                                if (formKey.currentState!.validate()) {
                                  cubit.withdrawMoney(
                                      context: context,
                                      amount: priceController.text.trim(),
                                      accountNumber: numbersController.text.trim()
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                                child: Stack(
                                  children: [
                                    Image.asset('assets/images/Sign-in Button (11).png'),
                                    SizedBox(
                                      height: 46,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('سحب الاموال',style: TextStyle(color: Colors.white,fontSize: 15),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          fallback: (c)=>CircularProgressIndicator()),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
