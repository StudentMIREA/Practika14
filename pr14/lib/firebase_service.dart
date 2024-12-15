import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pr14/api_service.dart';
import 'package:pr14/auth/auth_service.dart';
import 'package:pr14/model/massege.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final ApiService apiService = ApiService();

  final ip = '192.168.1.121';

  Future<void> sendMessage(String mail, String massege) async {
    try {
      final userEmail = AuthService().getCurrentUserEmail();
      final Timestamp currentTime = Timestamp.now();

      Message newMessage = Message(
          senderId: userEmail!,
          receiverId: mail,
          massage: massege,
          timestamp: currentTime);

      List<String> ids = [userEmail, mail];
      ids.sort();
      String chatRoomId = ids.join("_");

      await _firebaseFirestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(newMessage.toMap());
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Stream<QuerySnapshot> getMessages(String userMail, String anotherMail) {
    List<String> ids = [userMail, anotherMail];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
