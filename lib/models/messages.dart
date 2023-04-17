import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderType;
  final String recipientId;
  final String content;
  final DateTime timestamp;

  Message({
    required this.senderId,
    required this.senderType,
    required this.recipientId,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderType': senderType,
      'recipientId': recipientId,
      'content': content,
      'timestamp': timestamp,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      senderType: map['senderType'],
      recipientId: map['recipientId'],
      content: map['content'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
