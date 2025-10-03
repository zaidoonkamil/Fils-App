import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:fils/admin/controllar/states.dart';
import 'package:fils/admin/model/admin_user_model.dart';
import 'package:fils/admin/model/admin_agent_model.dart';
import 'package:fils/admin/model/admin_store_model.dart';
import 'package:fils/admin/model/admin_dashboard_model.dart';
import 'package:fils/admin/model/admin_ads_model.dart';
import 'package:fils/admin/model/admin_notification_model.dart';
import 'package:fils/admin/model/admin_user_detail_model.dart';
import 'package:fils/admin/model/admin_settings_model.dart';
import 'package:fils/admin/model/admin_users_pagination_model.dart';
import 'package:fils/core/network/remote/dio_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';

class AppCubitAdmin extends Cubit<AppStatesAdmin> {
  AppCubitAdmin() : super(AppInitialStateAdmin());

  // Data Lists
  List<AdminUserModel> users = [];
  List<AdminAgentModel> agents = [];
  List<AdminStoreModel> storeItems = [];
  List<AdminAdsModel> ads = [];
  List<AdminNotificationLogModel> notifications = [];
  List<AdminSettingsModel> settings = [];
  AdminUserDetailModel? selectedUserDetail;
  AdminUserModel? currentAdmin;
  String? adminToken;
  AdminDashboardStats? dashboardStats;
  AdminUsersPaginationModel? usersPagination;

  // Login
  Future<void> adminLogin({
    required String email,
    required String password,
  }) async {
    emit(AdminLoginLoadingState());
    try {
      final response = await DioHelper.postData(
        url: '/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final loginResponse = AdminLoginResponse.fromJson(response.data);
        currentAdmin = loginResponse.user;
        adminToken = loginResponse.token;
        emit(AdminLoginSuccessState());
      } else {
        emit(AdminLoginErrorState());
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error']?.toString() ??
          e.message ??
          'حدث خطأ غير معروف';
      print('Login Error: $errorMessage');
      emit(AdminLoginErrorState());
    } catch (e) {
      print('Login Error: $e');
      emit(AdminLoginErrorState());
    }
  }

  // Get All Users with Pagination
  Future<void> getAllUsers({int page = 1, int limit = 10}) async {
    emit(AdminGetUsersPaginationLoadingState());
    try {
      final response = await DioHelper.getData(
        url: '/allusers',
        token: adminToken,
        query: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        usersPagination = AdminUsersPaginationModel.fromJson(response.data);
        users = usersPagination!.users;
        emit(AdminGetUsersPaginationSuccessState());
      } else {
        emit(AdminGetUsersPaginationErrorState());
      }
    } catch (e) {
      print('Get Users Pagination Error: $e');
      emit(AdminGetUsersPaginationErrorState());
    }
  }

  // Get All Users (Legacy method for backward compatibility)
  Future<void> getAllUsersLegacy() async {
    emit(AdminGetUsersLoadingState());
    try {
      final response = await DioHelper.getData(
        url: '/allusers?page=1',
        token: adminToken,
      );

      if (response.statusCode == 200) {
        users =
            (response.data as List)
                .map((json) => AdminUserModel.fromJson(json))
                .toList();
        emit(AdminGetUsersSuccessState());
      } else {
        emit(AdminGetUsersErrorState());
      }
    } catch (e) {
      print('Get Users Error: $e');
      emit(AdminGetUsersErrorState());
    }
  }

  // Get Users (Non-Admin)
  Future<void> getUsers() async {
    emit(AdminGetUsersLoadingState());
    try {
      final response = await DioHelper.getData(
        url: '/users',
        token: adminToken,
      );

      if (response.statusCode == 200) {
        users =
            (response.data as List)
                .map((json) => AdminUserModel.fromJson(json))
                .toList();
        emit(AdminGetUsersSuccessState());
      } else {
        emit(AdminGetUsersErrorState());
      }
    } catch (e) {
      print('Get Users Error: $e');
      emit(AdminGetUsersErrorState());
    }
  }

  // Create User
  Future<void> createUser({
    required String name,
    required String email,
    required String phone,
    required String location,
    required String password,
    String role = 'user',
    String? note,
  }) async {
    emit(AdminCreateUserLoadingState());
    try {
      final response = await DioHelper.postData(
        url: '/users',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'location': location,
          'password': password,
          'role': role,
          'note': note,
        },
        token: adminToken,
      );

      if (response.statusCode == 201) {
        final newUser = AdminUserModel.fromJson(response.data);
        users.add(newUser);
        emit(AdminCreateUserSuccessState());
      } else {
        emit(AdminCreateUserErrorState());
      }
    } catch (e) {
      print('Create User Error: $e');
      emit(AdminCreateUserErrorState());
    }
  }

