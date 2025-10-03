import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ navigation/navigation.dart';
import '../controllar/chat/chat_admin.dart';
import 'chat.dart';

class AllUserChatAdmin extends StatelessWidget {
  const AllUserChatAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminUsersCubit(),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      textAlign: TextAlign.right,
                      'دردشة المدير مع المستخدمين',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<AdminUsersCubit, AdminUsersState>(
                  builder: (context, state) {
                    if (state is AdminUsersInitial ||
                        state is AdminUsersLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is AdminUsersLoaded) {
                      final users = state.users;
                      if (users.isEmpty) {
                        return const Center(
                          child: Text('لا يوجد مستخدمين حتى الآن'),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final u = users[index];
                          final user = u['user'];
                          final lastMsg = u['lastMessage'];
                          return GestureDetector(
                            onTap: () {
                              navigateTo(
                                context,
                                ChatAdmin(userId: users[index]['user']['id']),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              elevation: 2,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          user['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          lastMsg != null
                                              ? lastMsg['message']
                                              : 'لا توجد رسائل بعد',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 8),
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.blueAccent,
                                      child: Text(
                                        user['name'][0].toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is AdminUsersError) {
                      return Center(child: Text(state.message));
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
