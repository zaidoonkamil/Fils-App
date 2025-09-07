import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fils/core/%20navigation/navigation.dart';
import 'package:fils/view/user/contect_woner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/themes.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/show_toast.dart';
import '../../controllar/cubit.dart';
import '../../controllar/states.dart';
import '../../core/widgets/appBar.dart';
import '../../core/widgets/card_counter.dart';


class Detail extends StatelessWidget {
  const Detail({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController userNameController = TextEditingController();
  static TextEditingController emailController = TextEditingController();
  static TextEditingController phoneController = TextEditingController();
  static TextEditingController locationController = TextEditingController();
  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  static TextEditingController priceController = TextEditingController();
  static TextEditingController pointsController = TextEditingController();
  static TextEditingController typeController = TextEditingController();
  static List<String> role=['points','gems',];
  static GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  static TextEditingController tittleController = TextEditingController();
  static TextEditingController massegeController = TextEditingController();
  static TextEditingController rolController = TextEditingController();
  static List<String> rol=['user','admin',];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..getCounter(context: context),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is AssignAgentsSuccessState){
            userNameController.text='';
            emailController.text='';
            phoneController.text='';
            locationController.text='';
            descriptionController.text='';
            passwordController.text='';
            showToastSuccess(
              text: "تمت عملية الاضافة بنجاح",
              context: context,
            );
          }
          if(state is AssignCountersSuccessState){
            pointsController.text='';
            priceController.text='';
            typeController.text='';
            showToastSuccess(
              text: "تمت عملية الاضافة بنجاح",
              context: context,
            );
          }
          if(state is AddNotificationSuccessState){
            tittleController.text='';
            massegeController.text='';
            rolController.text='';
            showToastSuccess(
              text: "تمت عملية الاضافة بنجاح",
              context: context,
            );
          }

        },
        builder: (context,state){
          var cubit=AppCubit.get(context);
          return DefaultTabController(
            length: 4,
            initialIndex: 0,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Color(0xFFF5F5F5),
                body: Column(
                  children: [
                    Appbar(),
                    SizedBox(height: 40,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ButtonsTabBar(
                        radius: 8,
                        contentPadding: EdgeInsets.symmetric(horizontal: 27),
                        borderWidth: 1,
                        decoration: BoxDecoration(
                          color: primaryColor,
                        ),
                        splashColor: primaryColor,
                        unselectedLabelStyle: TextStyle(color: Colors.grey,fontSize: 16),
                        unselectedBackgroundColor: Colors.white,
                        unselectedBorderColor: Colors.grey,
                        labelStyle: TextStyle(color: Colors.white),
                        height: 56,
                        tabs:[
                          Tab(text: "اضافة وكيل"),
                          Tab(text: "اضافة عداد"),
                          Tab(text: "اضافة اشعار"),
                          Tab(text: "العدادات"),
                        ],),
                    ),
                    SizedBox(height: 5,),
                    Expanded(
                      child: TabBarView(
                        children: [
                          SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 20,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'اضافة وكيل',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 30),
                                        CustomTextField(
                                          controller: userNameController,
                                          hintText: 'الاسم',
                                          prefixIcon: Icons.person_outline,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اخل الاسم';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: emailController,
                                          hintText: 'الايميل',
                                          prefixIcon: Icons.email_outlined,
                                          keyboardType: TextInputType.text,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اخل الايميل';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: phoneController,
                                          hintText: 'رقم الهاتف',
                                          prefixIcon: Icons.phone_outlined,
                                          keyboardType: TextInputType.phone,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اخل رقم الهاتف';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: locationController,
                                          hintText: 'العنوان',

                                          prefixIcon: Icons.location_on_outlined,
                                          keyboardType: TextInputType.text,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اخل العنوان';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: descriptionController,
                                          hintText: 'طرق الدفع',
                                          prefixIcon: Icons.payments_outlined,
                                          obscureText: false,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اكتب طرق الدفع';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: passwordController,
                                          hintText: 'كلمة السر',
                                          prefixIcon: Icons.password,
                                          obscureText: false,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اكتب كلمة السر';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 30),
                                        ConditionalBuilder(
                                          condition: state is !AssignAgentsLoadingState,
                                          builder: (context){
                                            return GestureDetector(
                                              onTap: (){
                                                if (formKey.currentState!.validate()) {
                                                  cubit.assignAgents(
                                                      name: userNameController.text.trim(),
                                                      email: emailController.text.trim(),
                                                      phone: phoneController.text.trim(),
                                                      location: locationController.text.trim(),
                                                      note: descriptionController.text.trim(),
                                                      context: context,
                                                    password:  passwordController.text.trim(),
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
                                                    color: primaryColor
                                                ),
                                                child: Center(
                                                  child: Text('اضافة الوكيل',
                                                    style: TextStyle(color: Colors.white,fontSize: 18 ),),
                                                ),
                                              ),
                                            );
                                          },
                                          fallback: (c)=> CircularProgressIndicator(color: primaryColor,),
                                        ),
                                        const SizedBox(height: 20),
                                        GestureDetector(
                                          onTap: (){
                                            navigateTo(context, ContectWoner());
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
                                                color: primaryColor
                                            ),
                                            child: Center(
                                              child: Text('رؤية الوكلاء',
                                                style: TextStyle(color: Colors.white,fontSize: 18 ),),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                  child: Form(
                                    key: formKey2,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 20,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'اضافة عداد',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 30),
                                        CustomTextField(
                                          controller: typeController,
                                          hintText: 'النوع',
                                          prefixIcon: Icons.type_specimen_outlined,
                                          keyboardType: TextInputType.none,
                                          onTap: (){
                                            showModalBottomSheet(
                                              context: context,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                              ),
                                              builder: (BuildContext context) {
                                                return Container(
                                                  width: double.maxFinite,
                                                  padding: EdgeInsets.all(16),
                                                  child: Column(
                                                    children: [
                                                      Text("اختر لمن تريد الارسال",style: TextStyle(color: primaryColor),),
                                                      SizedBox(height: 12),
                                                      Container(width: double.maxFinite,height: 1,color: Colors.grey,),
                                                      SizedBox(height: 12),
                                                      Expanded(
                                                        child: ListView.builder(
                                                            itemCount: role.length,
                                                            itemBuilder:(c,i){
                                                              return GestureDetector(
                                                                onTap: (){
                                                                  typeController.text=role[i];
                                                                  navigateBack(context);
                                                                },
                                                                child: Column(
                                                                  children: [
                                                                    Text(role[i],style: TextStyle(fontSize: 16),),
                                                                    SizedBox(height: 12),
                                                                    Container(width: double.maxFinite,height: 1,color: Colors.grey,),
                                                                    SizedBox(height: 12),
                                                                  ],
                                                                ),
                                                              );
                                                            }),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اخل النوع';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: pointsController,
                                          hintText: 'النقاط',
                                          prefixIcon: Icons.control_point,
                                          keyboardType: TextInputType.phone,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اخل النقاط';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: priceController,
                                          hintText: 'السعر',
                                          prefixIcon: Icons.payments_outlined,
                                          obscureText: false,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اكتب السعر';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 60),
                                        ConditionalBuilder(
                                          condition: state is !AssignCountersLoadingState,
                                          builder: (context){
                                            return GestureDetector(
                                              onTap: (){
                                                if (formKey2.currentState!.validate()) {
                                                  cubit.assignCounters(
                                                      points: pointsController.text.trim(),
                                                      price: priceController.text.trim(),
                                                      type: typeController.text.trim(),
                                                      context: context);
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
                                                    color: primaryColor
                                                ),
                                                child: Center(
                                                  child: Text('اضافة عداد',
                                                    style: TextStyle(color: Colors.white,fontSize: 18 ),),
                                                ),
                                              ),
                                            );
                                          },
                                          fallback: (c)=> CircularProgressIndicator(color: primaryColor,),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                  child: Form(
                                    key: formKey3,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 20,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'اضافة اشعار',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 30),
                                        CustomTextField(
                                          controller: rolController,
                                          hintText: 'موجه الى',
                                          prefixIcon: Icons.type_specimen_outlined,
                                          keyboardType: TextInputType.none,
                                          onTap: (){
                                            showModalBottomSheet(
                                              context: context,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                              ),
                                              builder: (BuildContext context) {
                                                return Container(
                                                  width: double.maxFinite,
                                                  padding: EdgeInsets.all(16),
                                                  child: Column(
                                                    children: [
                                                      Text("اختر لمن تريد الارسال",style: TextStyle(color: primaryColor),),
                                                      SizedBox(height: 12),
                                                      Container(width: double.maxFinite,height: 1,color: Colors.grey,),
                                                      SizedBox(height: 12),
                                                      Expanded(
                                                        child: ListView.builder(
                                                            itemCount: rol.length,
                                                            itemBuilder:(c,i){
                                                              return GestureDetector(
                                                                onTap: (){
                                                                  rolController.text=rol[i];
                                                                  navigateBack(context);
                                                                },
                                                                child: Column(
                                                                  children: [
                                                                    Text(rol[i],style: TextStyle(fontSize: 16),),
                                                                    SizedBox(height: 12),
                                                                    Container(width: double.maxFinite,height: 1,color: Colors.grey,),
                                                                    SizedBox(height: 12),
                                                                  ],
                                                                ),
                                                              );
                                                            }),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا ادخل النوع';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: tittleController,
                                          hintText: 'العنوان',
                                          prefixIcon: Icons.control_point,
                                          keyboardType: TextInputType.text,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اخل العنوان';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: massegeController,
                                          hintText: 'الوصف',
                                          prefixIcon: Icons.mail_outline,
                                          obscureText: false,
                                          maxLines: 8,
                                          validate: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'رجائا اكتب الوصف';
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 60),
                                        ConditionalBuilder(
                                          condition: state is !AddNotificationLoadingState,
                                          builder: (context){
                                            return GestureDetector(
                                              onTap: (){
                                                if (formKey3.currentState!.validate()) {
                                                  cubit.addNotification(
                                                      context: context,
                                                      title: tittleController.text.trim(),
                                                      desc: massegeController.text.trim(),
                                                      role: rolController.text.trim());
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
                                                    color: primaryColor
                                                ),
                                                child: Center(
                                                  child: Text('اضافة اشعار',
                                                    style: TextStyle(color: Colors.white,fontSize: 18 ),),
                                                ),
                                              ),
                                            );
                                          },
                                          fallback: (c)=> CircularProgressIndicator(color: primaryColor,),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ConditionalBuilder(
                              condition: cubit.counters != null,
                              builder: (c){
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap:(){
                                              navigateTo(context, ContectWoner());
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 6),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: Colors.deepOrangeAccent.withOpacity(0.2),
                                                border: Border.all(
                                                    color: Colors.deepOrangeAccent
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('الوكلاء',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 18,color: Colors.deepOrangeAccent),),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Text('الترقيات المتاحة #${cubit.counters!.length}',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(fontSize: 20,color: Colors.black),),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Expanded(
                                      child: ListView.builder(
                                          itemCount: cubit.counters!.length,
                                          itemBuilder: (c,i){
                                            return CardCounter(
                                              id: cubit.counters![i].id.toString(),
                                              point: cubit.counters![i].points.toString(),
                                              price: cubit.counters![i].price.toString(),
                                              type: cubit.counters![i].type.toString(),
                                              isSubscribed: true,
                                              monyOfUser: '0',
                                            );
                                          }),
                                    ),
                                    SizedBox(height: 30,),
                                  ],
                                );
                              },
                              fallback: (c)=>Center(child: CircularProgressIndicator())),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