  // Create Always Verified User
  Future<void> createAlwaysVerifiedUser({
    required String name,
    required String email,
    required String phone,
    required String location,
    required String password,
    String role = 'user',
    String? note,
  }) async {
    emit(AdminCreateUserLoadingState());
    try {
      final response = await DioHelper.postData(
        url: '/users/always-verified',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'location': location,
          'password': password,
          'role': role,
          'note': note,
        },
        token: adminToken,
      );

      if (response.statusCode == 201) {
        final newUser = AdminUserModel.fromJson(response.data);
        users.add(newUser);
        emit(AdminCreateUserSuccessState());
      } else {
        emit(AdminCreateUserErrorState());
      }
    } catch (e) {
      print('Create Always Verified User Error: $e');
      emit(AdminCreateUserErrorState());
    }
  }

  // Delete User
  Future<void> deleteUser(int userId) async {
    emit(AdminDeleteUserLoadingState());
    try {
      final response = await DioHelper.deleteData(
        url: '/users/$userId',
        token: adminToken,
      );

      if (response.statusCode == 200) {
        users.removeWhere((user) => user.id == userId);
        emit(AdminDeleteUserSuccessState());
      } else {
        emit(AdminDeleteUserErrorState());
      }
    } catch (e) {
      print('Delete User Error: $e');
      emit(AdminDeleteUserErrorState());
    }
  }

  Future<void> updateUserStatus(int userId, bool isActive) async {
    emit(AdminUpdateUserStatusLoadingState());
    try {
      final response = await DioHelper.patchData(
        url: '/users/$userId/status',
        data: {'isActive': isActive},
        token: adminToken,
      );

      if (response.statusCode == 200) {
        final userIndex = users.indexWhere((user) => user.id == userId);
        if (userIndex != -1) {
          users[userIndex] = AdminUserModel.fromJson(response.data['user']);
        }
        emit(AdminUpdateUserStatusSuccessState());
      } else {
        emit(AdminUpdateUserStatusErrorState());
      }
    } catch (e) {
      print('Update User Status Error: $e');
      emit(AdminUpdateUserStatusErrorState());
    }
  }

  Future<void> updateUserGems(int userId, int gems) async {
    emit(AdminUpdateUserGemsLoadingState());
    try {
      final response = await DioHelper.putData(
        url: '/users/$userId/gems',
        data: {'gems': gems},
        token: adminToken,
      );

      if (response.statusCode == 200) {
        final userIndex = users.indexWhere((user) => user.id == userId);
        if (userIndex != -1) {
          users[userIndex] = AdminUserModel.fromJson(response.data['user']);
        }
        emit(AdminUpdateUserGemsSuccessState());
      } else {
        emit(AdminUpdateUserGemsErrorState());
      }
    } catch (e) {
      print('Update User Gems Error: $e');
      emit(AdminUpdateUserGemsErrorState());
    }
  }

  Future<void> getAgents() async {
    emit(AdminGetAgentsLoadingState());
    try {
      final response = await DioHelper.getData(
        url: '/roleAgents',
        token: adminToken,
      );

      if (response.statusCode == 200) {
        agents =
            (response.data as List)
                .map((json) => AdminAgentModel.fromJson(json))
                .toList();
        emit(AdminGetAgentsSuccessState());
      } else {
        emit(AdminGetAgentsErrorState());
      }
    } catch (e) {
      print('Get Agents Error: $e');
      emit(AdminGetAgentsErrorState());
    }
  }

  Future<void> getStoreItems() async {
    emit(AdminGetStoreItemsLoadingState());
    try {
      final response = await DioHelper.getData(
        url: '/store/id',
        token: adminToken,
      );

      if (response.statusCode == 200) {
        storeItems =
            (response.data as List)
                .map((json) => AdminStoreModel.fromJson(json))
                .toList();
        emit(AdminGetStoreItemsSuccessState());
      } else {
        emit(AdminGetStoreItemsErrorState());
      }
    } catch (e) {
      print('Get Store Items Error: $e');
      emit(AdminGetStoreItemsErrorState());
    }
  }

  Future<void> addStoreItem({
    required int idForSale,
    required int price,
  }) async {
    emit(AdminAddStoreItemLoadingState());
    try {
      final response = await DioHelper.postData(
        url: '/store/add',
        data: {'idForSale': idForSale, 'price': price},
        token: adminToken,
      );

      if (response.statusCode == 201) {
        final newItem = AdminStoreModel.fromJson(response.data['shopItem']);
        storeItems.add(newItem);
        emit(AdminAddStoreItemSuccessState());
      } else {
        emit(AdminAddStoreItemErrorState());
      }
    } catch (e) {
      print('Add Store Item Error: $e');
      emit(AdminAddStoreItemErrorState());
    }
  }

  // Delete Store Item
  Future<void> deleteStoreItem(int shopId) async {
    emit(AdminDeleteStoreItemLoadingState());
    try {
      final response = await DioHelper.deleteData(
        url: '/store/$shopId',
        token: adminToken,
      );

      if (response.statusCode == 200) {
        storeItems.removeWhere((item) => item.id == shopId);
        emit(AdminDeleteStoreItemSuccessState());
      } else {
        emit(AdminDeleteStoreItemErrorState());
      }
    } catch (e) {
      print('Delete Store Item Error: $e');
      emit(AdminDeleteStoreItemErrorState());
    }
  }

  // Generate OTP
  Future<void> generateOtp(String email) async {
    emit(AdminGenerateOtpLoadingState());
    try {
      final response = await DioHelper.postData(
        url: '/otp/generate',
        data: {'email': email},
        token: adminToken,
      );

      if (response.statusCode == 201) {
        emit(AdminGenerateOtpSuccessState());
      } else {
        emit(AdminGenerateOtpErrorState());
      }
    } catch (e) {
      print('Generate OTP Error: $e');
      emit(AdminGenerateOtpErrorState());
    }
  }

  // Verify OTP
  Future<void> verifyOtp({required String email, required String code}) async {
    emit(AdminVerifyOtpLoadingState());
    try {
      final response = await DioHelper.postData(
        url: '/otp/verify',
        data: {'email': email, 'code': code},
        token: adminToken,
      );

      if (response.statusCode == 200) {
        emit(AdminVerifyOtpSuccessState());
      } else {
        emit(AdminVerifyOtpErrorState());
      }
    } catch (e) {
      print('Verify OTP Error: $e');
      emit(AdminVerifyOtpErrorState());
    }
  }

  // Reset Password
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    emit(AdminResetPasswordLoadingState());
    try {
      final response = await DioHelper.postData(
        url: '/admin/reset-password',
        data: {'email': email, 'newPassword': newPassword},
        token: adminToken,
      );

      if (response.statusCode == 200) {
        emit(AdminResetPasswordSuccessState());
      } else {
        emit(AdminResetPasswordErrorState());
      }
    } catch (e) {
      print('Reset Password Error: $e');
      emit(AdminResetPasswordErrorState());
    }
  }

  // Get Dashboard Stats
  Future<void> getDashboardStats() async {
    emit(AdminGetDashboardStatsLoadingState());
    try {
      final response = await DioHelper.getData(
        url: '/admin/stats',
        token: adminToken,
      );

      if (response.statusCode == 200) {
        dashboardStats = AdminDashboardStats.fromJson(response.data);
        emit(AdminGetDashboardStatsSuccessState());
      } else {
        emit(AdminGetDashboardStatsErrorState());
      }
    } catch (e) {
      print('Get Dashboard Stats Error: $e');
      emit(AdminGetDashboardStatsErrorState());
    }
  }

  // Get Ads
  Future<void> getAds() async {
    emit(AdminGetAdsLoadingState());
    try {
      final response = await DioHelper.getData(url: '/ads', token: adminToken);

      if (response.statusCode == 200) {
        ads =
            (response.data as List)
                .map((json) => AdminAdsModel.fromJson(json))
                .toList();
        emit(AdminGetAdsSuccessState());
      } else {
        emit(AdminGetAdsErrorState());
      }
    } catch (e) {
      print('Get Ads Error: $e');
      emit(AdminGetAdsErrorState());
    }
  }

  Future<void> createAd({
    required String title,
    required String description,
    required List selectedImages,
    required BuildContext context,
  }) async {
    emit(AdminCreateAdsLoadingState());

    try {
      FormData formData = FormData.fromMap({
        'name': title,
        'description': description,
      });

      for (var file in selectedImages) {
        if (kIsWeb) {
          // ✅ بالويب XFile.readAsBytes يشتغل
          final bytes = await file.readAsBytes();
          formData.files.add(
            MapEntry(
              "images",
              MultipartFile.fromBytes(
                bytes,
                filename: file.name,
                contentType: MediaType('image', 'jpeg'),
              ),
            ),
          );
        } else {
          // ✅ بالموبايل / ديسكتوب
          formData.files.add(
            MapEntry(
              "images",
              await MultipartFile.fromFile(
                file.path,
                filename: file.path.split('/').last,
                contentType: MediaType('image', 'jpeg'),
              ),
            ),
          );
        }
      }

      final response = await DioHelper.postData(
        url: '/ads',
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      if (response.statusCode == 201) {
        final newAd = AdminAdsModel.fromJson(response.data['ads']);
        ads.add(newAd);
        emit(AdminCreateAdsSuccessState());
      } else {
        emit(AdminCreateAdsErrorState());
      }
    } catch (e) {
      print("Create Ad Error: $e");
      emit(AdminCreateAdsErrorState());
    }
  }

  // Delete Ad
  Future<void> deleteAd(int adId) async {
    emit(AdminDeleteAdsLoadingState());
    try {
      final response = await DioHelper.deleteData(
        url: '/ads/$adId',
        token: adminToken,
      );

      if (response.statusCode == 200) {
        ads.removeWhere((ad) => ad.id == adId);
        emit(AdminDeleteAdsSuccessState());
      } else {
        emit(AdminDeleteAdsErrorState());
      }
    } catch (e) {
      print('Delete Ad Error: $e');
      emit(AdminDeleteAdsErrorState());
    }
  }

  // Get Notifications Log
  Future<void> getNotificationsLog({
    String? role,
    int page = 1,
    int limit = 10,
  }) async {
    emit(AdminGetNotificationsLoadingState());
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};

      if (role != null) {
        queryParams['role'] = role;
      }

      final response = await DioHelper.getData(
        url: '/notifications-log',
        token: adminToken,
        query: queryParams,
      );

      if (response.statusCode == 200) {
        final notificationResponse = AdminNotificationResponseModel.fromJson(
          response.data,
        );
        notifications = notificationResponse.logs;
        emit(AdminGetNotificationsSuccessState());
      } else {
        emit(AdminGetNotificationsErrorState());
      }
    } catch (e) {
      print('Get Notifications Log Error: $e');
      emit(AdminGetNotificationsErrorState());
    }
  }

  // Send Notification
  Future<void> sendNotification({
    required String title,
    required String message,
    String? role,
  }) async {
    emit(AdminSendNotificationLoadingState());
    try {
      final data = {'title': title, 'message': message};

      if (role != null) {
        data['role'] = role;
      }

      final response = await DioHelper.postData(
        url: role != null ? '/send-notification-to-role' : '/send-notification',
        data: data,
        token: adminToken,
      );

      if (response.statusCode == 200) {
        emit(AdminSendNotificationSuccessState());
        // تحديث قائمة الإشعارات بعد الإرسال
        getNotificationsLog();
      } else {
        emit(AdminSendNotificationErrorState());
      }
    } catch (e) {
      print('Send Notification Error: $e');
      emit(AdminSendNotificationErrorState());
    }
  }

  // Get User Detail
  Future<void> getUserDetail(int userId) async {
    emit(AdminGetUserDetailLoadingState());
    try {
      final response = await DioHelper.getData(
        url: '/users/$userId',
        token: adminToken,
      );

      if (response.statusCode == 200) {
        selectedUserDetail = AdminUserDetailModel.fromJson(response.data);
        emit(AdminGetUserDetailSuccessState());
      } else {
        emit(AdminGetUserDetailErrorState());
      }
    } catch (e) {
      print('Get User Detail Error: $e');
      emit(AdminGetUserDetailErrorState());
    }
  }

  // Deposit Sawa
  Future<void> depositSawa(int userId, double amount) async {
    emit(AdminDepositLoadingState());
    try {
      final response = await DioHelper.postData(
        url: '/deposit-sawa',
        data: {'userId': userId, 'amount': amount},
        token: adminToken,
      );

      if (response.statusCode == 200) {
        emit(AdminDepositSuccessState());
        // تحديث تفاصيل المستخدم
        getUserDetail(userId);
      } else {
        emit(AdminDepositErrorState());
      }
    } catch (e) {
      print('Deposit Sawa Error: $e');
      emit(AdminDepositErrorState());
    }
  }

  Future<void> depositJewel(int userId, int amount) async {
    emit(AdminDepositLoadingState());
    try {
      final response = await DioHelper.postData(
        url: '/deposit-jewel',
        data: {'userId': userId, 'amount': amount},
        token: adminToken,
      );

      if (response.statusCode == 200) {
        emit(AdminDepositSuccessState());
        getUserDetail(userId);
      } else {
        emit(AdminDepositErrorState());
      }
    } catch (e) {
      print('Deposit Jewel Error: $e');
      emit(AdminDepositErrorState());
    }
  }

  // Deposit Card
  Future<void> depositCard(int userId, int amount) async {
    emit(AdminDepositLoadingState());
    try {
      final response = await DioHelper.postData(
        url: '/deposit-card',
        data: {'userId': userId, 'amount': amount},
        token: adminToken,
      );

      if (response.statusCode == 200) {
        emit(AdminDepositSuccessState());
        // تحديث تفاصيل المستخدم
        getUserDetail(userId);
      } else {
        emit(AdminDepositErrorState());
      }
    } catch (e) {
      print('Deposit Card Error: $e');
      emit(AdminDepositErrorState());
    }
  }

  Future<void> getAllSettings() async {
    emit(AdminGetSettingsLoadingState());
    try {
      final response = await DioHelper.getData(
        url: '/admin/settings?page=1',
        token: adminToken,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        settings =
            (data['settings'] as List)
                .map((json) => AdminSettingsModel.fromJson(json))
                .toList();

        emit(AdminGetSettingsSuccessState());
      } else {
        emit(AdminGetSettingsErrorState());
      }
    } catch (e) {
      print('Get Settings Error: $e');
      emit(AdminGetSettingsErrorState());
    }
  }

  Future<void> createOrUpdateSetting({
    required String key,
    required String value,
    String? description,
  }) async {
    emit(AdminCreateOrUpdateSettingLoadingState());
    try {
      final response = await DioHelper.postData(
        url: '/admin/settings',
        data: {'key': key, 'value': value, 'description': description},
        token: adminToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final settingsResponse = AdminSettingsResponse.fromJson(response.data);
        final settingIndex = settings.indexWhere((s) => s.key == key);

        if (settingIndex != -1) {
          settings[settingIndex] = settingsResponse.setting;
        } else {
          settings.add(settingsResponse.setting);
        }

        emit(AdminCreateOrUpdateSettingSuccessState());
      } else {
        emit(AdminCreateOrUpdateSettingErrorState());
      }
    } catch (e) {
      print('Create/Update Setting Error: $e');
      emit(AdminCreateOrUpdateSettingErrorState());
    }
  }

  // Get Setting by Key
  Future<void> getSettingByKey(String key) async {
    emit(AdminGetSettingByKeyLoadingState());
    try {
      final response = await DioHelper.getData(
        url: '/admin/settings/$key',
        token: adminToken,
      );

      if (response.statusCode == 200) {
        final setting = AdminSettingsModel.fromJson(response.data);
        final settingIndex = settings.indexWhere((s) => s.key == key);

        if (settingIndex != -1) {
          settings[settingIndex] = setting;
        } else {
          settings.add(setting);
        }

        emit(AdminGetSettingByKeySuccessState());
      } else {
        emit(AdminGetSettingByKeyErrorState());
      }
    } catch (e) {
      print('Get Setting by Key Error: $e');
      emit(AdminGetSettingByKeyErrorState());
    }
  }

  // Room Settings Management
  Future<void> getRoomSettings() async {
    try {
      // جلب إعدادات الغرف
      await getAllSettings();

      // الحصول على إعدادات الغرف المحددة
      final roomCostSetting = settings.firstWhere(
        (setting) => setting.key == 'room_creation_cost',
        orElse:
            () => AdminSettingsModel(
              id: 0,
              key: 'room_creation_cost',
              value: '10',
              description: 'تكلفة إنشاء غرفة جديدة',
              isActive: true,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
      );

      final maxUsersSetting = settings.firstWhere(
        (setting) => setting.key == 'room_max_users',
        orElse:
            () => AdminSettingsModel(
              id: 0,
              key: 'room_max_users',
              value: '50',
              description: 'الحد الأقصى للمستخدمين في الغرفة',
              isActive: true,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
      );

      // إضافة الإعدادات إذا لم تكن موجودة
      if (!settings.any((s) => s.key == 'room_creation_cost')) {
        settings.add(roomCostSetting);
      }
      if (!settings.any((s) => s.key == 'room_max_users')) {
        settings.add(maxUsersSetting);
      }
    } catch (e) {
      print('Get Room Settings Error: $e');
    }
  }

  Future<void> updateRoomSettings({
    required int creationCost,
    required int maxUsers,
  }) async {
    try {
      final response = await DioHelper.postData(
        url: '/admin/room-settings',
        data: {'creation_cost': creationCost, 'max_users': maxUsers},
        token: adminToken,
      );

      if (response.statusCode == 200) {
        // تحديث الإعدادات المحلية
        final roomCostIndex = settings.indexWhere(
          (s) => s.key == 'room_creation_cost',
        );
        if (roomCostIndex != -1) {
          settings[roomCostIndex] = AdminSettingsModel(
            id: settings[roomCostIndex].id,
            key: 'room_creation_cost',
            value: creationCost.toString(),
            description: 'تكلفة إنشاء غرفة جديدة',
            isActive: settings[roomCostIndex].isActive,
            createdAt: settings[roomCostIndex].createdAt,
            updatedAt: DateTime.now(),
          );
        }

        final maxUsersIndex = settings.indexWhere(
          (s) => s.key == 'room_max_users',
        );
        if (maxUsersIndex != -1) {
          settings[maxUsersIndex] = AdminSettingsModel(
            id: settings[maxUsersIndex].id,
            key: 'room_max_users',
            value: maxUsers.toString(),
            description: 'الحد الأقصى للمستخدمين في الغرفة',
            isActive: settings[maxUsersIndex].isActive,
            createdAt: settings[maxUsersIndex].createdAt,
            updatedAt: DateTime.now(),
          );
        }

        emit(AdminUpdateRoomSettingsSuccessState());
      } else {
        emit(AdminUpdateRoomSettingsErrorState());
      }
    } catch (e) {
      print('Update Room Settings Error: $e');
      emit(AdminUpdateRoomSettingsErrorState());
    }
  }

  // Helper Methods
  String getSettingValue(String key, String defaultValue) {
    final setting = settings.firstWhere(
      (s) => s.key == key,
      orElse:
          () => AdminSettingsModel(
            id: 0,
            key: key,
            value: defaultValue,
            isActive: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
    );
    return setting.value;
  }

  // Logout
  Future<void> logout() async {
    if (currentAdmin != null) {
      try {
        await DioHelper.postData(
          url: '/logout',
          data: {'id': currentAdmin!.id},
          token: adminToken,
        );
      } catch (e) {
        print('Logout Error: $e');
      }
    }
    currentAdmin = null;
    adminToken = null;
    users.clear();
    agents.clear();
    storeItems.clear();
    ads.clear();
    notifications.clear();
    settings.clear();
    selectedUserDetail = null;
    dashboardStats = null;
    usersPagination = null;
    emit(AppInitialStateAdmin());
  }
}
