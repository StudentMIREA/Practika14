import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String massage;
  final Timestamp timestamp;

  Message(
      {required this.senderId,
      required this.receiverId,
      required this.massage,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': massage,
      'timestamp': timestamp,
    };
  }
}
