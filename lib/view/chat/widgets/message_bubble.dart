import 'package:flutter/material.dart';
import '../../../model/MessageModel.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isOwnMessage;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isOwnMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 8,
          left: isOwnMessage ? 64 : 8,
          right: isOwnMessage ? 8 : 64,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isOwnMessage 
              ? Theme.of(context).primaryColor 
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.user?.name ?? 'مستخدم غير معروف',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isOwnMessage ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              message.content,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: isOwnMessage ? Colors.white : Colors.black87,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.createdAt),
                  style: TextStyle(
                    fontSize: 10,
                    color: isOwnMessage ? Colors.white70 : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }
}
