import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controllar/cubit.dart';
import '../../controllar/states.dart';
import '../../core/widgets/appBar.dart';
import '../../model/RoomModel.dart';

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
                        //      floatingLabelAlignment: FloatingLabelAlignment.center,
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

                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  controller: _costController,
                                  decoration: InputDecoration(
                                    floatingLabelAlignment: FloatingLabelAlignment.center,
                                    labelText: 'تكلفة إنشاء الغرفة (نقاط)',
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(Icons.diamond, color: Colors.amber),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'يرجى إدخال التكلفة';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return 'يرجى إدخال رقم صحيح';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  controller: _maxUsersController,
                                  decoration: InputDecoration(
                                    floatingLabelAlignment: FloatingLabelAlignment.center,
                                    labelText: 'الحد الأقصى للمستخدمين',
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(Icons.people),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'يرجى إدخال الحد الأقصى';
                                    }
                                    final maxUsers = int.tryParse(value);
                                    if (maxUsers == null || maxUsers < 1 || maxUsers > 100) {
                                      return 'يرجى إدخال رقم بين 1 و 100';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              floatingLabelAlignment: FloatingLabelAlignment.center,
                              labelText: 'فئة الغرفة',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.category),
                            ),
                            value: _selectedCategory,
                            items: [
                              DropdownMenuItem(value: 'general', child: Text('عام')),
                              DropdownMenuItem(value: 'gaming', child: Text('ألعاب')),
                              DropdownMenuItem(value: 'music', child: Text('موسيقى')),
                              DropdownMenuItem(value: 'sports', child: Text('رياضة')),
                              DropdownMenuItem(value: 'technology', child: Text('تقنية')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value!;
                              });
                            },
                          ),
                          SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: state is ChatCreateRoomLoadingState
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        AppCubit.get(context).createRoom(
                                          name: _nameController.text,
                                          description: _descriptionController.text,
                                          cost: int.parse(_costController.text),
                                          maxUsers: int.parse(_maxUsersController.text),
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
