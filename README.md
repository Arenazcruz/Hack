# Sumaq Ruta AI

App Flutter para emprendimiento gastronomico y turismo en Bolivia.

## Stack

- Flutter
- Firebase Auth
- Cloud Firestore
- Firebase Storage
- Gemini API

## Configuracion local

Los archivos de configuracion de Firebase no se versionan en Git. Para
generarlos localmente:

```powershell
dart pub global activate flutterfire_cli
firebase login
flutterfire configure --project=sumaq-ia
```

Esto genera `lib/firebase_options.dart` y los archivos nativos necesarios, como
`android/app/google-services.json`.

## Comandos utiles

```powershell
flutter pub get
flutter analyze
flutter test
flutter run
```
