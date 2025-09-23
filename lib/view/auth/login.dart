import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fils/controllar/cubit.dart';
import 'package:fils/controllar/states.dart';
import 'package:fils/core/widgets/constant.dart';
import 'package:fils/view/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../core/navigation_bar/navigation_bar.dart';
import '../../core/navigation_bar/navigation_bar_admin.dart';
import '../../core/navigation_bar/navigation_bar_agents.dart';
import '../../core/network/local/cache_helper.dart';
import '../../core/widgets/show_toast.dart';
import 'loginCode.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController emailController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is LoginSuccessState){
            if(AppCubit.get(context).isVerified == true){
              CacheHelper.saveData(
              key: 'token',
              value: AppCubit.get(context).tokenn,
            ).then((value) {
                CacheHelper.saveData(
                key: 'id',
                value: AppCubit.get(context).idd,
              ).then((value) {
                CacheHelper.saveData(
                  key: 'role',
                  value: AppCubit.get(context).role,
                ).then((value) {
                  token = AppCubit.get(context).tokenn.toString();
                  id = AppCubit.get(context).idd.toString();
                  adminOrUser = AppCubit.get(context).role.toString();
                  if (adminOrUser == 'admin') {
                    navigateAndFinish(context, BottomNavBarAdmin());
                  }else if (adminOrUser == 'agent') {
                    navigateAndFinish(context, BottomNavBarAgents());
                  } else {
                    navigateAndFinish(context, BottomNavBar());
                  }
                });
              });
            });
            }else if(AppCubit.get(context).isVerified == false){
              navigateTo(context, LoginCode(email: emailController.text,));
            }else{
              showToastError(text: 'حدث خطأ', context: context);
            }
          }
        },
          builder: (context,state){
          var cubit=AppCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              body: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/Group 39350.png',),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: emailController,
                              hintText: 'البريد الالكتروني',
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'رجائا اخل البريد الالكتروني';
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: passwordController,
                              hintText: 'كلمة السر',
                              prefixIcon: Icons.lock,
                              obscureText: cubit.isPasswordHidden,
                              suffixIcon:  GestureDetector(
                                onTap: () {
                                  cubit.togglePasswordVisibility();
                                },
                                child: Icon(
                                    cubit.isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                                     color: primaryColor),
                              ),
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'رجائا اكتب كلمة السر';
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: codeController,
                        hintText: 'كود الاحالة (اختياري)',
                        prefixIcon: Icons.code,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 35),
                      ConditionalBuilder(
                          condition: state is !LoginLoadingState,
                          builder: (context){
                            return InkWell(
                              onTap: (){
                                if (formKey.currentState!.validate()) {
                                  if(codeController.text.trim().isEmpty){
                                    codeController.text='0';
                                  }
                                  cubit.signIn(
                                      email : emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    code: codeController.text.trim(),
                                    context: context
                                  );
                                }
                              },
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/Sign-in Button.png'),
                                ],
                              ),
                            );
                          },
                        fallback: (c)=> CircularProgressIndicator(color: primaryColor,),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              navigateTo(context, Register());
                            },
                            child: const Text(
                              'انشاء حساب ',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Text("لا تمتلك حساب ؟ "),
                        ],
                      )
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
