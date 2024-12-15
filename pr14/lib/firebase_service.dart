import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pr14/auth/auth_service.dart';
import 'package:pr14/model/massege.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

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

  Future<List<String>> getUniqueSenders() async {
    try {
      // Получаем все сообщения из коллекции chat_rooms
      final chatRoomsSnapshot =
          await _firebaseFirestore.collection('chat_rooms').get();

      // Хранение уникальных отправителей и их временных меток
      Map<String, Timestamp> sendersMap = {};

      for (var chatRoom in chatRoomsSnapshot.docs) {
        final messagesSnapshot = await chatRoom.reference
            .collection('messages')
            .orderBy('timestamp')
            .get();

        for (var message in messagesSnapshot.docs) {
          final senderId = message.data()['senderId'];
          final timestamp = message.data()['timestamp'];

          // Сохраняем только уникальных отправителей с последней временной меткой
          if (!sendersMap.containsKey(senderId) ||
              sendersMap[senderId]!.compareTo(timestamp) < 0) {
            sendersMap[senderId] = timestamp;
          }
        }
      }

      // Сортируем отправителей по убыванию даты
      final sortedSenders = sendersMap.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      // Возвращаем список уникальных отправителей
      return sortedSenders.map((entry) => entry.key).toList();
    } catch (e) {
      throw Exception('Error fetching unique senders: $e');
    }
  }
}
