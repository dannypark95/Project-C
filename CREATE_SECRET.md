# Create Firebase Secret (One-Time Setup)

## Step 1: Create Secret in Google Cloud Console

1. Go to [Google Cloud Console - Secret Manager](https://console.cloud.google.com/security/secret-manager?project=project-connect-dc6ae)
2. Click **"Create Secret"**
3. Name: `GEMINI_API_KEY`
4. Secret value: Your Gemini API key (get it from [Google AI Studio](https://makersuite.google.com/app/apikey))
5. Click **"Create Secret"**

## Step 2: Grant Access to Firebase Functions

The secret needs to be accessible by Firebase Functions. This is usually automatic, but if you get permission errors:

1. Go to [IAM & Admin](https://console.cloud.google.com/iam-admin/iam?project=project-connect-dc6ae)
2. Find the service account: `project-connect-dc6ae@appspot.gserviceaccount.com`
3. Click **Edit** → **Add Another Role**
4. Add role: **Secret Manager Secret Accessor**
5. Save

## Step 3: Deploy Functions

After creating the secret, push to GitHub and the functions will deploy automatically.

The secret only needs to be created **once**. After that, all deployments will use it automatically.

