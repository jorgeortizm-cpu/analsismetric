ANALISISMETRIC APP V1.5 - FIX CODMAGIC DART CONST SETTINGS

Corrección aplicada:
- lib/features/settings/presentation/settings_screen.dart
- Se eliminó el const global de la lista children del ListView.
- Se mantuvieron const locales solo donde son seguros.
- Se corrigió el comando informativo iOS a flutter build ipa.

Error corregido en Codemagic:
- Error: Not a constant expression.
- Archivo: lib/features/settings/presentation/settings_screen.dart
- Sección: SectionTitle(title: 'Notas técnicas') / Parámetros de compilación.

Pasos:
1. Reemplazar el archivo settings_screen.dart en GitHub.
2. Commit: Fix settings screen const expressions for Codemagic.
3. Ejecutar Start new build en Codemagic.
