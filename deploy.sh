#!/bin/bash

# CONNECTED - Deploy Script
# This script builds the Flutter web app and deploys it to Netlify

set -e  # Exit on error

echo "🚀 Starting deployment process..."
echo ""

# Step 1: Build Flutter web app
echo "📦 Building Flutter web app..."
flutter build web --release

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

echo "✅ Build complete!"
echo ""

# Step 2: Deploy to Netlify
echo "🌐 Deploying to Netlify..."
netlify deploy --prod --dir=build/web --site=1e21bb0d-a5e4-4cba-9074-c50fcd565426

if [ $? -ne 0 ]; then
    echo "❌ Deployment failed!"
    exit 1
fi

echo ""
echo "🎉 Deployment successful!"
echo "📍 Your app is live at: https://project-connected.netlify.app"

