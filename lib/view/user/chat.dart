import 'package:fils/controllar/chat/controler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/ navigation/navigation.dart';
import '../../../core/widgets/circular_progress.dart';
import '../../core/styles/themes.dart';
import '../../core/widgets/appBar.dart';
import '../../core/widgets/background.dart';

class Chat extends StatefulWidget {
  final int userId;
  const Chat({super.key, required this.userId});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
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
      create: (_) => ChatCubit(widget.userId),
      child: BlocListener<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is ChatLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
          }
          if (state is ChatError) {

          }
        },
        child: SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                Background(),
                Column(
                  children: [
                    AppbarBack(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: BlocBuilder<ChatCubit, ChatState>(
                          builder: (context, state) {
                            if (state is ChatConnecting ||state is ChatLoading) {
                              return const Center(child: CircularProgress());
                            } else if (state is ChatLoaded) {
                              var messages = state.messages;
                              return ListView.builder(
                                controller: _scrollController,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  final msg = messages[index];
                                  final isSender = msg['senderId'] == widget.userId;
                                  return Align(
                                    alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        isSender == false? Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.blueAccent,
                                              child: Text(
                                                'اد'.toUpperCase(),
                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                          ],
                                        ):Container(),
                                        Flexible(
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(vertical: 4),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: isSender ? primaryColor : Colors.grey[300],
                                              borderRadius: isSender ?const BorderRadius.only(
                                                topLeft: Radius.circular(14),
                                                topRight: Radius.circular(14),
                                                bottomLeft: Radius.circular(14),
                                              ):BorderRadius.only(
                                                topLeft: Radius.circular(14),
                                                topRight: Radius.circular(14),
                                                bottomRight: Radius.circular(14),
                                              ),
                                            ),
                                            child: Text(
                                              msg['message'],
                                              style: TextStyle(
                                                color: isSender ? Colors.white : Colors.black87,
                                              ),
                                              textAlign: TextAlign.end,
                                              softWrap: true,
                                            ),
                                          ),
                                        ),
                                        isSender? Row(
                                          children: [
                                            const SizedBox(width: 8),
                                            Image.asset(
                                              'assets/images/Mask group (3).png',
                                              width: 40,
                                              height: 40,
                                            ),
                                          ],
                                        ):Container(),

                                      ],
                                    ),
                                  );
                                },
                              );
                            } else if (state is ChatError) {
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

  void _send(BuildContext context) {
    final text = _controller.text;
    if (text.trim().isEmpty) return;

    // إرسال الرسالة مباشرة عبر Cubit
    context.read<ChatCubit>().sendMessage(text);
    _controller.clear();

    // تمرير الـ scroll إلى الأسفل
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<ChatCubit>().messages.isNotEmpty) {
        final chatState = context.read<ChatCubit>();
        // ScrollController من الويجت الرئيسي
        // تأكد أن `_scrollController` يمكن الوصول له
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        color: secoundColor,
        child: Row(
          children: [
            InkWell(
                onTap: () => _send(context),
                child: Image.asset('assets/images/akar-icons_send (1).png')),
            SizedBox(width: 8,),
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(color: Colors.white),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  hintText: '... اكتب رسالتك',
                  hintStyle: TextStyle(color: Colors.white),
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
