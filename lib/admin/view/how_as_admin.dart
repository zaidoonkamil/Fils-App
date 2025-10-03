import 'package:fils/view/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/constant.dart';
import '../../controllar/cubit.dart';
import '../../controllar/states.dart';
import '../../core/network/local/cache_helper.dart';

class HowAsAdmin extends StatelessWidget {
  const HowAsAdmin({super.key});

  static TextEditingController termController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getTerms(context: context),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is PostTermsSuccessState){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'تمت العملية بنجاح ✅',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context,state){
          var cubit=AppCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('تعديل سياسة الاستخدام'),
                                      content: SizedBox(
                                        width: 300,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller: termController,
                                              keyboardType: TextInputType.text,
                                              textAlign: TextAlign.right,
                                              decoration: const InputDecoration(
                                                labelText: 'سياسة الاستخدام',
                                                border: OutlineInputBorder(),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('إلغاء'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            if(termController.text.trim().isNotEmpty){
                                              cubit.postTerms(context: context, term: termController.text.trim());
                                            }
                                            navigateBack(context);
                                          },
                                          child: const Text('إضافة'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add,color: Colors.white,),
                                label: const Text('إضافة عنصر'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[600],
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              const Text(
                                textAlign: TextAlign.right,
                                'سياسة الاستخدام',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 26,),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 22),
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
                                SizedBox(height: 12,),
                                cubit.getTermsModel.isNotEmpty? Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        cubit.getTermsModel[0].description,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ):CircularProgressIndicator(),
                                SizedBox(height: 12,),
                              ],
                            ),
                          ),
                          SizedBox(height: 26,),
                        ],
                      ),
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
