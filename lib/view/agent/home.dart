import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fils/controllar/cubit.dart';
import 'package:fils/controllar/states.dart';
import 'package:fils/core/styles/themes.dart';
import 'package:fils/core/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/widgets/appBar.dart';
import '../../core/widgets/custom_text_field.dart';


class HomeAgents extends StatelessWidget {
  const HomeAgents({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController codeController = TextEditingController();
  static TextEditingController pointController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..getProfile(context: context),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is SendMonySuccessState ){
            codeController.text='';
            pointController.text='';
            showToastSuccess(text: 'تمت عملية التحويل بنجاح', context: context);
          }
        },
          builder: (context,state){
          var cubit=AppCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              body: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: ConditionalBuilder(
                    condition: cubit.profileModel != null,
                    builder: (c){
                      return Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Appbar(),
                            Column(
                              children: [
                                SizedBox(height: 30,),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          height: 150,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('رصيدك الحالي',style: TextStyle(color: Colors.grey,fontSize: 18),),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('كوينز ',style: TextStyle(fontSize: 20),),
                                                  Text(cubit.profileModel!.sawa.toString(),style: TextStyle(fontSize: 20),),
                                                  Image.asset('assets/images/Sign-in Button (6).png',width: 40,height: 40,),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                ),
                                SizedBox(height: 30,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Column(
                                    children: [
                                      CustomTextField(
                                        controller: codeController,
                                        hintText: 'كود الاحالة',
                                        prefixIcon: Icons.code,
                                        keyboardType: TextInputType.text,
                                        validate: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'رجائا اخل كود الاحالة';
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      CustomTextField(
                                        controller: pointController,
                                        hintText: 'عدد النقاط',
                                        prefixIcon: Icons.currency_bitcoin,
                                        validate: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'رجائا اكتب عدد النقاط';
                                          }
                                        },
                                      ),
                                      SizedBox(height: 30,),
                                      ConditionalBuilder(
                                        condition: state is !SendMonyLoadingState,
                                        builder: (context){
                                          return GestureDetector(
                                            onTap: (){
                                              if (formKey.currentState!.validate()) {
                                                   cubit.sendMonyAgents(
                                              receiverId: codeController.text.trim(),
                                              amount: pointController.text.trim(),
                                              context: context
                                            );
                                              }
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
                                                  color: secoundColor
                                              ),
                                              child: Center(
                                                child: Text('ارسال النقاط',
                                                  style: TextStyle(color: Colors.white,fontSize: 18 ),),
                                              ),
                                            ),
                                          );
                                        },
                                        fallback: (c)=> CircularProgressIndicator(color: primaryColor,),
                                      ),

                                    ],
                                  ),
                                ),
                                SizedBox(height: 30,),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    fallback: (c)=> Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.4,
                        ),
                        Center(child: CircularProgressIndicator()),
                      ],
                    )),
              ),
            ),
          );
          },
      ),
    );
  }
}
