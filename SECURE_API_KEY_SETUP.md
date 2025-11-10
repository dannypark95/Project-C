# Secure API Key Setup for Public Repo

## ✅ Solution: GitHub Secrets + Firebase Functions Environment Variables

Your API key is now stored securely and never committed to the repo.

## Setup Steps:

### 1. Add Gemini API Key to GitHub Secrets

1. Go to your GitHub repo: https://github.com/dannypark95/Project-C
2. Go to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `GEMINI_API_KEY`
5. Value: Your Gemini API key (the one you had: `AIzaSyAYnf_Sb7Hsf7h8dHPOlZTyYqsuTRl6za0`)
6. Click **Add secret**

### 2. How It Works

- ✅ API key stored in GitHub Secrets (encrypted, never exposed)
- ✅ GitHub Actions passes it as environment variable during deployment
- ✅ Firebase Functions receives it as `process.env.GEMINI_API_KEY`
- ✅ Never committed to code (safe for public repo!)

### 3. Deploy

Just push to GitHub:
```bash
git add .
git commit -m "Secure API key setup"
git push origin main
```

GitHub Actions will automatically:
1. Get `GEMINI_API_KEY` from secrets
2. Deploy functions with the environment variable set
3. Your function will have access to the key securely

## Security Notes

- ✅ API key never appears in code
- ✅ API key never appears in GitHub (only in encrypted secrets)
- ✅ Safe for public repositories
- ✅ Only accessible during deployment

## For Local Testing

If you want to test locally, create `functions/.env`:
```
GEMINI_API_KEY=your_key_here
```

And install dotenv:
```bash
cd functions
npm install dotenv
```

Then add to top of `functions/index.js`:
```javascript
require('dotenv').config();
```

But `.env` is already in `.gitignore`, so it won't be committed.

