# نظام غرف المحادثة - Flutter Frontend

## نظرة عامة
هذا هو الفرونت إند لمشروع غرف المحادثة الجماعية المبني باستخدام Flutter مع الـ MVC pattern. يتكامل مع الباك إند Node.js + Socket.IO.

## الميزات
- ✅ إنشاء غرف محادثة جديدة
- ✅ الانضمام إلى الغرف الموجودة
- ✅ الدردشة المباشرة في الوقت الفعلي
- ✅ مؤشر الكتابة
- ✅ قائمة المستخدمين المتصلين
- ✅ إحصائيات الغرف
- ✅ تصفية الغرف حسب الفئة
- ✅ حذف الغرف (للمنشئ فقط)

## المتطلبات
- Flutter SDK 3.7.0+
- Dart 3.0+
- Node.js Backend (Socket.IO Server)

## المكتبات المطلوبة
```yaml
dependencies:
  socket_io_client: ^2.0.3+1
  http: ^1.1.0
  flutter_bloc: ^8.0.0
  dio: ^5.0.0
  shared_preferences: ^2.0.0
```

## التثبيت والإعداد

### 1. تثبيت المكتبات
```bash
flutter pub get
```

### 2. تكوين الاتصال بالباك إند
قم بتعديل عنوان السيرفر في الملفات التالية:

**lib/core/chat_service.dart:**
```dart
static const String baseUrl = 'http://your-server-ip:1300';
```

**lib/core/socket_service.dart:**
```dart
_socket = IO.io('http://your-server-ip:1300', <String, dynamic>{
```

### 3. إضافة شاشة الدردشة إلى التطبيق
أضف زر أو قائمة للوصول إلى شاشة الدردشة في التطبيق الرئيسي:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => ChatMainScreen()),
);
```

## هيكل المشروع

```
lib/
├── core/
│   ├── chat_service.dart      # خدمة API للغرف
│   └── socket_service.dart    # خدمة Socket.IO
├── model/
│   ├── RoomModel.dart         # نموذج الغرفة
│   └── MessageModel.dart      # نموذج الرسالة
├── controllar/
│   ├── cubit.dart             # منطق الأعمال (محدث)
│   └── states.dart            # حالات التطبيق (محدث)
└── view/
    └── chat/
        ├── chat_main_screen.dart      # الشاشة الرئيسية
        ├── chat_rooms_screen.dart      # قائمة الغرف
        ├── create_room_screen.dart     # إنشاء غرفة
        ├── chat_room_screen.dart       # غرفة المحادثة
        └── widgets/
            ├── message_bubble.dart     # فقاعة الرسالة
            └── users_list.dart        # قائمة المستخدمين
```

## الاستخدام

### 1. تهيئة Socket.IO
```dart
// في Cubit
void initializeSocket() {
  if (token != null) {
    SocketService.initialize(token!, int.parse(id), name);
    SocketService.connect();
  }
}
```

### 2. جلب الغرف
```dart
AppCubit.get(context).getRooms();
```

### 3. إنشاء غرفة جديدة
```dart
AppCubit.get(context).createRoom(
  name: 'اسم الغرفة',
  description: 'وصف الغرفة',
  cost: 100,
  maxUsers: 50,
  category: 'general',
  context: context,
);
```

### 4. الانضمام إلى غرفة
```dart
AppCubit.get(context).joinRoom(roomId);
```

### 5. إرسال رسالة
```dart
AppCubit.get(context).sendMessage('محتوى الرسالة');
```

## حالات التطبيق (States)

### حالات الغرف
- `ChatRoomsLoadingState` - تحميل الغرف
- `ChatRoomsSuccessState` - نجح جلب الغرف
- `ChatRoomsErrorState` - خطأ في جلب الغرف

### حالات إنشاء الغرفة
- `ChatCreateRoomLoadingState` - إنشاء الغرفة
- `ChatCreateRoomSuccessState` - نجح إنشاء الغرفة
- `ChatCreateRoomErrorState` - خطأ في إنشاء الغرفة

### حالات المحادثة
- `ChatNewMessageState` - رسالة جديدة
- `ChatUserTypingState` - مؤشر الكتابة
- `ChatRoomUsersUpdatedState` - تحديث المستخدمين

## الأمان
- يتم التحقق من التوكن في كل طلب API
- يتم التحقق من صلاحيات المستخدم (حذف الغرفة للمنشئ فقط)
- يتم التحقق من النقاط الكافية لإنشاء الغرفة

## استكشاف الأخطاء

### مشاكل الاتصال
1. تأكد من تشغيل الباك إند
2. تحقق من عنوان IP ورقم المنفذ
3. تأكد من صحة التوكن

### مشاكل Socket.IO
1. تحقق من إعدادات CORS في الباك إند
2. تأكد من صحة التوكن في Socket.IO
3. تحقق من اتصال الإنترنت

### مشاكل التطبيق
1. تأكد من تثبيت جميع المكتبات
2. تحقق من إعدادات Flutter
3. امسح cache التطبيق

## المساهمة
1. Fork المشروع
2. أنشئ branch جديد
3. أضف التحديثات
4. أرسل Pull Request

## الترخيص
هذا المشروع مرخص تحت رخصة MIT.

## الدعم
للدعم الفني، يرجى التواصل عبر:
- Email: support@example.com
- GitHub Issues: [رابط المشروع]
