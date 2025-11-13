# Technical Summary: Language Detection & Conversation Persistence

## 1. Korean/English Language Detection & Display

### Architecture Overview
The app uses a **multi-layered approach** to detect and respond in the appropriate language (Korean or English).

### Flow Diagram
```
User Opens Chat
    ↓
1. Location Detection (Client-side)
    ↓
2. Welcome Message (Language-specific)
    ↓
3. User Sends Message
    ↓
4. Language Detection (AI-side)
    ↓
5. AI Response (Matched Language)
```

### Implementation Details

#### A. Client-Side Location Detection
**File:** `lib/screens/chat_screen.dart`

```dart
Future<void> _detectLocation() async {
  // Uses browser's language setting
  final language = Localizations.localeOf(context).languageCode;
  
  if (language == 'ko') {
    _userLocation = 'Korea';  // Sets location for welcome message
  } else {
    _userLocation = 'Unknown';
  }
}
```

**How it works:**
- Reads browser's `languageCode` from Flutter's `Localizations`
- If `languageCode == 'ko'` → Sets `_userLocation = 'Korea'`
- This triggers Korean welcome message

#### B. Welcome Message (Language-Specific)
**File:** `lib/screens/chat_screen.dart` (lines 94-98)

```dart
final isKorean = _userLocation?.toLowerCase().contains('korea') ?? false;
final welcomePrompt = isKorean 
    ? '안녕하세요! 저는 Aura입니다...'  // Korean
    : 'Hello! I\'m Aura...';            // English
```

**How it works:**
- Checks if `_userLocation` contains "korea"
- Selects appropriate welcome message
- Saves to Firestore as AI message (`isFromUser: false`)

#### C. AI Language Matching (Server-Side)
**File:** `functions/index.js` (lines 123-136)

```javascript
// Add language matching instruction
let languageInstruction = "";
if (userLocation && userLocation.toLowerCase().includes("korea")) {
  languageInstruction = "Match the language of their message...";
} else {
  languageInstruction = "Match the language of the user's message...";
}

const fullPrompt = `${SYSTEM_PROMPT}${languageInstruction}${conversationContext}\n\nUser: ${message}\n\nAura:`;
```

**How it works:**
1. **Client sends:**
   - User's message
   - `userLocation` (from client detection)
   - `conversationHistory` (for context)

2. **Server receives and:**
   - Adds language instruction to system prompt
   - Tells AI: "Match the language of the user's message"
   - AI automatically detects Korean/English/mixed and responds accordingly

3. **AI Response:**
   - If user writes "안녕!" → AI responds in Korean
   - If user writes "Hello!" → AI responds in English
   - If user writes "안녕! employee..." → AI responds in mixed Korean/English

### Key Technologies
- **Client:** Flutter `Localizations.localeOf(context).languageCode`
- **Server:** Gemini AI's built-in language detection
- **Storage:** Firestore (messages saved with language as-is)

---

## 2. Conversation Persistence (Keeping Track When Users Close)

### Architecture Overview
Uses **Firebase Anonymous Authentication** + **Firestore** to persist conversations across sessions.

### Flow Diagram
```
User Opens App
    ↓
1. Anonymous Authentication
    ↓
2. Get User ID (persistent)
    ↓
3. Load Messages from Firestore
    ↓
4. Display Chat History
    ↓
User Closes App
    ↓
User Reopens App
    ↓
Same User ID → Same Messages
```

### Implementation Details

#### A. Anonymous Authentication
**File:** `lib/services/auth_service.dart`

```dart
Future<User?> signInAnonymously() async {
  // If already signed in, return current user
  if (_auth.currentUser != null) {
    return _auth.currentUser;  // Same user persists!
  }
  
  // Sign in anonymously (creates new user if first time)
  final userCredential = await _auth.signInAnonymously();
  return userCredential.user;
}
```

**How it works:**
1. **First visit:**
   - Creates anonymous Firebase user
   - Gets unique `userId` (e.g., `qEt7hJfab9cXJqTOLC3WIzZbUk83`)
   - This `userId` is stored in browser's localStorage (Firebase SDK handles this)

2. **Return visit:**
   - Firebase SDK checks localStorage
   - Finds existing anonymous user
   - Returns same `userId`
   - **Same user = Same conversation history**

