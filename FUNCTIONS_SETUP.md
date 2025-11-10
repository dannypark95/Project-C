# Firebase Functions Setup Guide

## Step 1: Get Your Gemini API Key

1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Click **Create API Key**
3. Copy the API key (you'll need it in Step 3)

## Step 2: Install Functions Dependencies

```bash
cd functions
npm install
cd ..
```

## Step 3: Set Gemini API Key in Firebase

You have two options:

### Option A: Firebase Environment Config (Recommended)
```bash
firebase functions:config:set gemini.api_key="YOUR_GEMINI_API_KEY"
```

### Option B: Set as Secret (More Secure)
```bash
firebase functions:secrets:set GEMINI_API_KEY
# Paste your API key when prompted
```

Then update `functions/index.js` to use:
```javascript
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
```

## Step 4: Deploy Functions

```bash
firebase deploy --only functions
```

Or use GitHub Actions (automatic on push to main).

## Step 5: Enable Required Services

1. **Enable Anonymous Authentication:**
   - Firebase Console → Authentication → Sign-in method
   - Enable **Anonymous**

2. **Create Firestore Database:**
   - Firebase Console → Firestore Database
   - Click **Create database**
   - Choose **Start in test mode** (for MVP)
   - Select location

3. **Get Firebase Web Config:**
   - Firebase Console → Project Settings → Your apps
   - Copy the config values
   - Update `lib/firebase_options.dart`

## Step 6: Test

1. Run `flutter run -d chrome`
2. Click "Start Chat"
3. Send a message - it should work! 🎉

