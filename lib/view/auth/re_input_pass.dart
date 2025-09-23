import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../controllar/cubit.dart';
import '../../controllar/states.dart';
import '../../core/widgets/show_toast.dart';
import 'login.dart';

class ReInputPass extends StatelessWidget {
  const ReInputPass({super.key, required this.email});

  final String email;
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController passwordController = TextEditingController();
  static TextEditingController rePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is ResetPasswordLoadingState){
            showToastSuccess(
              text: "تم تغيير كلمة المرور",
              context: context,
            );
            navigateAndFinish(context, Login());
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
                        SizedBox(height: 20,),
                        Image.asset('assets/images/Sign-in Button (6).png',height: 80,),
                        const SizedBox(height: 20),
                        Text(
                          'اكتب كلمة المرور الجديدة',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 40),
                        CustomTextField(
                          controller: passwordController,
                          hintText: 'كلمة السر',
                          prefixIcon: Icons.lock_outline,
                          obscureText: true,
                          // suffixIcon: const Icon(Icons.visibility_off, color: Colors.grey),
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'رجائا اكتب كلمة السر';
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: rePasswordController,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'رجائا اعد كتابة كلمة السر';
                            }
                          },
                          hintText: 'اعد كتابة كلمة السر',
                          prefixIcon: Icons.lock_outline,
                          obscureText: true,
                        ),
                        const SizedBox(height: 60),
                        ConditionalBuilder(
                          condition: state is !VerifyOtpLoadingState,
                          builder: (context){
                            return GestureDetector(
                              onTap: (){
                                if (formKey.currentState!.validate()) {
                                  if(passwordController.text == rePasswordController.text){
                                    cubit.resetPassword(
                                        email: email,
                                        context: context,
                                        newPassword: passwordController.text.trim()
                                    );
                                  }else{
                                    print(rePasswordController.text);
                                    print(passwordController.text);
                                    showToastError(
                                      text: "كلمة السر غير متطابقة",
                                      context: context,
                                    );
                                  }
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
                                        Text('تأكيد',style: TextStyle(color: Colors.white,fontSize: 15),),
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
