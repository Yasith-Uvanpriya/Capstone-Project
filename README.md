Capstone Project - Accident Reporting & Analysis System
https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter
https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black
https://img.shields.io/badge/Python-3.x-3776AB?logo=python
https://img.shields.io/badge/Platform-Android%2520%257C%2520iOS%2520%257C%2520Web-lightgrey

A comprehensive accident reporting system with a mobile app for citizens and a website admin panel for authorities. The system uses Firebase for backend services and includes an AI module for accident analysis and prediction.

📱 Mobile App & 🖥️ Website Preview
Mobile App - First Page
https://assets/mobile-app-first-page.png

Website Admin Panel - First Page
https://assets/website-first-page.png

📋 Table of Contents

🗂️ Project Structure
text
Capstone-Project/
├── 📱 Mobile-app/          # Flutter mobile application
├── 🖥️ Web-site/            # Flutter web admin panel
│   └── backend_ai/         # Python AI backend
├── 📄 README.md
├── 🔧 firebase.json
└── 📦 pubspec.yaml
✨ Features
📱 Mobile App
✅ User registration & authentication

📝 Accident report submission with media (images/videos)

🗺️ Google Maps integration for location marking

📞 Emergency contact integration

📊 Report history and status tracking

🖥️ Website Admin Panel
📊 Interactive dashboard with analytics

🔍 View and manage accident reports

🤖 AI-powered accident analysis

📈 Historical data visualization

👥 User management system

⚙️ Prerequisites
Flutter SDK (>=3.0.0)

Dart SDK

Node.js (for Firebase tools)

Python 3.x (for backend AI)

Firebase Account

Google Maps API Key

🔥 Firebase Setup
1. Create Firebase Project
Go to Firebase Console

Click "Add project" and follow the setup wizard

Note your Project ID

2. Configure Authentication
In Firebase Console, go to Authentication → Sign-in method

Enable Email/Password provider

3. Setup Firestore Database
Go to Firestore Database → Create database

Start in test mode for development

Choose your preferred location

4. Add Apps to Project
Android App: Add your Android package name

iOS App: Add your iOS bundle ID

Web App: Add your web domain

5. Download Configuration Files
Android: Download google-services.json → place in Mobile-app/android/app/

iOS: Download GoogleService-Info.plist → place in Mobile-app/ios/Runner/

Web: Copy Firebase config for lib/firebase_options.dart

🚀 Installation & Running
Mobile App Setup
bash
# Navigate to mobile app directory
cd Mobile-app

# Install dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Build for production
flutter build apk          # Android
flutter build appbundle    # Android Bundle
flutter build ios          # iOS (requires macOS)
Website Admin Panel Setup
bash
# Navigate to website directory
cd Web-site

# Install dependencies
flutter pub get

# Run in Chrome browser
flutter run -d chrome

# Build for web deployment
flutter build web
🤖 Backend AI
The AI module provides accident analysis and prediction capabilities.

Setup & Running
bash
# Navigate to AI backend directory
cd Web-site/backend_ai

# Create virtual environment (optional but recommended)
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run the AI server
python main.py
The AI server will start at http://localhost:5000 and provides endpoints for:

/analyze-accident - Analyze accident severity

/predict-hotspots - Predict accident-prone areas

/generate-insights - Generate statistical insights

📁 Folder Structure
Mobile App
text
Mobile-app/
lib/
├── models/                 # Data models
├── services/              # Firebase services
├── widgets/               # Reusable widgets
├── pages/                 # App screens
│   ├── login_page.dart
│   ├── signup_page.dart
│   ├── home_page.dart
│   ├── accident_reporting_page.dart
│   ├── map_page.dart
│   └── call_police.dart
├── utils/                 # Utilities & constants
└── main.dart             # App entry point
Website Admin Panel
text
Web-site/
lib/
├── components/            # Reusable components
│   ├── Navbar/
│   ├── Footer/
│   └── Accident_Analyzer/
├── pages/                 # Main pages
│   ├── Landing/
│   ├── Accident_History/
│   └── Dashboard/
├── services/              # API & Firebase services
├── models/                # Data models
└── main.dart             # App entry point
backend_ai/
├── main.py               # AI server entry point
├── models/               # ML models
├── utils/                # Helper functions
└── requirements.txt      # Python dependencies
🌐 Deployment
Firebase Hosting (Website)
bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize hosting
firebase init hosting

# Deploy
firebase deploy --only hosting
Mobile App Deployment
Android
Generate signing key

Update android/app/build.gradle

Run flutter build appbundle

Upload to Google Play Console

iOS
Set up Apple Developer account

Configure in Xcode

Run flutter build ios

Upload via Transporter app

🛠️ Development
Adding Dependencies
bash
# Add package to both mobile and web
cd Mobile-app && flutter pub add package_name
cd ../Web-site && flutter pub add package_name
Environment Configuration
Create .env files for sensitive configuration:

text
# Mobile-app/.env
GOOGLE_MAPS_API_KEY=your_maps_api_key
FIREBASE_PROJECT_ID=your_project_id

# Web-site/.env
AI_SERVER_URL=http://localhost:5000
FIREBASE_CONFIG={...}
🐛 Troubleshooting
Common Issues
Firebase Configuration Errors

Verify firebase_options.dart is properly configured

Check package names/bundle IDs match Firebase setup

Google Maps Not Loading

Ensure Google Maps API is enabled in Google Cloud Console

Verify API key restrictions

AI Server Connection Issues

Check if Python server is running on port 5000

Verify CORS settings for web requests

Getting Help
Check Flutter documentation: flutter.dev

Firebase support: firebase.google.com/support

Create an issue in this repository

📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

👥 Contributors
Your Name

Team Members

🙏 Acknowledgments
Flutter team for the amazing framework

Firebase for backend services

Google Maps API for location services
