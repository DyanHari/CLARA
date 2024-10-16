import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'message.dart';


class ChatHistoryManager {
  static final ChatHistoryManager _instance = ChatHistoryManager._internal();

  factory ChatHistoryManager() {
    return _instance;
  }

  ChatHistoryManager._internal() {
    _initChatHistory();
  }

  List<Message> _chatHistory = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _uid;

  Future<void> _initChatHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    _uid = user?.uid;
  }

  List<Message> get chatHistory => _chatHistory;

  Future<void> addMessage(Message message) async {
    _chatHistory.add(message);
    await _saveChatHistory();
  }

  Future<void> _saveChatHistory() async {
    if (_uid == null) {
      print('User is not signed in, cannot save chat history');
      return;
    }

    final batch = _firestore.batch();
    final chatHistoryRef = _firestore.collection('chatHistories').doc(_uid);
    batch.set(
      chatHistoryRef,
      {'messages': _chatHistory.map((m) => m.toMap()).toList()},
      SetOptions(merge: true),
    );

    try {
      await batch.commit();
      print('Chat history saved successfully');
    } catch (e) {
      print('Error saving chat history: $e');
    }
  }

  Future<void> loadChatHistory() async {
    _chatHistory.clear(); // Clear the existing chat history

    if (_uid == null) {
      print('User is not signed in, cannot load chat history');
      return;
    }

    try {
      final snapshot =
      await _firestore.collection('chatHistories').doc(_uid).get();

      if (snapshot.exists) {
        final data = snapshot.data();
        _chatHistory = (data?['messages'] as List<dynamic>?)
            ?.map((messageData) {
          final message = Message(
            text: messageData['text'],
            isUser: messageData['isUser'],
            timestamp: DateTime.fromMillisecondsSinceEpoch(
                messageData['timestamp']),
          );
          return message;
        }).toList() ??
            [];
        print('Loaded ${_chatHistory.length} messages');
      } else {
        print('No chat history found for user $_uid');
      }
    } catch (e) {
      print('Error loading chat history: $e');
    }
  }

  Future<void> clearChatHistory() async {
    _chatHistory.clear();
  }

  Future<void> deleteConversation() async {
    _chatHistory.clear();
    if (_uid == null) {
      print('User is not signed in, cannot delete conversation');
      return;
    }

    try {
      await _firestore.collection('chatHistories').doc(_uid).delete();
      print('Conversation deleted successfully');
    } catch (e) {
      print('Error deleting conversation: $e');
    }
  }
}
