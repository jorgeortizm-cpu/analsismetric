ANALISISMETRIC APP V1.6 - FIX DART CONST / WIDGET LIST

Cambios aplicados:
1. Se eliminó el prefijo `const` en todas las llamadas a SectionTitle(...) dentro de pantallas.
   Motivo: Codemagic estaba compilando con referencias donde SectionTitle no era tratado como constante.
2. Se tipó explícitamente la lista de KPIs del home como `List<Widget>`.
   Motivo: Flutter reportó que `List<dynamic>` no podía asignarse a `List<Widget>` en GridView.count(children: ...).
3. Se mantiene compileSdk 36 y el parche Gradle/Kotlin de versiones anteriores.

Archivos principales corregidos:
- lib/features/home/presentation/home_screen.dart
- lib/features/data_analyst/presentation/data_analyst_screen.dart
- lib/features/modules/presentation/modules_screen.dart
- lib/features/metrics/presentation/metrics_screen.dart
- lib/features/contact/presentation/contact_screen.dart
- lib/features/settings/presentation/settings_screen.dart

Uso recomendado:
1. Reemplazar el contenido completo del repositorio GitHub con esta versión, o subir estos archivos corregidos.
2. Confirmar que existan las carpetas ios/Runner, android/app, lib y pubspec.yaml en GitHub.
3. Ejecutar Start new build en Codemagic.
