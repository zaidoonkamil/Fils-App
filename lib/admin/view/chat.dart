import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/background.dart';
import '../../../../core/widgets/circular_progress.dart';
import '../controllar/chat/chat_admin.dart';

class ChatAdmin extends StatefulWidget {
  final int userId;
  const ChatAdmin({super.key, required this.userId});

  @override
  State<ChatAdmin> createState() => _ChatAdminState();
}

class _ChatAdminState extends State<ChatAdmin> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => AdminChatCubit(
            adminId: int.parse('10014'),
            userId: widget.userId,
          ),
      child: BlocListener<AdminChatCubit, AdminChatState>(
        listener: (context, state) {
          if (state is AdminChatLoaded) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _scrollToBottom(),
            );
          }
          if (state is AdminChatError) {}
        },
        child: SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                Background(),
                Column(
                  children: [
                    Container(
                      color: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(width: 28),
                            const Text(
                              'دردش مع المستخدم',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // داخل لوحة التحكم، لا نعود بل ننقل إلى القسم الرئيسي
                                Navigator.of(
                                  context,
                                ).popUntil((route) => route.isFirst);
                              },
                              child: const Icon(
                                Icons.home,
                                size: 32,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: BlocBuilder<AdminChatCubit, AdminChatState>(
                          builder: (context, state) {
                            if (state is AdminChatConnecting ||
                                state is AdminChatLoading) {
                              return const Center(child: CircularProgress());
                            } else if (state is AdminChatLoaded) {
                              var messages = state.messages;

                              // فلترة الرسائل لتجنب التداخل
                              messages =
                                  messages
                                      .where(
                                        (msg) =>
                                            msg['senderId'] == widget.userId ||
                                            msg['senderId'] ==
                                                int.parse(
                                                  '10014',
                                                ), // معرف المدير
                                      )
                                      .toList();

                              return ListView.builder(
                                controller: _scrollController,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  final msg = messages[index];
                                  final isUserMessage =
                                      msg['senderId'] != widget.userId;
                                  final messageText = msg['message'] ?? '';
                                  return Align(
                                    alignment:
                                        isUserMessage
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        isUserMessage == false
                                            ? Row(
                                              children: [
                                                const SizedBox(width: 8),
                                                Image.asset(
                                                  'assets/images/Mask group (3).png',
                                                  width: 40,
                                                  height: 40,
                                                ),
                                              ],
                                            )
                                            : Container(),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 8,
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          constraints: BoxConstraints(
                                            maxWidth:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.7,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                isUserMessage
                                                    ? Colors.blue
                                                    : Colors.grey[300],
                                            borderRadius:
                                                isUserMessage
                                                    ? const BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                        14,
                                                      ),
                                                      topRight: Radius.circular(
                                                        14,
                                                      ),
                                                      bottomLeft:
                                                          Radius.circular(14),
                                                    )
                                                    : BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                        14,
                                                      ),
                                                      topRight: Radius.circular(
                                                        14,
                                                      ),
                                                      bottomRight:
                                                          Radius.circular(14),
                                                    ),
                                          ),
                                          child: Text(
                                            messageText,
                                            style: TextStyle(
                                              color:
                                                  isUserMessage
                                                      ? Colors.white
                                                      : Colors.black87,
                                            ),
                                            textAlign: TextAlign.right,
                                            softWrap: true,
                                          ),
                                        ),
                                        isUserMessage
                                            ? Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                      Colors.blueAccent,
                                                  child: Text(
                                                    'اد'.toUpperCase(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                              ],
                                            )
                                            : Container(),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else if (state is AdminChatError) {
                              return Center(child: Text(state.message));
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    _MessageInput(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageInput extends StatefulWidget {
  @override
  State<_MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<_MessageInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isSending = false; // منع الإرسال المكرر

  void _send(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _isSending = true;
    });

    // إرسال الرسالة مرة واحدة فقط
    context.read<AdminChatCubit>().sendMessage(text);
    _controller.clear();

    // إعادة تعيين حالة الإرسال بعد ثانية واحدة
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        color: Colors.grey[200],
        child: Row(
          children: [
            InkWell(
              onTap: _isSending ? null : () => _send(context),
              child:
                  _isSending
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : Image.asset('assets/images/akar-icons_send.png'),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _controller,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                onSubmitted: (text) {
                  if (text.trim().isNotEmpty && !_isSending) {
                    _send(context);
                  }
                },
                decoration: const InputDecoration(
                  hintText: '... اكتب رسالتك',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
