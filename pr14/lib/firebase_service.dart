import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pr14/api_service.dart';
import 'package:pr14/auth/auth_service.dart';
import 'package:pr14/model/massege.dart';
import 'package:pr14/model/person.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final ApiService apiService = ApiService();

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

  Future<List<Person>> getUniqueSenders() async {
    try {
      // Получаем все сообщения из Firebase
      final messagesSnapshot =
          await _firebaseFirestore.collectionGroup('messages').get();

      // Создаем список для хранения уникальных отправителей
      Map<String, Timestamp> sendersMap = {};

      for (var doc in messagesSnapshot.docs) {
        final messageData = doc.data();
        final senderId = messageData['senderId'];
        final timestamp = messageData['timestamp'];

        // Проверяем, если отправитель уже есть в списке
        if (!sendersMap.containsKey(senderId)) {
          sendersMap[senderId] =
              timestamp; // Сохраняем время последнего сообщения
        } else {
          // Обновляем время, если новое сообщение позже
          if (timestamp.compareTo(sendersMap[senderId]!) > 0) {
            sendersMap[senderId] = timestamp;
          }
        }
      }

      // Получаем всех пользователей с сервера
      List<Person> allUsersList = await apiService.allUsers();

      // Фильтруем пользователей по уникальным отправителям и сортируем по времени
      List<Person> uniqueSenders = allUsersList
          .where((user) => sendersMap.containsKey(user.mail))
          .toList();

      // Сортируем по времени последнего сообщения (по убыванию)
      uniqueSenders
          .sort((a, b) => sendersMap[b.mail]!.compareTo(sendersMap[a.mail]!));

      return uniqueSenders;
    } catch (e) {
      throw Exception('Error fetching unique senders: $e');
    }
  }
}
