import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/store/app_state.dart';

class AnalisisMetricApp extends StatefulWidget {
  const AnalisisMetricApp({super.key});

  @override
  State<AnalisisMetricApp> createState() => _AnalisisMetricAppState();
}

class _AnalisisMetricAppState extends State<AnalisisMetricApp> {
  final AppState appState = AppState();

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      state: appState,
      child: MaterialApp(
        title: 'AnalisisMetric',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        initialRoute: AppRouter.home,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
