import 'package:flutter/material.dart';
import '../../features/contact/presentation/contact_screen.dart';
import '../../features/data_analyst/presentation/data_analyst_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/metrics/presentation/metrics_screen.dart';
import '../../features/modules/presentation/modules_screen.dart';
import '../../features/modules/presentation/web_module_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../shared/models/module_link.dart';

class AppRouter {
  static const home = '/';
  static const dataAnalyst = '/data-analyst';
  static const modules = '/modules';
  static const moduleWeb = '/module-web';
  static const metrics = '/metrics';
  static const contact = '/contact';
  static const settingsRoute = '/settings';

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    Widget page;
    switch (routeSettings.name) {
      case dataAnalyst:
        page = const DataAnalystScreen();
        break;
      case modules:
        page = const ModulesScreen();
        break;
      case moduleWeb:
        final link = routeSettings.arguments as ModuleLink?;
        page = WebModuleScreen(link: link ?? ModuleLink.defaultModule());
        break;
      case metrics:
        page = const MetricsScreen();
        break;
      case contact:
        page = const ContactScreen();
        break;
      case settingsRoute:
        page = const SettingsScreen();
        break;
      case home:
      default:
        page = const HomeScreen();
    }

    return MaterialPageRoute(builder: (_) => page, settings: routeSettings);
  }
}
