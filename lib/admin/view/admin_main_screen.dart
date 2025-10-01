import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fils/admin/controllar/cubit.dart';
import 'package:fils/admin/controllar/states.dart';
import 'package:fils/admin/view/admin_login_screen.dart';
import 'package:fils/admin/view/admin_dashboard_screen.dart';

class AdminMainScreen extends StatelessWidget {
  const AdminMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubitAdmin(),
      child: BlocBuilder<AppCubitAdmin, AppStatesAdmin>(
        builder: (context, state) {
          final cubit = context.read<AppCubitAdmin>();
          if (cubit.currentAdmin != null && cubit.adminToken != null) {
            return const AdminDashboardScreen();
          } else {
            // return const AdminLoginScreen();
            return const AdminDashboardScreen();

          }
        },
      ),
    );
  }
}
