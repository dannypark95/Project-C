# Setting Up Gemini API Key

## Option 1: Use Firebase Functions Config (Easiest)

This stores the key in Firebase config (less secure but simpler for MVP):

```bash
firebase functions:config:set gemini.api_key="YOUR_GEMINI_API_KEY"
```

Then update `functions/index.js` to use:
```javascript
const apiKey = process.env.FIREBASE_CONFIG?.gemini?.api_key;
```

## Option 2: Use Google Cloud Secret Manager (More Secure)

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project: **project-connect-dc6ae**
3. Go to **Secret Manager**
4. Click **Create Secret**
5. Name: `GEMINI_API_KEY`
6. Value: Your Gemini API key
7. Click **Create**

Then update the function to access the secret (requires code changes).

## Option 3: Use Environment Variable (For Local Testing)

Create `functions/.env` file:
```
GEMINI_API_KEY=your_api_key_here
```

Install dotenv:
```bash
cd functions
npm install dotenv
```

Update `functions/index.js` to load .env:
```javascript
require('dotenv').config();
```

## Recommended for MVP: Option 1

For MVP, Option 1 (Firebase config) is simplest and works fine. You can upgrade to secrets later.

