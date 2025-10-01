import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fils/admin/controllar/cubit.dart';
import 'package:fils/admin/controllar/states.dart';
import 'package:fils/admin/model/admin_notification_model.dart';

class AdminNotificationsScreen extends StatefulWidget {
  const AdminNotificationsScreen({Key? key}) : super(key: key);

  @override
  State<AdminNotificationsScreen> createState() =>
      _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  String? _selectedRole;

  final List<String> _roles = ['user', 'agent'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppCubitAdmin>().getNotificationsLog();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubitAdmin, AppStatesAdmin>(
      builder: (context, state) {
        final cubit = context.read<AppCubitAdmin>();
        final notifications = cubit.notifications;

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'إدارة الإشعارات',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
          Directionality(
            textDirection: TextDirection.rtl, // 👈 يخلي النص والحقول يمين
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'عنوان الإشعار',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال عنوان الإشعار';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          labelText: 'نص الإشعار',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال نص الإشعار';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        decoration: const InputDecoration(
                          labelText: 'المستهدف (اختياري)',
                          border: OutlineInputBorder(),
                        ),
                        hint: const Text('اختر المستهدف'),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('الجميع'),
                          ),
                          ..._roles.map(
                                (role) => DropdownMenuItem<String>(
                              value: role,
                              child: Text(_getRoleText(role)),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _clearForm();
                        },
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      BlocConsumer<AppCubitAdmin, AppStatesAdmin>(
                        listener: (context, state) {
                          if (state is AdminSendNotificationSuccessState) {
                            _clearForm();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم إرسال الإشعار بنجاح')),
                            );
                          } else if (state is AdminSendNotificationErrorState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('خطأ في إرسال الإشعار')),
                            );
                          }
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            onPressed: state is AdminSendNotificationLoadingState
                                ? null
                                : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AppCubitAdmin>().sendNotification(
                                  title: _titleController.text,
                                  message: _messageController.text,
                                  role: _selectedRole,
                                );
                              }
                            },
                            child: state is AdminSendNotificationLoadingState
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : const Text('إرسال'),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
          ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationCard(AdminNotificationLogModel notification) {
    Color statusColor;
    IconData statusIcon;

    switch (notification.status) {
      case 'sent':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'failed':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(statusIcon, color: statusColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      _getStatusText(notification.status),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  notification.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              notification.message,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تاريخ الإرسال: ${_formatDate(notification.createdAt)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                if (notification.targetType == 'role')
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'إلى: ${_getRoleText(notification.targetValue)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'إلى: الجميع',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.purple[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showSendNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('إرسال إشعار'),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'عنوان الإشعار',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال عنوان الإشعار';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          labelText: 'نص الإشعار',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال نص الإشعار';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        decoration: const InputDecoration(
                          labelText: 'المستهدف (اختياري)',
                          border: OutlineInputBorder(),
                        ),
                        hint: const Text('اختر المستهدف'),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('الجميع'),
                          ),
                          ..._roles.map(
                            (role) => DropdownMenuItem<String>(
                              value: role,
                              child: Text(_getRoleText(role)),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _clearForm();
                  },
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                BlocConsumer<AppCubitAdmin, AppStatesAdmin>(
                  listener: (context, state) {
                    if (state is AdminSendNotificationSuccessState) {
                      Navigator.of(context).pop();
                      _clearForm();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم إرسال الإشعار بنجاح')),
                      );
                    } else if (state is AdminSendNotificationErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('خطأ في إرسال الإشعار')),
                      );
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onPressed:
                          state is AdminSendNotificationLoadingState
                              ? null
                              : () {
                                if (_formKey.currentState!.validate()) {
                                  context
                                      .read<AppCubitAdmin>()
                                      .sendNotification(
                                        title: _titleController.text,
                                        message: _messageController.text,
                                        role: _selectedRole,
                                      );
                                }
                              },
                      child:
                          state is AdminSendNotificationLoadingState
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('إرسال'),
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _clearForm() {
    _titleController.clear();
    _messageController.clear();
    _selectedRole = null;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'sent':
        return 'تم الإرسال';
      case 'failed':
        return 'فشل الإرسال';
      default:
        return 'في الانتظار';
    }
  }

  String _getRoleText(String role) {
    switch (role) {
      case 'user':
        return 'المستخدمين';
      case 'agent':
        return 'الوكلاء';
      // case 'admin':
      //   return 'المديرين';
      default:
        return role;
    }
  }
}
