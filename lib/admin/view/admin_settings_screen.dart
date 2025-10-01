import 'package:fils/core/%20navigation/navigation.dart';
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
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppCubitAdmin>().getAllSettings();
    });
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _keyController.clear();
    _valueController.clear();
    _descriptionController.clear();
    _isEditing = false;
  }

  void _editSetting(AdminSettingsModel setting) {
    _keyController.text = setting.key;
    _valueController.text = setting.value;
    _descriptionController.text = setting.description ?? '';
    _isEditing = true;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<AppCubitAdmin>().createOrUpdateSetting(
        key: 'sawa_to_dollar_rate',
        value: _valueController.text.trim(),
        description:
            _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubitAdmin, AppStatesAdmin>(
      listener: (context, state) {
        if (state is AdminCreateOrUpdateSettingSuccessState) {
          navigateBack(context);
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
        } else if (state is AdminCreateOrUpdateSettingErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('حدث خطأ في حفظ الإعداد'),
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
                ElevatedButton.icon(
                  onPressed: () {
                    _clearForm();
                    showDialog(
                      context: context,
                      builder: (context) => _buildAddEditDialog(),
                    );
                  },
                  icon: const Icon(Icons.add,color: Colors.white,),
                  label: const Text('إضافة إعداد جديد'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                  ),
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
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<AppCubitAdmin, AppStatesAdmin>(
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
                            onPressed: () => context.read<AppCubitAdmin>().getAllSettings(),
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
                              'الفلس',
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
                                        color: setting.isActive
                                            ? Colors.green[100]
                                            : Colors.red[100],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        setting.isActive ? 'نشط' : 'غير نشط',
                                        style: TextStyle(
                                          color: setting.isActive
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
                              itemBuilder: (context) => [
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
                child: isLoading
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
}
