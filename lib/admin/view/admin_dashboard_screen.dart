import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fils/admin/controllar/cubit.dart';
import 'package:fils/admin/controllar/states.dart';
import 'package:fils/admin/view/admin_users_screen.dart';
import 'package:fils/admin/view/admin_agents_screen.dart';
import 'package:fils/admin/view/admin_store_screen.dart';
import 'package:fils/admin/view/admin_ads_screen.dart';
import 'package:fils/admin/view/admin_notifications_screen.dart';
import 'package:fils/admin/view/admin_settings_screen.dart';

import '../../controllar/cubit.dart';
import '../../view/chat/chat_main_screen.dart';
import 'all_user_chat_admin.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardHomeScreen(),
    const AdminUsersScreen(),
    const AdminAgentsScreen(),
    const AdminStoreScreen(),
    const AdminAdsScreen(),
    const AdminNotificationsScreen(),
    const AdminSettingsScreen(),
    BlocProvider(
      create: (_) => AppCubit()..fetchRoomSettings()..getRooms(),
      child: const ChatMainScreen(),
    ),
    const AllUserChatAdmin(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppCubitAdmin>().getDashboardStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: _screens[_selectedIndex]),
          Container(
            width: 250,
            color: Colors.grey[100],
            child: Column(
              children: [
                const SizedBox(height: 20),
                BlocBuilder<AppCubitAdmin, AppStatesAdmin>(
                  builder: (context, state) {
                    final admin = context.read<AppCubitAdmin>().currentAdmin;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue[600],
                            child: Text(
                              admin?.name.substring(0, 1).toUpperCase() ?? 'A',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            admin?.name ?? 'Admin',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            admin?.email ?? '',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      _buildMenuItem(
                        icon: Icons.dashboard,
                        title: 'الرئيسية',
                        index: 0,
                      ),
                      _buildMenuItem(
                        icon: Icons.people,
                        title: 'المستخدمين',
                        index: 1,
                      ),
                      _buildMenuItem(
                        icon: Icons.business,
                        title: 'الوكلاء',
                        index: 2,
                      ),
                      _buildMenuItem(
                        icon: Icons.store,
                        title: 'المتجر',
                        index: 3,
                      ),
                      _buildMenuItem(
                        icon: Icons.campaign,
                        title: 'الإعلانات',
                        index: 4,
                      ),
                      _buildMenuItem(
                        icon: Icons.notifications,
                        title: 'الإشعارات',
                        index: 5,
                      ),
                      _buildMenuItem(
                        icon: Icons.settings,
                        title: 'الإعدادات',
                        index: 6,
                      ),
                      _buildMenuItem(
                        icon: Icons.meeting_room,
                        title: 'إدارة الغرف',
                        index: 7,
                      ),
                      _buildMenuItem(
                        icon: Icons.chat,
                        title: 'الدردشات',
                        index: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        trailing: Icon(
          icon,
          color: isSelected ? Colors.blue[600] : Colors.grey[600],
        ),
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            title,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: isSelected ? Colors.blue[600] : Colors.grey[800],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        selected: isSelected,
        selectedTileColor: Colors.blue[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class DashboardHomeScreen extends StatelessWidget {
  const DashboardHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubitAdmin, AppStatesAdmin>(
      builder: (context, state) {
        final cubit = context.read<AppCubitAdmin>();
        final dashboardStats = cubit.dashboardStats;

        if (state is AdminGetDashboardStatsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AdminGetDashboardStatsErrorState ||
            dashboardStats == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('خطأ في تحميل البيانات'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => cubit.getDashboardStats(),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'لوحة التحكم الرئيسية',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Main Stats Grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          _buildStatCard(
                            title: 'إجمالي المستخدمين',
                            value: dashboardStats.totalUsers.toString(),
                            icon: Icons.people,
                            color: Colors.blue,
                          ),
                          _buildStatCard(
                            title: 'الوكلاء',
                            value: dashboardStats.totalAgents.toString(),
                            icon: Icons.business,
                            color: Colors.green,
                          ),
                          _buildStatCard(
                            title: 'المستخدمين النشطين',
                            value: dashboardStats.activeUsers.toString(),
                            icon: Icons.verified_user,
                            color: Colors.orange,
                          ),
                          _buildStatCard(
                            title: 'إجمالي الفلس',
                            value: dashboardStats.totalSawa.toString(),
                            icon: Icons.monetization_on,
                            color: Colors.purple,
                          ),
                          _buildStatCard(
                            title: 'إجمالي الجواهر',
                            value: dashboardStats.totalGems.toString(),
                            icon: Icons.diamond,
                            color: Colors.teal,
                          ),
                          _buildStatCard(
                            title: 'عناصر المتجر المتاحة',
                            value:
                                dashboardStats.availableStoreItems.toString(),
                            icon: Icons.store,
                            color: Colors.red,
                          ),
                          _buildStatCard(
                            title: 'إجمالي عناصر المتجر',
                            value: dashboardStats.totalStoreItems.toString(),
                            icon: Icons.inventory,
                            color: Colors.indigo,
                          ),
                          _buildStatCard(
                            title: 'نسبة النشاط',
                            value: '${dashboardStats.activePercentage}%',
                            icon: Icons.trending_up,
                            color: Colors.cyan,
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              color: Colors.white,
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'توزيع المستخدمين',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      height: 200,
                                      child: PieChart(
                                        PieChartData(
                                          sections: [
                                            PieChartSectionData(
                                              value:
                                                  dashboardStats
                                                      .extra
                                                      .totalAdmins
                                                      .toDouble(),
                                              title: 'المديرين',
                                              color: Colors.blue,
                                              radius: 60,
                                            ),
                                            PieChartSectionData(
                                              value:
                                                  dashboardStats
                                                      .extra
                                                      .totalUsersOnly
                                                      .toDouble(),
                                              title: 'المستخدمين',
                                              color: Colors.green,
                                              radius: 60,
                                            ),
                                            PieChartSectionData(
                                              value:
                                                  dashboardStats.totalAgents
                                                      .toDouble(),
                                              title: 'الوكلاء',
                                              color: Colors.orange,
                                              radius: 60,
                                            ),
                                          ],
                                          sectionsSpace: 2,
                                          centerSpaceRadius: 40,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Card(
                              color: Colors.white,
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'حالة التحقق',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      height: 200,
                                      child: PieChart(
                                        PieChartData(
                                          sections: [
                                            PieChartSectionData(
                                              value:
                                                  dashboardStats
                                                      .extra
                                                      .totalVerifiedUsers
                                                      .toDouble(),
                                              title: 'محقق',
                                              color: Colors.green,
                                              radius: 60,
                                            ),
                                            PieChartSectionData(
                                              value:
                                                  dashboardStats
                                                      .extra
                                                      .totalUnverifiedUsers
                                                      .toDouble(),
                                              title: 'غير محقق',
                                              color: Colors.red,
                                              radius: 60,
                                            ),
                                          ],
                                          sectionsSpace: 2,
                                          centerSpaceRadius: 40,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Additional Stats Cards
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          _buildStatCard(
                            title: 'المديرين',
                            value: dashboardStats.extra.totalAdmins.toString(),
                            icon: Icons.admin_panel_settings,
                            color: Colors.indigo,
                          ),
                          _buildStatCard(
                            title: 'المستخدمين فقط',
                            value:
                                dashboardStats.extra.totalUsersOnly.toString(),
                            icon: Icons.person,
                            color: Colors.blue,
                          ),
                          _buildStatCard(
                            title: 'المستخدمين المحققين',
                            value:
                                dashboardStats.extra.totalVerifiedUsers
                                    .toString(),
                            icon: Icons.verified,
                            color: Colors.green,
                          ),
                          _buildStatCard(
                            title: 'المستخدمين غير المحققين',
                            value:
                                dashboardStats.extra.totalUnverifiedUsers
                                    .toString(),
                            icon: Icons.person_off,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
