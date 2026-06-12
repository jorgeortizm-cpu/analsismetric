# TECHNICAL NOTES – ANALISISMETRIC APP V1

## Base analizada

- `bolsajob_app.zip`: se tomó como base metodológica/arquitectónica móvil Flutter.
- `Analisismetric1.zip`: se tomó como backend funcional de AnalisisMetric: Flask, módulos HTML, APIs y motor `analisis_expedientes`.

## Decisión arquitectónica

La app no reescribe todo el motor web en Flutter porque los módulos existentes tienen lógica HTML/JS/exportadores ya conectados al servidor. La solución robusta es híbrida:

1. **Flutter nativo** para navegación, home, métricas, contacto y Data Analyst.
2. **WebView** para preservar módulos completos: Bancos, Cooperativas, Empresas, Score.
3. **Servicios API** para consumir directamente los endpoints JSON del backend.

## Endpoints integrados

### Dashboard
- `GET /api/dashboard/summary`
- `GET /api/bce/indicadores`
- `GET /api/monitor/bce-seps`
- `GET /api/metrics`

### Data Analyst / Expedientes
- `GET /analisis_expedientes/health`
- `POST /analisis_expedientes/api/upload`
- `POST /analisis_expedientes/api/process`
- `GET /analisis_expedientes/api/suggest`
- `POST /analisis_expedientes/api/resolve`
- `POST /analisis_expedientes/api/analyze`
- `GET /analisis_expedientes/api/export/pdf`
- `GET /analisis_expedientes/api/export/docx`
- `GET /analisis_expedientes/api/export/ipynb`

### Contacto
- `POST /api/contact`

## Compilación recomendada

```bash
flutter clean
flutter pub get
flutter build apk --release --dart-define=API_BASE_URL=https://analisismetric.com
```

Para iOS:

```bash
flutter clean
flutter pub get
flutter build ios --release --dart-define=API_BASE_URL=https://analisismetric.com
```

## Observaciones

- La carpeta `build/`, `.dart_tool/`, `.gradle/` y otros artefactos generados fueron removidos del ZIP final para evitar conflictos.
- `pubspec.lock` fue removido para que Flutter regenere dependencias según tu entorno.
- Android tiene permiso `INTERNET` en `AndroidManifest.xml`.
- `applicationId` Android y bundle iOS se configuraron como `com.analisismetric.app`.
- Si usas un dominio temporal o local con `http://`, Android permite cleartext para pruebas. En producción mantener HTTPS.