**Persistence mechanism:**
- Firebase Auth stores anonymous tokens in browser's localStorage
- Token persists even after browser close
- Same token = Same user ID

#### B. Message Storage (Firestore)
**File:** `lib/services/chat_service.dart` (lines 95-109)

```dart
Future<void> saveMessage(String userId, String content, bool isFromUser) async {
  await _firestore
      .collection('users')
      .doc(userId)                    // User's unique ID
      .collection('messages')         // Subcollection for messages
      .add({
    'content': content,
    'isFromUser': isFromUser,
    'timestamp': FieldValue.serverTimestamp(),
  });
}
```

**Firestore Structure:**
```
users/
  └── {userId}/                    # e.g., qEt7hJfab9cXJqTOLC3WIzZbUk83
      └── messages/
          ├── {messageId1}
          │   ├── content: "안녕!"
          │   ├── isFromUser: true
          │   └── timestamp: 2025-01-11T...
          ├── {messageId2}
          │   ├── content: "Hello! I'm Aura..."
          │   ├── isFromUser: false
          │   └── timestamp: 2025-01-11T...
          └── ...
```

#### C. Message Loading (StreamBuilder)
**File:** `lib/services/chat_service.dart` (lines 112-125)

```dart
Stream<List<MessageModel>> getChatHistory(String userId) {
  return _firestore
      .collection('users')
      .doc(userId)
      .collection('messages')
      .orderBy('timestamp', descending: true)  // Newest first
      .limit(50)                                // Last 50 messages
      .snapshots()                              // Real-time stream
      .map((snapshot) {
    // Convert Firestore docs to MessageModel objects
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return MessageModel(
        id: doc.id,
        content: data['content'] ?? '',
        isFromUser: data['isFromUser'] ?? true,
        timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));  // Sort chronologically
  });
}
```

**File:** `lib/screens/chat_screen.dart` (lines 145-220)

```dart
StreamBuilder<List<MessageModel>>(
  stream: _chatService.getChatHistory(_userId!),
  builder: (context, snapshot) {
    // Automatically rebuilds when Firestore data changes
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Center(child: Text('Start a conversation'));
    }
    
    final messages = snapshot.data!;
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return _buildMessageBubble(messages[index]);
      },
    );
  },
)
```

**How it works:**
1. **StreamBuilder** listens to Firestore in real-time
2. When app opens:
   - Queries `users/{userId}/messages`
   - Gets last 50 messages, sorted by timestamp
   - Displays them in chat UI
3. **Real-time updates:**
   - If message is added while app is open → UI updates automatically
   - No need to refresh

### Key Technologies
- **Authentication:** Firebase Anonymous Auth (persists in localStorage)
- **Database:** Cloud Firestore (NoSQL, real-time)
- **UI:** Flutter StreamBuilder (reactive, real-time updates)
- **Data Model:** `MessageModel` (Dart class)

### Security
**File:** `firestore.rules`

```javascript
match /users/{userId} {
  // Only authenticated users can access their own data
  allow read, write: if request.auth != null && request.auth.uid == userId;
  
  match /messages/{messageId} {
    allow read, write: if request.auth != null && request.auth.uid == userId;
  }
}
```

**How it works:**
- User can only read/write their own messages
- `request.auth.uid` must match `userId` in path
- Prevents users from accessing other users' conversations

---

## Summary

### Language Detection
1. **Client detects** browser language → Sets location
2. **Welcome message** uses location to choose language
3. **AI automatically detects** message language and responds accordingly
4. **No manual language switching** needed

### Conversation Persistence
1. **Anonymous Auth** creates persistent user ID (stored in browser)
2. **Firestore** stores all messages under `users/{userId}/messages`
3. **StreamBuilder** loads messages when app opens
4. **Same user ID** = Same conversation history
5. **Real-time sync** - messages update automatically

### Data Flow
```
User Action → Firebase Auth → User ID → Firestore Query → Messages Loaded → UI Updates
```

### Limitations & Future Enhancements
- **Current:** Location based on browser language only
- **Future:** Could add IP-based geolocation or user preference setting
- **Current:** Anonymous auth (user loses data if they clear browser data)
- **Future:** Could add email/password auth for permanent accounts

