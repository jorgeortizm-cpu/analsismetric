import 'package:flutter/material.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/models/module_link.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/section_title.dart';

class ModulesScreen extends StatelessWidget {
  const ModulesScreen({super.key});

  IconData _icon(String name) {
    switch (name) {
      case 'account_balance':
        return Icons.account_balance;
      case 'groups':
        return Icons.groups;
      case 'hub':
        return Icons.hub;
      case 'show_chart':
        return Icons.show_chart;
      case 'business_center':
        return Icons.business_center;
      case 'analytics':
      default:
        return Icons.analytics;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: const AppHeader(showBack: true, title: 'Módulos'),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const SectionTitle(
            title: 'Módulos integrados de AnalisisMetric',
            subtitle: 'Se cargan dentro de la app mediante WebView para conservar el diseño, lógica JavaScript y exportables del backend actual.',
          ),
          GridView.count(
            crossAxisCount: width < 720 ? 1 : 2,
            childAspectRatio: width < 460 ? 2.15 : 2.8,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: ModuleLink.modules.map((m) {
              return Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () => Navigator.pushNamed(context, AppRouter.moduleWeb, arguments: m),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(radius: 28, child: Icon(_icon(m.iconName))),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(m.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                              const SizedBox(height: 6),
                              Text(m.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
