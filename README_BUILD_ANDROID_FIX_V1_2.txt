ANALISISMETRIC APP - BUILD FIX V1.2

Correcciones aplicadas:
1. android/app/build.gradle.kts
   - compileSdk = 36
   - minSdk = 23
   - targetSdk = 35

2. android/gradle.properties
   - Desactivada compilacion incremental Kotlin para evitar el error de Windows:
     "this and base files have different roots"
     cuando el proyecto esta en R: y Pub Cache en C:.

Comandos recomendados en PowerShell:

cd R:\ProyectosFlutter\analisismetric_app

# Cerrar procesos Gradle/Java bloqueados
taskkill /F /IM java.exe

# Limpiar residuos de compilacion
flutter clean
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force android\.gradle -ErrorAction SilentlyContinue

# Descargar dependencias
flutter pub get

# Compilar APK release
flutter build apk --release --dart-define=API_BASE_URL=https://analisismetric.com

Si sale que falta Android SDK Platform 36:
- Abrir Android Studio > SDK Manager > SDK Platforms
- Activar Android API 36
- Apply / OK

Alternativa mas robusta si persiste el error multi-disco:
1. Mover el proyecto completo a C:\ProyectosFlutter\analisismetric_app
   o
2. Configurar Pub Cache en R:\FlutterPubCache antes de flutter pub get:

$env:PUB_CACHE="R:\FlutterPubCache"
flutter pub get
flutter build apk --release --dart-define=API_BASE_URL=https://analisismetric.com
