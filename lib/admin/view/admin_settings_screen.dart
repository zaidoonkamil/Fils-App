import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fils/admin/controllar/cubit.dart';
import 'package:fils/admin/controllar/states.dart';
import 'package:fils/admin/model/admin_settings_model.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _roomCostFormKey = GlobalKey<FormState>();
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _roomCreationCostController = TextEditingController();
  final _roomMaxUsersController = TextEditingController();

  bool _isEditing = false;
  bool _showRoomSettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() async {
    final cubit = context.read<AppCubitAdmin>();
    await cubit.getAllSettings();

    if (mounted) {
      final roomCost = cubit.getSettingValue('room_creation_cost', '10');
      final maxUsers = cubit.getSettingValue('room_max_users', '50');

      _roomCreationCostController.text = roomCost;
      _roomMaxUsersController.text = maxUsers;
    }
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    _descriptionController.dispose();
    _roomCreationCostController.dispose();
    _roomMaxUsersController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _keyController.clear();
    _valueController.clear();
    _descriptionController.clear();
    _isEditing = false;
  }

  void _editSetting(AdminSettingsModel setting) {
    _keyController.text = 'sawa_to_dollar_rate';
    _valueController.text = setting.value;
    _descriptionController.text = setting.description ?? '';
    _isEditing = true;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final key =
          _isEditing ? _keyController.text.trim() : 'sawa_to_dollar_rate';
      context.read<AppCubitAdmin>().createOrUpdateSetting(
        key: key,
        value: _valueController.text.trim(),
        description:
            _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
      );
    }
  }

  void _submitRoomSettings() {
    if (_roomCostFormKey.currentState!.validate()) {
      context.read<AppCubitAdmin>().updateRoomSettings(
        creationCost:
            int.tryParse(_roomCreationCostController.text.trim()) ?? 10,
        maxUsers: int.tryParse(_roomMaxUsersController.text.trim()) ?? 50,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubitAdmin, AppStatesAdmin>(
      listenWhen: (previous, current) {
        // فقط استمع للحالات المهمة التي تحتاج إشعارات
        return current is AdminCreateOrUpdateSettingSuccessState ||
            current is AdminCreateOrUpdateSettingErrorState ||
            current is AdminUpdateRoomSettingsSuccessState ||
            current is AdminUpdateRoomSettingsErrorState;
      },
      listener: (context, state) {
        if (state is AdminCreateOrUpdateSettingSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isEditing
                    ? 'تم تحديث الإعداد بنجاح'
                    : 'تم إنشاء الإعداد بنجاح',
              ),
              backgroundColor: Colors.green,
            ),
          );
          _clearForm();
          Navigator.of(context).pop();
        } else if (state is AdminCreateOrUpdateSettingErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('حدث خطأ في حفظ الإعداد'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is AdminUpdateRoomSettingsSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تحديث إعدادات الغرف بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AdminUpdateRoomSettingsErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('حدث خطأ في تحديث إعدادات الغرف'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showRoomSettings = !_showRoomSettings;
                        });
                      },
                      icon: Icon(
                        _showRoomSettings ? Icons.visibility_off : Icons.chat,
                        color: Colors.white,
                      ),
                      label: Text(
                        _showRoomSettings
                            ? 'إخفاء إعدادات الغرف'
                            : 'عرض إعدادات الغرف',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[600],
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        _clearForm();
                        showDialog(
                          context: context,
                          builder: (context) => _buildAddEditDialog(),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('إضافة إعداد جديد'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  'إدارة الإعدادات',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            if (_showRoomSettings) ...[
              const SizedBox(height: 20),
              _buildRoomSettingsCard(),
            ],
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<AppCubitAdmin, AppStatesAdmin>(
                buildWhen: (previous, current) {
                  // فقط أعيد البناء عند الحالات المهمة
                  return current is AdminGetSettingsLoadingState ||
                      current is AdminGetSettingsSuccessState ||
                      current is AdminGetSettingsErrorState ||
                      current is AdminCreateOrUpdateSettingSuccessState;
                },
                builder: (context, state) {
                  if (state is AdminGetSettingsLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is AdminGetSettingsErrorState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          const Text('خطأ في تحميل الإعدادات'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _loadInitialData(),
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    );
                  }

                  final settings = context.read<AppCubitAdmin>().settings;

                  if (settings.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.settings,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'لا توجد إعدادات',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'اضغط على "إضافة إعداد جديد" لإنشاء أول إعداد',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: settings.length,
                    itemBuilder: (context, index) {
                      final setting = settings[index];
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              _getSettingDisplayName(setting.key),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  'القيمة: ${setting.value}',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                                if (setting.description != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'الوصف: ${setting.description}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            setting.isActive
                                                ? Colors.green[100]
                                                : Colors.red[100],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        setting.isActive ? 'نشط' : 'غير نشط',
                                        style: TextStyle(
                                          color:
                                              setting.isActive
                                                  ? Colors.green[700]
                                                  : Colors.red[700],
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'آخر تحديث: ${_formatDate(setting.updatedAt)}',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _editSetting(setting);
                                  showDialog(
                                    context: context,
                                    builder: (context) => _buildAddEditDialog(),
                                  );
                                }
                              },
                              itemBuilder:
                                  (context) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, size: 18),
                                          SizedBox(width: 8),
                                          Text('تعديل'),
                                        ],
                                      ),
                                    ),
                                  ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddEditDialog() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Text(_isEditing ? 'تعديل الإعداد' : 'إضافة إعداد جديد'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // if (!_isEditing) ...[
                //   TextFormField(
                //     controller: _keyController,
                //     decoration: const InputDecoration(
                //       labelText: 'اسم الإعداد (Key)',
                //       hintText: 'مثال: sawa_to_dollar_rate',
                //       border: OutlineInputBorder(),
                //     ),
                //     validator: (value) {
                //       if (value == null || value.trim().isEmpty) {
                //         return 'مطلوب';
                //       }
                //       return null;
                //     },
                //   ),
                //   const SizedBox(height: 16),
                // ],
                TextFormField(
                  controller: _valueController,
                  decoration: const InputDecoration(
                    labelText: 'قيمة الإعداد',
                    hintText: 'مثال: 1.25',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'مطلوب';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'الوصف (اختياري)',
                    hintText: 'وصف مختصر للإعداد',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
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
            child: const Text('إلغاء'),
          ),
          BlocBuilder<AppCubitAdmin, AppStatesAdmin>(
            builder: (context, state) {
              final isLoading = state is AdminCreateOrUpdateSettingLoadingState;
              return ElevatedButton(
                onPressed: isLoading ? null : _submitForm,
                child:
                    isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : Text(_isEditing ? 'تحديث' : 'إضافة'),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getSettingDisplayName(String key) {
    switch (key) {
      case 'sawa_to_dollar_rate':
        return 'نسبة تحويل السوا إلى الدولار';
      case 'room_creation_cost':
        return 'تكلفة إنشاء الغرفة';
      case 'room_max_users':
        return 'الحد الأقصى للمستخدمين في الغرفة';
      default:
        return key.replaceAll('_', ' ').toUpperCase();
    }
  }

  Widget _buildRoomSettingsCard() {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.chat, color: Colors.orange[600], size: 32),
                Text(
                  'إعدادات الغرف',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Form(
              key: _roomCostFormKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _roomMaxUsersController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'الحد الأقصى للمستخدمين',
                            hintText: 'مثال: 50',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.people),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'مطلوب';
                            }
                            final num = int.tryParse(value.trim());
                            if (num == null || num <= 0) {
                              return 'يجب أن يكون رقماً صحيحاً أكبر من 0';
                            }
                            if (num > 1000) {
                              return 'لا يمكن أن يتجاوز 1000';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _roomCreationCostController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'تكلفة إنشاء الغرفة',
                            hintText: 'مثال: 10',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'مطلوب';
                            }
                            final num = int.tryParse(value.trim());
                            if (num == null || num < 0) {
                              return 'يجب أن يكون رقماً صحيحاً أكبر من أو يساوي 0';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'الإعدادات الجديدة ستطبق على الغرف الجديدة فقط',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<AppCubitAdmin, AppStatesAdmin>(
                    builder: (context, state) {
                      final isLoading =
                          state is AdminUpdateRoomSettingsLoadingState;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: isLoading ? null : _submitRoomSettings,
                          icon:
                              isLoading
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : const Icon(Icons.save, color: Colors.white),
                          label: Text(
                            isLoading ? 'جاري الحفظ...' : 'حفظ إعدادات الغرف',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
