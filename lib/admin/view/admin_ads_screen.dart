import 'package:fils/core/%20navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fils/admin/controllar/cubit.dart';
import 'package:fils/admin/controllar/states.dart';
import 'package:fils/admin/model/admin_ads_model.dart';

import '../../core/network/remote/dio_helper.dart';

class AdminAdsScreen extends StatefulWidget {
  const AdminAdsScreen({Key? key}) : super(key: key);

  @override
  State<AdminAdsScreen> createState() => _AdminAdsScreenState();
}

class _AdminAdsScreenState extends State<AdminAdsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppCubitAdmin>().getAds();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubitAdmin, AppStatesAdmin>(
      builder: (context, state) {
        final cubit = context.read<AppCubitAdmin>();
        final ads = cubit.ads;

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showCreateAdDialog(context),
                    icon: const Icon(Icons.add,color: Colors.white,),
                    label: const Text('إضافة إعلان جديد'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  Text(
                    'إدارة الإعلانات',
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
                child:
                    state is AdminGetAdsLoadingState
                        ? const Center(child: CircularProgressIndicator())
                        : state is AdminGetAdsErrorState
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error,
                                size: 64,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              const Text('خطأ في تحميل الإعلانات'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => cubit.getAds(),
                                child: const Text('إعادة المحاولة'),
                              ),
                            ],
                          ),
                        )
                        : ads.isEmpty
                        ? const Center(
                          child: Text(
                            'لا توجد إعلانات',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                        : ListView.builder(
                          itemCount: ads.length,
                          itemBuilder: (context, index) {
                            final ad = ads[index];
                            return _buildAdCard(ad, cubit);
                          },
                        ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdCard(AdminAdsModel ad, AppCubitAdmin cubit) {
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
                IconButton(
                  onPressed:
                      () => _showDeleteConfirmation(context, ad.id, cubit),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
                Text(
                  ad.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ad.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            if (ad.images.isNotEmpty) ...[
              const Text(
                ':الصور',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  itemCount: ad.images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(left: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          '$url/uploads/${ad.images[index]}',
                          width: 240,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'تاريخ الإنشاء: ${_formatDate(ad.createdAt)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateAdDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('إضافة إعلان جديد'),
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
                      labelText: 'عنوان الإعلان',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال عنوان الإعلان';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'وصف الإعلان',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال وصف الإعلان';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickImages,
                        icon: const Icon(Icons.image),
                        label: const Text('اختيار الصور'),
                      ),
                    ],
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
              child: const Text('إلغاء',style: TextStyle(color: Colors.black),),
            ),
            BlocConsumer<AppCubitAdmin, AppStatesAdmin>(
              listener: (context, state) {
                if (state is AdminCreateAdsSuccessState) {
                  Navigator.of(context).pop();
                  _clearForm();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إنشاء الإعلان بنجاح')),
                  );
                } else if (state is AdminCreateAdsErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('خطأ في إنشاء الإعلان')),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: state is AdminCreateAdsLoadingState
                      ? null
                      : () {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedImages.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                            Text('يرجى اختيار صورة واحدة على الأقل'),
                          ),
                        );
                        return;
                      }
                      context.read<AppCubitAdmin>().createAd(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        selectedImages: _selectedImages,
                        context: context,
                      );

                    }
                  },
                  child: state is AdminCreateAdsLoadingState
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ) : const Text('إنشاء'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    int adId,
    AppCubitAdmin cubit,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
            title: const Text('تأكيد الحذف'),
            content: const Text('هل أنت متأكد من حذف هذا الإعلان؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إلغاء'),
              ),
              BlocConsumer<AppCubitAdmin, AppStatesAdmin>(
                listener: (context, state) {
                  if (state is AdminDeleteAdsSuccessState) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم حذف الإعلان بنجاح')),
                    );
                  } else if (state is AdminDeleteAdsErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('خطأ في حذف الإعلان')),
                    );
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed:
                        state is AdminDeleteAdsLoadingState
                            ? null
                            : () {
                          cubit.deleteAd(adId);
                          navigateBack(context);
                        },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child:
                        state is AdminDeleteAdsLoadingState
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Text('حذف',style: TextStyle(color: Colors.white),),
                  );
                },
              ),
            ],
          ),
    );
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        setState(() {
          _selectedImages = images; // <-- خليها XFile مباشرة
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('خطأ في اختيار الصور: $e')));
    }
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _selectedImages.clear();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
