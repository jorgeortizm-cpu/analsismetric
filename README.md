# AnalisisMetric App Android/iOS

App Flutter móvil para **AnalisisMetric.com**, construida sobre la estructura modular del proyecto base Flutter (`core/features/shared`) e integrada con el backend Flask del archivo `Analisismetric1.zip`.

## Qué incluye

- Home móvil con KPIs desde `/api/dashboard/summary`.
- Indicadores BCE desde `/api/bce/indicadores`.
- Monitor BCE + SEPS desde `/api/monitor/bce-seps`.
- Módulos web existentes en WebView:
  - Bancos
  - Cooperativas Segmento 1
  - Cooperativas Segmentos 2–3
  - Volatilidad Segmentos 2–3
  - Empresas / BSC Radar
  - Análisis de Score
- Data Analyst móvil para el módulo `/analisis_expedientes`:
  - Carga de `catalogo`, `ranking`, `bi`, `mv` y `logo`.
  - Procesamiento de fuentes.
  - Consulta por expediente, RUC o empresa.
  - Análisis ejecutivo.
  - Exportación PDF, DOCX e IPYNB.
- Formulario de contacto conectado a `/api/contact`.
- Consulta móvil de métricas desde `/api/metrics`.

## Estructura principal

```text
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── router/
│   ├── theme/
│   └── utils/
├── features/
│   ├── contact/
│   ├── data_analyst/
│   ├── home/
│   ├── metrics/
│   ├── modules/
│   └── settings/
└── shared/
    ├── models/
    ├── services/
    ├── store/
    └── widgets/
```

## Configuración del backend

Por defecto la app apunta a:

```bash
https://analisismetric.com
```

Para usar otro dominio o ambiente:

```bash
flutter run --dart-define=API_BASE_URL=https://analisismetric.com
```

## Android

```bash
flutter clean
flutter pub get
flutter run -d android --dart-define=API_BASE_URL=https://analisismetric.com
```

Generar APK:

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://analisismetric.com
```

Generar AAB para Play Store:

```bash
flutter build appbundle --release --dart-define=API_BASE_URL=https://analisismetric.com
```

## iOS

Requiere macOS + Xcode:

```bash
flutter clean
flutter pub get
flutter run -d ios --dart-define=API_BASE_URL=https://analisismetric.com
```

Compilar release:

```bash
flutter build ios --release --dart-define=API_BASE_URL=https://analisismetric.com
```

## Identificadores configurados

- Android namespace/applicationId: `com.analisismetric.app`
- iOS bundle identifier: `com.analisismetric.app`
- Nombre visible: `AnalisisMetric`

## Nota técnica importante

El backend actual usa Flask, SQLite/SQLAlchemy, módulos HTML/Jinja, JavaScript y endpoints JSON. Por precisión y para no romper la lógica existente, la app combina:

1. **Pantallas nativas Flutter** para navegación, KPIs, contacto, métricas y Data Analyst.
2. **WebView** para los módulos HTML completos que ya existen y dependen de JavaScript/exportadores del servidor.
3. **API services** para consumir el motor `/analisis_expedientes` y mantener los exportables del backend.
