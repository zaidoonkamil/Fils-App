import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fils/view/auth/re_input_pass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../controllar/cubit.dart';
import '../../controllar/states.dart';
import '../../core/widgets/constant.dart';
import '../../core/widgets/show_toast.dart';

class AddCode extends StatelessWidget {
  const AddCode({super.key, required this.email});

  final String email;
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..sendOtp(email: email, context: context),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is VerifyOtpSuccessState){
            showToastSuccess(
              text: "تم التأكد",
              context: context,
            );
            navigateAndFinish(context, ReInputPass(email: email,));
          }
        },
        builder: (context,state){
          var cubit=AppCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              body: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                navigateBack(context);
                              },
                              child: Icon(Icons.arrow_back_ios_new_rounded,size: 30,),
                            ),
                          ],
                        ),
                        SizedBox(height: 30,),
                        Image.asset('assets/images/Sign-in Button (6).png',height: 80,),
                        const SizedBox(height: 20),
                        Text(
                          nameApp,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Text(
                          'تم ارسال كود التحقق الى البريد الالكتروني الخاص بك',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        CustomTextField(
                          controller: codeController,
                          hintText: 'ادخل كود التفعيل',
                          prefixIcon: Icons.code,
                          keyboardType: TextInputType.phone,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'رجائا اخل كود التفعيل';
                            }
                          },
                        ),
                        const SizedBox(height: 60),
                        ConditionalBuilder(
                          condition: state is !VerifyOtpLoadingState,
                          builder: (context){
                            return GestureDetector(
                              onTap: (){
                                if (formKey.currentState!.validate()) {
                                  cubit.verifyOtp(
                                      email: email,
                                      code: codeController.text.trim(),
                                      context: context
                                  );
                                }
                              },
                              child: Stack(
                                children: [
                                  Image.asset('assets/images/Sign-in Button (11).png'),
                                  SizedBox(
                                    height: 46,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('التحقق',style: TextStyle(color: Colors.white,fontSize: 15),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          fallback: (c)=> CircularProgressIndicator(color: primaryColor,),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
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
