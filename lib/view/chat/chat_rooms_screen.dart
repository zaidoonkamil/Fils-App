import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controllar/cubit.dart';
import '../../controllar/states.dart';
import '../../model/RoomModel.dart';
import 'chat_room_screen.dart';
import 'create_room_screen.dart';

class ChatRoomsScreen extends StatelessWidget {
  const ChatRoomsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is ChatRoomsErrorState) {
          // تم التعامل مع الخطأ في Cubit
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('غرف المحادثة'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  AppCubit.get(context).getRooms();
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // فلاتر الغرف
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'فئة الغرفة',
                          border: OutlineInputBorder(),
                        ),
                        value: null,
                        items: [
                          DropdownMenuItem(value: null, child: Text('جميع الفئات')),
                          DropdownMenuItem(value: 'general', child: Text('عام')),
                          DropdownMenuItem(value: 'gaming', child: Text('ألعاب')),
                          DropdownMenuItem(value: 'music', child: Text('موسيقى')),
                          DropdownMenuItem(value: 'sports', child: Text('رياضة')),
                          DropdownMenuItem(value: 'technology', child: Text('تقنية')),
                        ],
                        onChanged: (value) {
                          AppCubit.get(context).getRooms(category: value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              // قائمة الغرف
              Expanded(
                child: state is ChatRoomsLoadingState
                    ? Center(child: CircularProgressIndicator())
                    : AppCubit.get(context).rooms == null
                        ? Center(child: Text('لا توجد غرف متوفرة'))
                        : ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: AppCubit.get(context).rooms!.length,
                            itemBuilder: (context, index) {
                              final room = AppCubit.get(context).rooms![index];
                              return RoomCard(room: room);
                            },
                          ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateRoomScreen()),
              );
            },
            child: Icon(Icons.add),
            tooltip: 'إنشاء غرفة جديدة',
          ),
        );
      },
    );
  }
}

class RoomCard extends StatelessWidget {
  final RoomModel room;

  const RoomCard({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // الانضمام إلى الغرفة
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      room.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(room.category),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getCategoryText(room.category),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                room.description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        '${room.currentUsers}/${room.maxUsers}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
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
              if (room.creator != null) ...[
                SizedBox(height: 8),
                Text(
                  'المنشئ: ${room.creator!.name}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
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

  String _getCategoryText(String category) {
    switch (category) {
      case 'general':
        return 'عام';
      case 'gaming':
        return 'ألعاب';
      case 'music':
        return 'موسيقى';
      case 'sports':
        return 'رياضة';
      case 'technology':
        return 'تقنية';
      default:
        return 'عام';
    }
  }
}
