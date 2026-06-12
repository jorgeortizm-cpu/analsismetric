AnalisisMetric APP - Build Fix V1.3

Correcciones:
1. android/app/build.gradle.kts: compileSdk = 36, minSdk = 23, targetSdk = 35.
2. android/build.gradle.kts: fuerza compileSdk = 36 en todos los subproyectos Android, incluidos plugins como file_picker, webview_flutter_android, url_launcher_android y shared_preferences_android.
3. android/gradle.properties: desactiva caches/incremental Kotlin para evitar el error Windows multi-disco C:/R:.

Comandos:
cd R:\ProyectosFlutter\analisismetric_app
taskkill /F /IM java.exe
flutter clean
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force android\.gradle -ErrorAction SilentlyContinue
flutter pub get
flutter build apk --release --dart-define=API_BASE_URL=https://analisismetric.com

Si Android SDK Platform 36 no existe:
Android Studio > SDK Manager > SDK Platforms > Android API 36 > Apply.
