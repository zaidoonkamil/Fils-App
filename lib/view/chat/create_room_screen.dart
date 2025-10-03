import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controllar/cubit.dart';
import '../../controllar/states.dart';
import '../../core/widgets/appBar.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({Key? key}) : super(key: key);

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  final _maxUsersController = TextEditingController(text: '50');
  String _selectedCategory = 'general';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppCubit.get(context).fetchRoomSettings();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
    _maxUsersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is ChatCreateRoomSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        var cubit=AppCubit.get(context);
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                AppbarBack(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            decoration: InputDecoration(
                              labelText: 'اسم الغرفة',
                              hintTextDirection: TextDirection.rtl,
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.chat),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال اسم الغرفة';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              floatingLabelAlignment: FloatingLabelAlignment.center,
                              labelText: 'وصف الغرفة',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.description),
                            ),
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال وصف الغرفة';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (state is ChatRoomSettingsLoadingState)
                                Center(child: CircularProgressIndicator())
                              else if (state is ChatRoomSettingsSuccessState && cubit.getRoomSettings != null) ...[
                                Text(
                                  cubit.getRoomSettings!['room_creation_cost'] == 0
                                      ? "تكلفة إنشاء الغرفة: مجاناً"
                                      : "تكلفة إنشاء الغرفة: ${cubit.getRoomSettings!['room_creation_cost']} نقطة",
                                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                                  textAlign: TextAlign.right,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "الحد الأقصى للمستخدمين: ${cubit.getRoomSettings!['room_max_users']}",
                                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                                  textAlign: TextAlign.right,
                                ),
                              ] else if (state is ChatRoomSettingsErrorState) ...[
                                Text(
                                  "حدث خطأ في جلب البيانات",
                                  style: TextStyle(color: Colors.red, fontSize: 14),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: (state is ChatCreateRoomLoadingState || cubit.getRoomSettings == null)
                                  ? null
                                  : () {
                                if (_formKey.currentState!.validate()) {
                                  AppCubit.get(context).createRoom(
                                    name: _nameController.text,
                                    description: _descriptionController.text,
                                    cost: cubit.getRoomSettings!['room_creation_cost'],
                                    maxUsers: cubit.getRoomSettings!['room_max_users'],
                                    category: _selectedCategory,
                                    context: context,
                                  );
                                }
                              },
                              child: state is ChatCreateRoomLoadingState
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                'إنشاء الغرفة',
                                style: TextStyle(fontSize: 16),
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
          ),
        );
      },
    );
  }
}
