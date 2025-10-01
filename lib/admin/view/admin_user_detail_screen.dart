import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fils/admin/controllar/cubit.dart';
import 'package:fils/admin/controllar/states.dart';
import 'package:fils/admin/model/admin_user_detail_model.dart';

class AdminUserDetailScreen extends StatefulWidget {
  final int userId;

  const AdminUserDetailScreen({Key? key, required this.userId})
    : super(key: key);

  @override
  State<AdminUserDetailScreen> createState() => _AdminUserDetailScreenState();
}

class _AdminUserDetailScreenState extends State<AdminUserDetailScreen> {
  final _sawaController = TextEditingController();
  final _jewelController = TextEditingController();
  final _cardController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppCubitAdmin>().getUserDetail(widget.userId);
    });
  }

  @override
  void dispose() {
    _sawaController.dispose();
    _jewelController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubitAdmin, AppStatesAdmin>(
      builder: (context, state) {
        final cubit = context.read<AppCubitAdmin>();
        final userDetail = cubit.selectedUserDetail;

        return Scaffold(
          appBar: AppBar(
            title: const Text('تفاصيل المستخدم'),
            centerTitle: true,
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body:
              state is AdminGetUserDetailLoadingState
                  ? const Center(child: CircularProgressIndicator())
                  : state is AdminGetUserDetailErrorState
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text('خطأ في تحميل تفاصيل المستخدم'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => cubit.getUserDetail(widget.userId),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  )
                  : userDetail == null
                  ? const Center(child: Text('لا توجد بيانات'))
                  : SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildUserInfoCard(userDetail),
                        const SizedBox(height: 24),

                        // أرصدة المستخدم
                        _buildBalanceCard(userDetail, cubit),
                        const SizedBox(height: 24),

                        // عدادات المستخدم
                        _buildUserCountersCard(userDetail),
                        const SizedBox(height: 24),

                        // سجل التحويلات
                        _buildTransferHistoryCard(userDetail),
                        const SizedBox(height: 24),

                        // طلبات السحب
                        _buildWithdrawalRequestsCard(userDetail),
                      ],
                    ),
                  ),
        );
      },
    );
  }

  Widget _buildUserInfoCard(AdminUserDetailModel user) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'معلومات المستخدم',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('الاسم', user.name),
            _buildInfoRow('البريد الإلكتروني', user.email),
            _buildInfoRow('رقم الهاتف', user.phone),
            _buildInfoRow('الموقع', user.location),
            _buildInfoRow('الدور', _getRoleText(user.role)),
            _buildInfoRow('الحالة', user.isActive ? 'نشط' : 'غير نشط'),
            _buildInfoRow('التحقق', user.isVerified ? 'محقق' : 'غير محقق'),
            _buildInfoRow('تاريخ الإنشاء', _formatDate(user.createdAt)),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(AdminUserDetailModel user, AppCubitAdmin cubit) {
    return Row(
      children: [
        Expanded(
          child: _buildBalanceItem(
            'السوا',
            user.sawa.toString(),
            Colors.blue,
            Icons.monetization_on,
                () => _showDepositDialog(context, 'sawa', user.id, cubit),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildBalanceItem(
            'الجواهر',
            user.jewel.toString(),
            Colors.amber,
            Icons.diamond,
                () => _showDepositDialog(context, 'jewel', user.id, cubit),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildBalanceItem(
            'البطاقات',
            user.card.toString(),
            Colors.green,
            Icons.credit_card,
                () => _showDepositDialog(context, 'card', user.id, cubit),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceItem(
    String title,
    String value,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text('اضغط للإضافة', style: TextStyle(fontSize: 10, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCountersCard(AdminUserDetailModel user) {
    return Card(
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'عدادات المستخدم (${user.userCounters.length})',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            if (user.userCounters.isEmpty)
              const Center(child: Text('لا توجد عدادات'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: user.userCounters.length,
                itemBuilder: (context, index) {
                  final counter = user.userCounters[index];
                  return _buildCounterItem(counter);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterItem(AdminUserCounterModel counter) {
    final remainingDays = _calculateRemainingDays(counter.endDate);
    final isExpired = remainingDays <= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isExpired ? Colors.red[50] : Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isExpired ? Colors.red[300]! : Colors.green[300]!,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'النقاط: ${counter.points}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('النوع: ${_getCounterTypeText(counter.type)}'),
              Text('السعر: ${counter.price}'),
              Text(
                isExpired ? 'منتهي الصلاحية' : 'متبقي: $remainingDays يوم',
                style: TextStyle(
                  color: isExpired ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (counter.isForSale)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'معروض للبيع',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTransferHistoryCard(AdminUserDetailModel user) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'سجل التحويلات (${user.transferHistory.length})',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            if (user.transferHistory.isEmpty)
              const Center(child: Text('لا توجد تحويلات'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: user.transferHistory.length,
                itemBuilder: (context, index) {
                  final transfer = user.transferHistory[index];
                  return _buildTransferItem(transfer);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferItem(AdminTransferHistoryModel transfer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'المبلغ: ${transfer.amount} سوا',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (transfer.fee > 0) Text('العمولة: ${transfer.fee} سوا'),
          Text('التاريخ: ${_formatDate(transfer.createdAt)}'),
          if (transfer.sender != null) Text('من: ${transfer.sender!.name}'),
          if (transfer.receiver != null)
            Text('إلى: ${transfer.receiver!.name}'),
        ],
      ),
    );
  }

  Widget _buildWithdrawalRequestsCard(AdminUserDetailModel user) {
    return Card(
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'طلبات السحب (${user.withdrawalRequests.length})',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            if (user.withdrawalRequests.isEmpty)
              const Center(child: Text('لا توجد طلبات سحب'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: user.withdrawalRequests.length,
                itemBuilder: (context, index) {
                  final request = user.withdrawalRequests[index];
                  return _buildWithdrawalItem(request);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawalItem(AdminWithdrawalRequestModel request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'المبلغ: ${request.amount} سوا',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('الطريقة: ${request.method}'),
          Text('رقم الحساب: ${request.accountNumber}'),
          Text('الحالة: ${request.status}'),
          Text('التاريخ: ${_formatDate(request.createdAt)}'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  void _showDepositDialog(
    BuildContext context,
    String type,
    int userId,
    AppCubitAdmin cubit,
  ) {
    final controller =
        type == 'sawa'
            ? _sawaController
            : type == 'jewel'
            ? _jewelController
            : _cardController;

    final title =
        type == 'sawa'
            ? 'إضافة سوا'
            : type == 'jewel'
            ? 'إضافة جواهر'
            : 'إضافة بطاقات';

    showDialog(
      context: context,
      builder:
          (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              backgroundColor: Colors.white,
              title: Text(title),
              content: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'المبلغ',
                  border: const OutlineInputBorder(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    controller.clear();
                  },
                  child: const Text('إلغاء'),
                ),
                BlocConsumer<AppCubitAdmin, AppStatesAdmin>(
                  listener: (context, state) {
                    if (state is AdminDepositSuccessState) {
                      Navigator.of(context).pop();
                      controller.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم إضافة $title بنجاح')),
                      );
                    } else if (state is AdminDepositErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('خطأ في إضافة $title')),
                      );
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed:
                          state is AdminDepositLoadingState
                              ? null
                              : () {
                                final amount = double.tryParse(controller.text);
                                if (amount != null && amount > 0) {
                                  if (type == 'sawa') {
                                    cubit.depositSawa(userId, amount);
                                  } else if (type == 'jewel') {
                                    cubit.depositJewel(userId, amount.toInt());
                                  } else if (type == 'card') {
                                    cubit.depositCard(userId, amount.toInt());
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('يرجى إدخال مبلغ صحيح'),
                                    ),
                                  );
                                }
                              },
                      child:
                          state is AdminDepositLoadingState
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('إضافة'),
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getRoleText(String role) {
    switch (role) {
      case 'user':
        return 'مستخدم';
      case 'agent':
        return 'وكيل';
      case 'admin':
        return 'مدير';
      default:
        return role;
    }
  }

  String _getCounterTypeText(String type) {
    switch (type) {
      case 'points':
        return 'نقاط';
      case 'gems':
        return 'جواهر';
      default:
        return type;
    }
  }

  int _calculateRemainingDays(DateTime endDate) {
    final now = DateTime.now();
    final difference = endDate.difference(now).inDays;
    return difference;
  }
}
