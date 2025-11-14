import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/chat_service.dart';
import '../services/auth_service.dart';
import '../models/message_model.dart';

class ChatScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentThemeMode;

  const ChatScreen({
    super.key,
    required this.onThemeChanged,
    required this.currentThemeMode,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  bool _isLoading = false;
  String? _userId;
  String? _userLocation;
  List<MessageModel> _messages = [];

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    print('Initializing auth...');
    try {
      final user = await _authService.signInAnonymously();
      if (user != null) {
        print('Auth successful, user ID: ${user.uid}');
        setState(() {
          _userId = user.uid;
        });
        _detectLocation();
      } else {
        print('Auth failed: user is null');
      }
    } catch (e) {
      print('Auth error: $e');
    }
  }

  Future<void> _detectLocation() async {
    try {
      // Try to detect location from browser language
      // For now, we'll use a simple approach - you can enhance this later
      // with actual geolocation API or IP-based detection
      if (mounted) {
        final language = Localizations.localeOf(context).languageCode;
        setState(() {
          if (language == 'ko') {
            _userLocation = 'Korea';
          } else {
            _userLocation = 'Unknown';
          }
        });
        // Send welcome message after location is detected
        _sendWelcomeMessage();
      }
    } catch (e) {
      print('Error detecting location: $e');
      if (mounted) {
        setState(() {
          _userLocation = 'Unknown';
        });
        _sendWelcomeMessage();
      }
    }
  }

  Future<void> _sendWelcomeMessage() async {
    if (_userId == null) return;
    
    // Check if there are existing messages
    try {
      final messagesSnapshot = await _chatService.getChatHistory(_userId!)
          .first
          .timeout(const Duration(seconds: 2));
      
      // If there are already messages, don't send welcome
      if (messagesSnapshot.isNotEmpty) {
        return;
      }
    } catch (e) {
      print('Error checking message history: $e');
      // Continue to send welcome message if check fails
    }
    
    // Get welcome message from i18n based on current locale
    final welcomePrompt = AppLocalizations.of(context)!.welcomeMessage;
    
    // Save welcome message to Firestore
    try {
      await _chatService.saveMessage(_userId!, welcomePrompt, false);
      print('Welcome message sent: $welcomePrompt');
    } catch (e) {
      print('Error sending welcome message: $e');
    }
  }

  Future<void> _sendMessage() async {
    print('_sendMessage called');
    print('Message text: ${_messageController.text}');
    print('User ID: $_userId');
    
    if (_messageController.text.trim().isEmpty) {
      print('Message is empty, returning');
      return;
    }
    
    if (_userId == null) {
      print('User ID is null, returning');
      return;
    }

    final message = _messageController.text.trim();
    print('Sending message: $message');
    _messageController.clear();

    // Save user message immediately to Firestore
    try {
      await _chatService.saveMessage(_userId!, message, true);
    } catch (e) {
      print('Error saving user message: $e');
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get current messages for conversation history
      final currentMessages = List<MessageModel>.from(_messages);
      
      final response = await _chatService.sendMessage(
        _userId!,
        message,
        conversationHistory: currentMessages,
        userLocation: _userLocation,
      );
      print('Received response: $response');
      // Response is already saved in sendMessage, but if it failed, show error
      if (response.startsWith('Error:')) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
      // Scroll to bottom after sending
      _scrollToBottom();
    } catch (e) {
      print('Error in _sendMessage: $e');
      if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.error(e.toString())),
              duration: const Duration(seconds: 5),
            ),
          );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_userId == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          IconButton(
            icon: Icon(
              widget.currentThemeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: widget.currentThemeMode == ThemeMode.dark
                ? 'Switch to light mode'
                : 'Switch to dark mode',
            onPressed: () {
              widget.onThemeChanged(
                widget.currentThemeMode == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat messages
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                stream: _chatService.getChatHistory(_userId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)!.startConversation,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final messages = snapshot.data!;
                  // Update local messages list for conversation history
                  _messages = messages;
                  
                  // Scroll to bottom when messages load
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                  
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length) {
                        // Loading indicator for AI response
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                                child: Icon(
                                  Icons.smart_toy,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final message = messages[index];
                      return _buildMessageBubble(message);
                    },
                  );
                },
              ),
            ),

            // Message input
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.typeMessage,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _isLoading 
                        ? () {
                            print('Send button pressed but isLoading is true');
                          }
                        : () {
                            print('Send button pressed, calling _sendMessage');
                            _sendMessage();
                          },
                      icon: const Icon(Icons.send),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel message) {
    final isUser = message.isFromUser;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              child: Icon(
                Icons.smart_toy,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: isUser
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

