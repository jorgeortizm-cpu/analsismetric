ANALISISMETRIC APP - BUILD FIX V1.4
==================================

Corrección aplicada:
- El plugin file_picker seguía compilando internamente contra android-34.
- Se agregó un override doble en android/build.gradle.kts:
  1) al aplicar el plugin com.android.application/com.android.library
  2) después de evaluar cada subproyecto (afterEvaluate)
- Esto fuerza compileSdk = 36 también en plugins Flutter como:
  file_picker, webview_flutter_android, shared_preferences_android,
  url_launcher_android y flutter_plugin_android_lifecycle.

Pasos recomendados:
1. Cerrar VS Code y PowerShell.
2. Renombrar o eliminar la carpeta actual:
   R:\ProyectosFlutter\analisismetric_app
3. Descomprimir este ZIP dentro de:
   R:\ProyectosFlutter\
4. Ejecutar en PowerShell:

   cd R:\ProyectosFlutter\analisismetric_app
   taskkill /F /IM java.exe
   flutter clean
   Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
   Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
   Remove-Item -Recurse -Force android\.gradle -ErrorAction SilentlyContinue
   flutter pub get
   flutter build apk --release --dart-define=API_BASE_URL=https://analisismetric.com

Si todavía aparece conflicto de Kotlin entre C: y R:, mover el proyecto a:
   C:\ProyectosFlutter\analisismetric_app
