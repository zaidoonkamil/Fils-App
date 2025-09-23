import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../controllar/cubit.dart';
import '../../controllar/states.dart';
import 'add_code.dart';

class ForgetPass extends StatelessWidget {
  const ForgetPass({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController codeController = TextEditingController();
  static TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
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
                        const SizedBox(height: 40),
                        Image.asset('assets/images/Sign-in Button (6).png',height: 80,),
                        const SizedBox(height: 20),
                        Text(
                          'نسيت كلمة السر ؟',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 30),
                        CustomTextField(
                          controller: emailController,
                          hintText: 'البريد الالكتروني',
                          prefixIcon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'رجائا اخل البريد الالكتروني';
                            }
                          },
                        ),
                        const SizedBox(height:40),
                        ConditionalBuilder(
                          condition: state is !VerifyOtpLoadingState,
                          builder: (context){
                            return GestureDetector(
                              onTap: (){
                                if (formKey.currentState!.validate()) {
                                  navigateTo(context, AddCode(email: emailController.text.trim()));
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
                                        Text('ارسال رمز التحقق',style: TextStyle(color: Colors.white,fontSize: 15),),
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
