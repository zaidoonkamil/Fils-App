import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fils/core/%20navigation/navigation.dart';
import 'package:fils/core/widgets/appBar.dart';
import 'package:fils/core/widgets/card_counter.dart';
import 'package:fils/core/widgets/constant.dart';
import 'package:fils/core/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllar/cubit.dart';
import '../../controllar/states.dart';
import '../../core/styles/themes.dart';
import '../../model/ProfileModel.dart';

class ContectWoner extends StatelessWidget {
  const ContectWoner({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getAgents(context: context),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is DeleteAgentsSuccessState){
            showToastInfo(text: 'تمت عملية الحذف', context: context);
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
                  SizedBox(height: 20,),
                  Expanded(
                    child: ConditionalBuilder(
                        condition: cubit.agentsModel != null,
                        builder: (c){
                          return Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                    itemCount: cubit.agentsModel!.length,
                                    itemBuilder: (c,i){
                                      return Column(
                                        children: [

                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 16),
                                            margin: const EdgeInsets.symmetric(horizontal: 20,),
                                            width: double.maxFinite,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Colors.grey.withOpacity(0.5),
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
                                                    Expanded(child:
                                                    Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                           Text(cubit.agentsModel![i].name,
                                                              textAlign: TextAlign.end,
                                                              style: TextStyle(fontSize: 20,color: Colors.black),),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Expanded(
                                                              child: Text(cubit.agentsModel![i].location,
                                                                textAlign: TextAlign.end,
                                                                style: TextStyle(fontSize: 16,color: Colors.black),),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                    ),
                                                    SizedBox(width: 6,),
                                                    Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(100),
                                                            color: primaryColor.withOpacity(0.2)
                                                        ),
                                                        padding: EdgeInsets.all(10),
                                                        child: Icon(Icons.person_outline,color:primaryColor,size: 32,))
                                                  ],
                                                ),
                                                SizedBox(height: 10,),
                                                Container(
                                                  width: double.maxFinite,
                                                  height: 2,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(height: 10,),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Expanded(
                                                          child: Text(cubit.agentsModel![i].note.toString(),
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(fontSize: 18,color: Colors.black),),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8,),
                                                    GestureDetector(
                                                      onTap:()async{
                                                        final url =
                                                            'https://wa.me/+${cubit.agentsModel![i].phone}?text=';
                                                        await launch(
                                                        url,
                                                        enableJavaScript: true,
                                                        ).catchError((e) {
                                                          showToastError(
                                                            text: e.toString(),
                                                            context: context,
                                                          );
                                                        });
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 6),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(12),
                                                          color: Colors.green.withOpacity(0.2),
                                                          border: Border.all(
                                                              color: Colors.green
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text('التواصل واتس اب',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(fontSize: 18,color: Colors.green),),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                                adminOrUser =='admin'? Column(
                                                  children: [
                                                    SizedBox(height: 10,),
                                                    GestureDetector(
                                                      onTap:(){
                                                        cubit.deleteAgents(id: cubit.agentsModel![i].id.toString(), context: context);
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 6),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(12),
                                                          color: Colors.red.withOpacity(0.2),
                                                          border: Border.all(
                                                              color: Colors.red
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text('حذف الوكيل',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(fontSize: 18,color: Colors.red),),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ):Container(),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10,),

                                        ],
                                      );
                                    }),
                              ),
                              SizedBox(height: 30,),
                            ],
                          );
                        },
                        fallback: (c)=>Center(child: CircularProgressIndicator())),
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
