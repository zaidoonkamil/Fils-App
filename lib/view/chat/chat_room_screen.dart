import 'package:fils/core/%20navigation/navigation.dart';
import 'package:fils/core/styles/themes.dart';
import 'package:fils/core/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controllar/cubit.dart';
import '../../controllar/states.dart';
import '../../model/RoomModel.dart';
import 'widgets/message_bubble.dart';
import 'widgets/users_list.dart';

class ChatRoomScreen extends StatefulWidget {
  final RoomModel room;

  const ChatRoomScreen({Key? key, required this.room}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;
  bool _isSending = false; // منع الإرسال المكرر

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppCubit.get(context).getRoomMessages(widget.room.id);
    });
    _scrollToBottom();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty && !_isSending) {
      setState(() {
        _isSending = true;
      });

      AppCubit.get(context).sendMessage(message);
      _messageController.clear();

      Future.delayed(const Duration(milliseconds: 300), () {
        _scrollToBottom();
      });

      // إعادة تعيين حالة الإرسال بعد ثانية واحدة
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isSending = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is ChatMessagesSuccessState || state is ChatNewMessageState) {
          _scrollToBottom();
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: secoundColor,
              leading: GestureDetector(
                  onTap: () {
                    navigateBack(context);
                  },
                  child: Icon(Icons.arrow_back_ios_new, color: Colors.white,)),
              centerTitle: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.room.name, style: TextStyle(color: Colors.white),),
                  Text(
                    '${widget.room.currentUsers}/${widget.room
                        .maxUsers} مستخدم',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
              actionsIconTheme: IconThemeData(color: Colors.white),
              actions: [
                if (widget.room.creatorId.toString() == id)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        _showDeleteDialog();
                      }
                    },
                    itemBuilder: (context) =>
                    [
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('حذف الغرفة'),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            body: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  color: Colors.grey[100],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          widget.room.description,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.end,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.info_outline, size: 16),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Expanded(
                              child: state is ChatMessagesLoadingState
                                  ? Center(child: CircularProgressIndicator())
                                  : AppCubit
                                  .get(context)
                                  .messages
                                  .isEmpty
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
                                      'لا توجد رسائل بعد',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'ابدأ المحادثة الآن!',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : ListView.builder(
                                controller: _scrollController,
                                padding: EdgeInsets.all(16),
                                itemCount: AppCubit
                                    .get(context)
                                    .messages
                                    .length,
                                itemBuilder: (context, index) {
                                  final message = AppCubit
                                      .get(context)
                                      .messages[index];
                                  final isOwnMessage = message.user!.id
                                      .toString() == id;
                                  return MessageBubble(
                                    message: message,
                                    isOwnMessage: isOwnMessage,
                                  );
                                },
                              ),
                            ),
                            // if (AppCubit.get(context).isTyping)
                            //   Container(
                            //     padding: EdgeInsets.all(8),
                            //     child: Text(
                            //       '${AppCubit.get(context).typingUser} يكتب...',
                            //       style: TextStyle(
                            //         color: Colors.grey[600],
                            //         fontStyle: FontStyle.italic,
                            //       ),
                            //     ),
                            //   ),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  top: BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      textAlign: TextAlign.right,
                                      controller: _messageController,
                                      decoration: InputDecoration(
                                        hintText: 'اكتب هنا',
                                        hintTextDirection: TextDirection.rtl,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              25),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                      ),
                                      maxLines: null,
                                      textInputAction: TextInputAction.send,
                                      onTap: () {
                                        Future.delayed(const Duration(
                                            milliseconds: 400), () {
                                          _scrollToBottom();
                                        });
                                      },
                                      onChanged: (text) {
                                        if (!_isTyping && text.isNotEmpty) {
                                          _isTyping = true;
                                          AppCubit.get(context).sendTyping(
                                              true);
                                        } else if (_isTyping && text.isEmpty) {
                                          _isTyping = false;
                                          AppCubit.get(context).sendTyping(
                                              false);
                                        }
                                      },
                                      onSubmitted: (_) {
                                        if (!_isSending) _sendMessage();
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  CircleAvatar(
                                    backgroundColor: Theme
                                        .of(context)
                                        .primaryColor,
                                    child: _isSending
                                        ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<
                                            Color>(Colors.white),
                                      ),
                                    )
                                        : IconButton(
                                      icon: Icon(
                                          Icons.send, color: Colors.white),
                                      onPressed: _sendMessage,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        child: UsersList(
                          users: AppCubit
                              .get(context)
                              .roomUsers,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void _showDeleteDialog() {
    final cubit = AppCubit.get(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حذف الغرفة'),
        content: Text('هل أنت متأكد من حذف هذه الغرفة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.deleteRoom(widget.room.id, context);
              Navigator.pop(context);
            },
            child: Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}