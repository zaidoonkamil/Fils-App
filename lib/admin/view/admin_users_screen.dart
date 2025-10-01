import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fils/admin/controllar/cubit.dart';
import 'package:fils/admin/controllar/states.dart';
import 'package:fils/admin/model/admin_user_model.dart';
import 'package:fils/admin/model/admin_users_pagination_model.dart';
import 'package:fils/admin/view/admin_user_detail_screen.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({Key? key}) : super(key: key);

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedRole = 'all';
  int _currentPage = 1;
  int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppCubitAdmin>().getAllUsers(
        page: _currentPage,
        limit: _itemsPerPage,
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubitAdmin, AppStatesAdmin>(
      listener: (context, state) {
        if (state is AdminCreateUserSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إنشاء المستخدم بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<AppCubitAdmin>().getAllUsers(
            page: _currentPage,
            limit: _itemsPerPage,
          );
        } else if (state is AdminDeleteUserSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حذف المستخدم بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AdminUpdateUserStatusSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تحديث حالة المستخدم بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AdminUpdateUserGemsSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تحديث الجواهر بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<AppCubitAdmin>();
        final users = cubit.users;
        final usersPagination = cubit.usersPagination;

        // Apply local filtering for search and role
        final filteredUsers =
            users.where((user) {
              final matchesSearch =
                  user.name.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
                  user.email.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
                  user.phone.contains(_searchQuery);

              final matchesRole =
                  _selectedRole == 'all' || user.role == _selectedRole;

              return matchesSearch && matchesRole;
            }).toList();

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showCreateUserDialog(context),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('إضافة مستخدم'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                  Text(
                    'إدارة المستخدمين',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: InputDecoration(
                        labelText: 'الصلاحية',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      dropdownColor: Colors.white,
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('الكل')),
                        DropdownMenuItem(value: 'user', child: Text('مستخدم')),
                        DropdownMenuItem(value: 'agent', child: Text('وكيل')),
                        DropdownMenuItem(value: 'admin', child: Text('مدير')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'البحث في المستخدمين...',
                        suffixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              if (usersPagination != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textDirection: TextDirection.rtl,
                    children: [
                      Text(
                        'إجمالي المستخدمين: ${usersPagination.totalUsers}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[700],
                        ),
                      ),
                      Text(
                        'الصفحة ${usersPagination.currentPage} من ${usersPagination.totalPages}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),

              Expanded(
                child:
                    state is AdminGetUsersPaginationLoadingState
                        ? const Center(child: CircularProgressIndicator())
                        : Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'الإجراءات',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'الحالة',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'الصلاحية',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'الهاتف',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'البريد الإلكتروني',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'الاسم',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(
                                child:
                                    filteredUsers.isEmpty
                                        ? const Center(
                                          child: Text('لا توجد مستخدمين'),
                                        )
                                        : ListView.builder(
                                          itemCount: filteredUsers.length,
                                          itemBuilder: (context, index) {
                                            final user = filteredUsers[index];
                                            return _buildUserRow(user);
                                          },
                                        ),
                              ),

                              if (usersPagination != null &&
                                  usersPagination.totalPages > 1)
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: _buildPaginationControls(
                                    usersPagination,
                                  ),
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

  Widget _buildUserRow(AdminUserModel user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.visibility,
                    size: 16,
                    color: Colors.blue,
                  ),
                  onPressed: () => _navigateToUserDetail(context, user),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 16),
                  onPressed: () => _showEditUserDialog(context, user),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                  onPressed: () => _showDeleteUserDialog(context, user),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: user.isActive ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  user.isActive ? 'نشط' : 'محظور',
                  style: TextStyle(
                    fontSize: 12,
                    color: user.isActive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getRoleColor(user.role).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getRoleText(user.role),
                style: TextStyle(
                  fontSize: 12,
                  color: _getRoleColor(user.role),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.phone,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.email,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  'ID: ${user.id}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'agent':
        return Colors.blue;
      case 'user':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getRoleText(String role) {
    switch (role) {
      case 'admin':
        return 'مدير';
      case 'agent':
        return 'وكيل';
      case 'user':
        return 'مستخدم';
      default:
        return role;
    }
  }

  void _showCreateUserDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final locationController = TextEditingController();
    final passwordController = TextEditingController();
    final noteController = TextEditingController();
    String selectedRole = 'user';
    bool isAlwaysVerified = false;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text(
                      'إضافة مستخدم جديد',
                      textAlign: TextAlign.right,
                    ),
                    content: SizedBox(
                      width: 400,
                      child: Form(
                        key: formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextFormField(
                                controller: nameController,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  labelText: 'الاسم',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'يرجى إدخال الاسم';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  labelText: 'البريد الإلكتروني',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'يرجى إدخال البريد الإلكتروني';
                                  }
                                  if (!value.contains('@')) {
                                    return 'يرجى إدخال بريد إلكتروني صحيح';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  labelText: 'الهاتف',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'يرجى إدخال الهاتف';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: locationController,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  labelText: 'الموقع',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'يرجى إدخال الموقع';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  labelText: 'كلمة المرور',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'يرجى إدخال كلمة المرور';
                                  }
                                  if (value.length < 6) {
                                    return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: selectedRole,
                                decoration: const InputDecoration(
                                  labelText: 'الصلاحية',
                                  border: OutlineInputBorder(),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'user',
                                    child: Text(
                                      'مستخدم',
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'agent',
                                    child: Text(
                                      'وكيل',
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'admin',
                                    child: Text(
                                      'مدير',
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedRole = value!;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: noteController,
                                textAlign: TextAlign.right,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  labelText: 'ملاحظات (اختياري)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              CheckboxListTile(
                                title: const Text('مستخدم موثق'),
                                value: isAlwaysVerified,
                                onChanged: (value) {
                                  setState(() {
                                    isAlwaysVerified = value!;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إلغاء'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            Navigator.pop(context);
                            if (isAlwaysVerified) {
                              context
                                  .read<AppCubitAdmin>()
                                  .createAlwaysVerifiedUser(
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text,
                                    location: locationController.text,
                                    password: passwordController.text,
                                    role: selectedRole,
                                    note:
                                        noteController.text.isEmpty
                                            ? null
                                            : noteController.text,
                                  );
                            } else {
                              context.read<AppCubitAdmin>().createUser(
                                name: nameController.text,
                                email: emailController.text,
                                phone: phoneController.text,
                                location: locationController.text,
                                password: passwordController.text,
                                role: selectedRole,
                                note:
                                    noteController.text.isEmpty
                                        ? null
                                        : noteController.text,
                              );
                            }
                          }
                        },
                        child: const Text('إضافة'),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  void _showEditUserDialog(BuildContext context, AdminUserModel user) {
    final formKey = GlobalKey<FormState>();
    final gemsController = TextEditingController(text: user.jewel.toString());
    bool isActive = user.isActive;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: Text('تعديل المستخدم: ${user.name}'),
                  content: SizedBox(
                    width: 300,
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: gemsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'عدد الجواهر',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال عدد الجواهر';
                              }
                              if (int.tryParse(value) == null) {
                                return 'يرجى إدخال رقم صحيح';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CheckboxListTile(
                            title: const Text('نشط'),
                            value: isActive,
                            onChanged: (value) {
                              setState(() {
                                isActive = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إلغاء'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          final gems = int.parse(gemsController.text);
                          context.read<AppCubitAdmin>().updateUserGems(
                            user.id,
                            gems,
                          );
                          if (isActive != user.isActive) {
                            context.read<AppCubitAdmin>().updateUserStatus(
                              user.id,
                              isActive,
                            );
                          }
                        }
                      },
                      child: const Text('حفظ'),
                    ),
                  ],
                ),
          ),
    );
  }

  void _showDeleteUserDialog(BuildContext context, AdminUserModel user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('حذف المستخدم'),
            content: Text('هل أنت متأكد من حذف المستخدم "${user.name}"؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<AppCubitAdmin>().deleteUser(user.id);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('حذف'),
              ),
            ],
          ),
    );
  }

  void _navigateToUserDetail(BuildContext context, AdminUserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminUserDetailScreen(userId: user.id),
      ),
    );
  }

  Widget _buildPaginationControls(AdminUsersPaginationModel pagination) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous Button
        IconButton(
          onPressed:
              _currentPage > 1 ? () => _changePage(_currentPage - 1) : null,
          icon: const Icon(Icons.chevron_right),
          style: IconButton.styleFrom(
            backgroundColor:
                _currentPage > 1 ? Colors.blue[600] : Colors.grey[300],
            foregroundColor: Colors.white,
          ),
        ),

        const SizedBox(width: 8),

        // Page Numbers
        ...List.generate(
          pagination.totalPages > 5 ? 5 : pagination.totalPages,
          (index) {
            int pageNumber;
            if (pagination.totalPages <= 5) {
              pageNumber = index + 1;
            } else {
              // Show current page and 2 pages before/after
              if (_currentPage <= 3) {
                pageNumber = index + 1;
              } else if (_currentPage >= pagination.totalPages - 2) {
                pageNumber = pagination.totalPages - 4 + index;
              } else {
                pageNumber = _currentPage - 2 + index;
              }
            }

            final isCurrentPage = pageNumber == _currentPage;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: InkWell(
                onTap: () => _changePage(pageNumber),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isCurrentPage ? Colors.blue[600] : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          isCurrentPage ? Colors.blue[600]! : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    pageNumber.toString(),
                    style: TextStyle(
                      color: isCurrentPage ? Colors.white : Colors.grey[700],
                      fontWeight:
                          isCurrentPage ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(width: 8),

        // Next Button
        IconButton(
          onPressed:
              _currentPage < pagination.totalPages
                  ? () => _changePage(_currentPage + 1)
                  : null,
          icon: const Icon(Icons.chevron_left),
          style: IconButton.styleFrom(
            backgroundColor:
                _currentPage < pagination.totalPages
                    ? Colors.blue[600]
                    : Colors.grey[300],
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _changePage(int page) {
    setState(() {
      _currentPage = page;
    });
    context.read<AppCubitAdmin>().getAllUsers(page: page, limit: _itemsPerPage);
  }
}
