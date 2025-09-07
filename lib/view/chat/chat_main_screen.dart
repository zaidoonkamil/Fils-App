import 'package:fils/core/styles/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controllar/cubit.dart';
import '../../controllar/states.dart';
import '../../core/socket_service.dart';
import '../../core/widgets/appBar.dart';
import '../../model/RoomModel.dart';
import 'chat_rooms_screen.dart';
import 'create_room_screen.dart';
import 'chat_room_screen.dart';

class ChatMainScreen extends StatefulWidget {
  const ChatMainScreen({Key? key}) : super(key: key);

  @override
  State<ChatMainScreen> createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> {
  @override
  void initState() {
    super.initState();
    // تهيئة Socket.IO عند فتح شاشة الدردشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppCubit.get(context).initializeSocket();
      AppCubit.get(context).getRooms();
    });
  }

  @override
  void dispose() {
    // قطع الاتصال عند الخروج من الشاشة
    AppCubit.get(context).disconnectSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is ChatRoomsErrorState) {
          // تم التعامل مع الخطأ في Cubit
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                AppbarBack(),
                SizedBox(height: 16,),
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.blue[50],
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.roofing,
                          title: 'الغرف',
                          value: AppCubit.get(context).rooms?.length.toString() ?? '0',
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.people,
                          title: 'المستخدمون',
                          value: AppCubit.get(context).roomUsers.length.toString(),
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.message,
                          title: 'الرسائل',
                          value: AppCubit.get(context).messages.length.toString(),
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: state is ChatRoomsLoadingState
                      ? Center(child: CircularProgressIndicator())
                      : AppCubit.get(context).rooms == null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'لا توجد غرف متوفرة',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'قم بإنشاء غرفة جديدة للبدء',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.all(16),
                              itemCount: AppCubit.get(context).rooms!.length,
                              itemBuilder: (context, index) {
                                final room = AppCubit.get(context).rooms![index];
                                return _buildRoomCard(context, room);
                              },
                            ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: secoundColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateRoomScreen()),
                );
              },
              icon: Icon(Icons.add,color: Colors.white,),
              label: Text('إنشاء غرفة',style: TextStyle(color: Colors.white),),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(BuildContext context, RoomModel room) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(width: 1)
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          AppCubit.get(context).joinRoom(room.id);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoomScreen(room: room),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'انضم',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      room.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      room.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.people, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          '${room.currentUsers}/${room.maxUsers}',
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.diamond, size: 16, color: Colors.amber),
                        SizedBox(width: 4),
                        Text(
                          '${room.cost}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: secoundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(room.category),
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'gaming':
        return Colors.purple;
      case 'music':
        return Colors.blue;
      case 'sports':
        return Colors.green;
      case 'technology':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'gaming':
        return Icons.games;
      case 'music':
        return Icons.music_note;
      case 'sports':
        return Icons.sports_soccer;
      case 'technology':
        return Icons.computer;
      default:
        return Icons.chat;
    }
  }
}
