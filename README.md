# CMSC 127 CD4L Project - GROUP 4

<b>ELBI FOOD SHARING APP</b>:
- Frontend: Flutter Widgets
- Backend: Flutter + Firebase

## Quick start (recommended)

You need to connect the app to the Firebase project to access Firestore (Database) and Firebase Auth (User Authentication)

### 0) Prerequisites

- Dart + Flutter

### 1) Install dependencies

In /my_app:

```bash
flutter pub get
```

### 2) Login to your firebase account

In any directory:

```bash
firebase login
```

### 3) Connect to the firebase project

In any directory:

```bash
dart pub global activate flutterfire_cli
```

In /my_app:
```bash
flutterfire configure {project}
```

No need to change any configurations and can just add all platforms.

Notes:
- Check group google docs for full flutterfire configure command 
- `../lib/firebase_options.dart` is gitignored
