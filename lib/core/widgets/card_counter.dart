import 'package:fils/core/%20navigation/navigation.dart';
import 'package:fils/core/navigation_bar/navigation_bar.dart';
import 'package:fils/core/widgets/constant.dart';
import 'package:fils/core/widgets/show_toast.dart';
import 'package:fils/view/user/contect_woner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllar/cubit.dart';
import '../../controllar/states.dart';
import '../styles/themes.dart';

class CardCounter extends StatelessWidget {
  const CardCounter({super.key, required this.point, required this.price, required this.type, required this.isSubscribed, required this.id, required this.monyOfUser,});

  final String id;
  final String monyOfUser;
  final String point;
  final String price;
  final String type;
  final bool isSubscribed;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is AssignCounterSuccessState){
            showToastInfo(text: 'تمت عملية الشراء بنجاح', context: context);
            navigateAndFinish(context, BottomNavBar());
          }
          if(state is DeleteCounterSuccessState){
            showToastInfo(text: 'تمت عملية الحذف بنجاح', context: context);
            navigateBack(context);
          }

        },
        builder: (context,state){
          var cubit=AppCubit.get(context);
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
                                type !='gems'? Text(' عداد $point كوينز ',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: 20,color: Colors.black),):Text(' عداد $point جوهرة ',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: 20,color: Colors.black),),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text('💰💰 العداد يوفر ارباح كل يوم',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 16,color: Colors.black),),
                                ),
                              ],
                            ),
                          ],
                        )),
                        SizedBox(width: 6,),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.blue.withOpacity(0.2)
                            ),
                            padding: EdgeInsets.all(20),
                            child: Icon(Icons.compare_arrows_rounded,color: Colors.blue,size: 32,))
                      ],
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: double.maxFinite,
                      height: 2,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.blue.withOpacity(0.2),
                              border: Border.all(
                                  color: Colors.blue
                              )
                          ),
                          child: Row(
                            children: [
                              type !='gems'? Text('كوينز',
                                textAlign: TextAlign.end,
                                style: TextStyle(fontSize: 18,color: Colors.blue),):Text('جوهرة',
                                textAlign: TextAlign.end,
                                style: TextStyle(fontSize: 18,color: Colors.blue),),
                              Text(point,
                                textAlign: TextAlign.end,
                                style: TextStyle(fontSize: 18,color: Colors.blue),),
                            ],
                          ),
                        ),
                        Text('  : يضيف',
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 18,color: Colors.black),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       adminOrUser =="admin"?Container(): GestureDetector(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  title: Text("هل حقا ترغب في الشراء ؟",
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
                                          int pricee = int.parse(price);
                                          int monyOfUserr = int.parse(monyOfUser);
                                          if(pricee >monyOfUserr ){
                                            showToastInfo(text: 'السوا غير كافي لشراء العداد', context: context);
                                            navigateBack(context);
                                          }else{
                                            cubit.assignCounter(counterId: id, context: context);
                                          }
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
                                Text('شراء',style: TextStyle(fontSize: 16,color: Colors.white),),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('  : السعر',
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 18,color: Colors.black),),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.blue.withOpacity(0.2),
                                border: Border.all(
                                    color: Colors.blue
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text('كوينز',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 18,color: Colors.blue),),
                                  SizedBox(width: 2,),
                                  Text(price,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 18,color: Colors.blue),),
                                ],
                              ),
                            ),

                          ],
                        ),

                      ],
                    ),
                    SizedBox(height: 10,),
                    adminOrUser =="admin"? GestureDetector(
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
                                      cubit.deleteCounter(context: context, id: id);
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
                            Text('حذف',style: TextStyle(fontSize: 16,color: Colors.white),),
                          ],
                        ),
                      ),
                    ):Container(),
                  ],
                ),
              ),
              SizedBox(height: 20,),
            ],
          );
        },
      ),
    );
  }
}
