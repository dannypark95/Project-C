# Firebase Setup Instructions

## Step 1: Get Firebase Web App Config

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **project-connect-dc6ae**
3. Click the gear icon ⚙️ → **Project settings**
4. Scroll down to **Your apps** section
5. If you don't have a web app yet:
   - Click **Add app** → Select **Web** (</> icon)
   - Register app with nickname: "CONNECTED Web"
   - Click **Register app**
6. Copy the Firebase configuration object

## Step 2: Update firebase_options.dart

Open `lib/firebase_options.dart` and replace the placeholder values:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_API_KEY_HERE',           // From Firebase config
  appId: 'YOUR_APP_ID_HERE',             // From Firebase config
  messagingSenderId: 'YOUR_SENDER_ID',   // From Firebase config
  projectId: 'project-connect-dc6ae',     // Already set
  authDomain: 'project-connect-dc6ae.firebaseapp.com',  // Already set
  storageBucket: 'project-connect-dc6ae.appspot.com',  // Already set
);
```

## Step 3: Enable Anonymous Authentication

1. In Firebase Console → **Authentication**
2. Click **Get started** (if first time)
3. Go to **Sign-in method** tab
4. Find **Anonymous** in the list
5. Click on it → **Enable** → **Save**

## Step 4: Create Firestore Database

1. In Firebase Console → **Firestore Database**
2. Click **Create database**
3. Choose **Start in test mode** (for MVP)
4. Select a location (choose closest to your users)
5. Click **Enable**

## Step 5: Set up Firebase Functions (for Gemini API)

See `FUNCTIONS_SETUP.md` for instructions on setting up the backend.

## Testing

After completing these steps:
1. Run `flutter pub get`
2. Run `flutter run -d chrome`
3. Click "Start Chat" - it should automatically sign you in anonymously!

