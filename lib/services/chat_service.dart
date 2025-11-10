import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../models/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(
    region: 'us-central1',
  );

  // Send message to AI and save to history
  Future<String> sendMessage(String userId, String userMessage) async {
    try {
      // Call Firebase Function to get AI response
      final callable = _functions.httpsCallable('chatWithAI');
      
      // Add timeout to prevent infinite spinning
      final result = await callable.call({
        'message': userMessage,
        'userId': userId,
      }).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException(
            'Request timed out. The Firebase Function may not be deployed yet.',
          );
        },
      );

      final aiResponse = result.data['response'] as String? ?? 
                         'I apologize, but I encountered an error. Please try again.';

      // Save AI response to Firestore (user message is already saved in chat_screen)
      await saveMessage(userId, aiResponse, false);

      return aiResponse;
    } catch (e) {
      print('Error sending message: $e');
      print('Error type: ${e.runtimeType}');
      // Provide more helpful error messages
      final errorString = e.toString();
      if (errorString.contains('NOT_FOUND') || 
          errorString.contains('not found') ||
          errorString.contains('404')) {
        return 'Function not found. Please check if it\'s deployed to us-central1 region.';
      }
      if (errorString.contains('timeout') || e is TimeoutException) {
        return 'Request timed out. The function may not be responding.';
      }
      if (errorString.contains('PERMISSION_DENIED') || 
          errorString.contains('permission')) {
        return 'Permission denied. Please check Firebase Authentication.';
      }
      if (errorString.contains('UNAUTHENTICATED') || 
          errorString.contains('unauthenticated')) {
        return 'Not authenticated. Please sign in.';
      }
      // Return full error for debugging
      return 'Error: $errorString';
    }
  }

  // Save message to Firestore
  Future<void> saveMessage(String userId, String content, bool isFromUser) async {
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

