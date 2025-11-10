import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../models/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  // Send message to AI and save to history
  Future<String> sendMessage(String userId, String userMessage) async {
    try {
      // Call Firebase Function to get AI response
      final callable = _functions.httpsCallable('chatWithAI');
      final result = await callable.call({
        'message': userMessage,
        'userId': userId,
      });

      final aiResponse = result.data['response'] as String? ?? 
                         'I apologize, but I encountered an error. Please try again.';

      // Save user message to Firestore
      await _saveMessage(userId, userMessage, true);

      // Save AI response to Firestore
      await _saveMessage(userId, aiResponse, false);

      return aiResponse;
    } catch (e) {
      print('Error sending message: $e');
      return 'An error occurred. Please try again.';
    }
  }

  // Save message to Firestore
  Future<void> _saveMessage(String userId, String content, bool isFromUser) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('messages')
          .add({
        'content': content,
        'isFromUser': isFromUser,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving message: $e');
    }
  }

  // Get chat history for a user
  Stream<List<MessageModel>> getChatHistory(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(50) // Get last 50 messages
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return MessageModel(
          id: doc.id,
          content: data['content'] ?? '',
          isFromUser: data['isFromUser'] ?? true,
          timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp)); // Sort chronologically
    });
  }
}

