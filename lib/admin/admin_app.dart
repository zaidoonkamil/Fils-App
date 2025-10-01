import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fils/admin/controllar/cubit.dart';
import 'package:fils/admin/view/admin_main_screen.dart';
import 'package:fils/core/styles/themes.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubitAdmin(),
      child: MaterialApp(
        title: 'لوحة تحكم الإدارة - فلس',
        debugShowCheckedModeBanner: false,
        theme: ThemeService().lightTheme,
        home: const AdminMainScreen(),
        routes: {'/admin-login': (context) => const AdminMainScreen()},
      ),
    );
  }
}
