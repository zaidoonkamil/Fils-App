import 'package:fils/core/navigation_bar/navigation_bar.dart';
import 'package:fils/core/widgets/appBar.dart';
import 'package:fils/core/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../controllar/cubit.dart';
import '../../controllar/states.dart';

class SendPoints extends StatelessWidget {
  const SendPoints({super.key, required this.sawa});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController codeController = TextEditingController();
  static TextEditingController pointController = TextEditingController();
  final String sawa;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is SendMonySuccessState){
            codeController.text='';
            pointController.text='';
            showToastSuccess(
              text:  "تمت العلية بنجاح",
              context: context,
            );
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: Text('نحن بصدد تحيث هذه الصفحة')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Expanded(
                  //   child: SingleChildScrollView(
                  //       physics: AlwaysScrollableScrollPhysics(),
                  //       child: Form(
                  //         key: formKey,
                  //         child: Column(
                  //           children: [
                  //             SizedBox(height: 30,),
                  //             Container(
                  //                 padding: EdgeInsets.symmetric(horizontal: 20),
                  //                 child: Stack(
                  //                   children: [
                  //                     Image.asset('assets/images/Group 1171275635.png'),
                  //                     SizedBox(
                  //                       height: 150,
                  //                       child: Column(
                  //                         crossAxisAlignment: CrossAxisAlignment.center,
                  //                         mainAxisAlignment: MainAxisAlignment.center,
                  //                         children: [
                  //                           Row(
                  //                             mainAxisAlignment: MainAxisAlignment.center,
                  //                             children: [
                  //                               Text('رصيدك الحالي',style: TextStyle(color: Colors.grey,fontSize: 18),),
                  //                             ],
                  //                           ),
                  //                           Row(
                  //                             mainAxisAlignment: MainAxisAlignment.center,
                  //                             children: [
                  //                               Text('كوينز ',style: TextStyle(color: Colors.white,fontSize: 20),),
                  //                               Text(sawa,style: TextStyle(color: Colors.white,fontSize: 20),),
                  //                               Image.asset('assets/images/logo.png',width: 40,height: 40,),
                  //                             ],
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //             ),
                  //             SizedBox(height: 30,),
                  //             Container(
                  //               padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 16),
                  //               margin: const EdgeInsets.symmetric(horizontal: 20,),
                  //               width: double.maxFinite,
                  //               decoration: BoxDecoration(
                  //                 color: Colors.white,
                  //                 borderRadius: BorderRadius.circular(12),
                  //                 border: Border.all(
                  //                   color: Colors.blue.withOpacity(0.5),
                  //                   width: 2,
                  //                 ),
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                     color: secoundColor.withOpacity(0.1),
                  //                     spreadRadius: 4,
                  //                     blurRadius: 5,
                  //                     offset: const Offset(0, 3),
                  //                   ),
                  //                 ],
                  //               ),
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.end,
                  //                 children: [
                  //                   Row(
                  //                     mainAxisAlignment: MainAxisAlignment.end,
                  //                     children: [
                  //                       Expanded(child: Text('يمكنك ارسال الكوينز الى صديقك عن طريق كود الدعوة ',
                  //                         textAlign: TextAlign.end,
                  //                         style: TextStyle(fontSize: 16,color: Colors.black54),)),
                  //                       SizedBox(width: 6,),
                  //                       Container(
                  //                         decoration: BoxDecoration(
                  //                           borderRadius: BorderRadius.circular(8),
                  //                           color: Colors.blue.withOpacity(0.2)
                  //                         ),
                  //                           padding: EdgeInsets.all(10),
                  //                           child: Icon(Icons.info_outline,color: Colors.blue,size: 32,))
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             SizedBox(height: 30,),
                  //             Padding(
                  //               padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  //               child: Column(
                  //                 children: [
                  //                   CustomTextField(
                  //                     controller: codeController,
                  //                     hintText: 'كود الاحالة',
                  //                     prefixIcon: Icons.code,
                  //                     keyboardType: TextInputType.text,
                  //                     validate: (String? value) {
                  //                       if (value!.isEmpty) {
                  //                         return 'رجائا اخل كود الاحالة';
                  //                       }
                  //                     },
                  //                   ),
                  //                   const SizedBox(height: 16),
                  //                   CustomTextField(
                  //                     controller: pointController,
                  //                     hintText: 'عدد النقاط',
                  //                     prefixIcon: Icons.currency_bitcoin,
                  //                     validate: (String? value) {
                  //                       if (value!.isEmpty) {
                  //                         return 'رجائا اكتب عدد النقاط';
                  //                       }
                  //                     },
                  //                   ),
                  //                   SizedBox(height: 30,),
                  //                   ConditionalBuilder(
                  //                     condition: state is !SendMonyLoadingState,
                  //                     builder: (context){
                  //                       return GestureDetector(
                  //                         onTap: (){
                  //                           if (formKey.currentState!.validate()) {
                  //                                cubit.sendMony(
                  //                           receiverId: codeController.text.trim(),
                  //                           amount: pointController.text.trim(),
                  //                           context: context
                  //                         );
                  //                           }
                  //                         },
                  //                         child: Container(
                  //                           width: double.infinity,
                  //                           height: 48,
                  //                           decoration: BoxDecoration(
                  //                               boxShadow: [
                  //                                 BoxShadow(
                  //                                   color: Colors.black.withOpacity(0.2),
                  //                                   blurRadius: 10,
                  //                                   spreadRadius: 2,
                  //                                   offset: const Offset(5, 5),
                  //                                 ),
                  //                               ],
                  //                               borderRadius:  BorderRadius.circular(12),
                  //                               color: secoundColor
                  //                           ),
                  //                           child: Center(
                  //                             child: Text('ارسال النقاط',
                  //                               style: TextStyle(color: Colors.white,fontSize: 18 ),),
                  //                           ),
                  //                         ),
                  //                       );
                  //                     },
                  //                     fallback: (c)=> CircularProgressIndicator(color: primaryColor,),
                  //                   ),
                  //
                  //                 ],
                  //               ),
                  //             ),
                  //             SizedBox(height: 20,),
                  //             Container(
                  //               padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 16),
                  //               margin: const EdgeInsets.symmetric(horizontal: 20,),
                  //               width: double.maxFinite,
                  //               decoration: BoxDecoration(
                  //                 color: Colors.white,
                  //                 borderRadius: BorderRadius.circular(12),
                  //                 border: Border.all(
                  //                   color: Colors.deepOrangeAccent.withOpacity(0.5),
                  //                   width: 2,
                  //                 ),
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                     color: secoundColor.withOpacity(0.1),
                  //                     spreadRadius: 4,
                  //                     blurRadius: 5,
                  //                     offset: const Offset(0, 3),
                  //                   ),
                  //                 ],
                  //               ),
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.end,
                  //                 children: [
                  //                   Row(
                  //                     mainAxisAlignment: MainAxisAlignment.end,
                  //                     children: [
                  //                       Expanded(child: Text('علما ان عمولة الارسال %10 \n وحد التحويل اليومي 500 كوينز ',
                  //                         textAlign: TextAlign.end,
                  //                         style: TextStyle(fontSize: 16,color: Colors.black54),)),
                  //                       SizedBox(width: 6,),
                  //                       Container(
                  //                           decoration: BoxDecoration(
                  //                               borderRadius: BorderRadius.circular(8),
                  //                               color: Colors.deepOrangeAccent.withOpacity(0.2)
                  //                           ),
                  //                           padding: EdgeInsets.all(10),
                  //                           child: Icon(Icons.info_outline,color: Colors.deepOrangeAccent,size: 32,))
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             SizedBox(height: 30,),
                  //           ],
                  //         ),
                  //       )
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
