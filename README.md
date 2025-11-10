# CONNECTED - Mental Wellness App

A Flutter-based mental wellness application (currently in skeleton phase).

## Current Status

Simple "Hello World" web app with clean UI theme.

## Setup

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK (included with Flutter)

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd Project-C
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app locally:
```bash
flutter run -d chrome
```

## Building for Web

To build for web deployment:

```bash
flutter build web
```

The built files will be in the `build/web` directory.

## Deployment to Netlify

### Option 1: Deploy Script (Easiest - Recommended)

Simply run the deploy script:

```bash
./deploy.sh
```

This script will:
1. Build your Flutter web app (`flutter build web --release`)
2. Deploy to Netlify production
3. Show you the live URL

### Option 2: Drag & Drop (Manual)

1. Build your Flutter app:
```bash
flutter build web --release
```

2. Go to [netlify.com](https://netlify.com) and sign up/login
3. Drag and drop the `build/web` folder onto Netlify dashboard
4. Your app is live! 🎉

### Option 3: Deploy via Netlify CLI (Manual)

1. Build your Flutter app:
```bash
flutter build web --release
```

2. Install Netlify CLI:
```bash
npm install -g netlify-cli
```

3. Login to Netlify:
```bash
netlify login
```

4. Deploy:
```bash
netlify deploy --prod --dir=build/web
```

### Option 4: Automatic Deployment with GitHub Actions (Recommended for CI/CD)

The project includes a GitHub Actions workflow that automatically deploys when you push to the `main` branch.

#### Setup (One-time):

1. **Get your Netlify Auth Token:**
   - Go to [Netlify User Settings → Applications → New access token](https://app.netlify.com/user/applications)
   - Create a new token and copy it

2. **Get your Netlify Site ID:**
   - Your site ID is: `1e21bb0d-a5e4-4cba-9074-c50fcd565426`
   - Or run: `netlify sites:list` to see it

3. **Add GitHub Secrets:**
   - Go to your GitHub repo → Settings → Secrets and variables → Actions
   - Add two secrets:
     - `NETLIFY_AUTH_TOKEN`: Your Netlify auth token
     - `NETLIFY_SITE_ID`: `1e21bb0d-a5e4-4cba-9074-c50fcd565426`

#### How it works:

- **Automatic:** Every push to `main` branch triggers a deployment
- **Manual:** You can also trigger it manually from the GitHub Actions tab
- **Safe:** Only deploys from `main` branch (not feature branches)

Once set up, just push to `main` and your app will automatically deploy! 🚀

### Custom Domain

After deployment, you can add a custom domain in Netlify dashboard under "Domain settings".

### Note

The `netlify.toml` file is already configured to:
- Build your Flutter web app
- Handle routing correctly (SPA redirects)

## Project Structure

```
lib/
  ├── main.dart              # App entry point
  ├── screens/
  │   └── home_screen.dart   # Main screen
  ├── theme/
  │   └── app_theme.dart     # App theme configuration
  └── models/                # Data models (for future use)
```

## Next Steps

- [ ] Add Firebase integration
- [ ] Implement authentication
- [ ] Add AI chat functionality
- [ ] Create journal/mood tracking features
