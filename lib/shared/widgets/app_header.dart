import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key, this.showBack = false, this.title});

  final bool showBack;
  final String? title;

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 720;
    return AppBar(
      leading: showBack ? const BackButton() : null,
      titleSpacing: showBack ? 0 : 16,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/favicon_analisismetric.png',
              height: 36,
              width: 36,
              errorBuilder: (_, __, ___) => const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.ibmBlue,
                child: Text(AppConstants.brandShort, style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              title ?? AppConstants.brandName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
      actions: isCompact
          ? [
              PopupMenuButton<String>(
                onSelected: (route) => Navigator.pushNamed(context, route),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: AppRouter.dataAnalyst, child: Text('Data Analyst')),
                  PopupMenuItem(value: AppRouter.modules, child: Text('Módulos')),
                  PopupMenuItem(value: AppRouter.metrics, child: Text('Métricas')),
                  PopupMenuItem(value: AppRouter.contact, child: Text('Contacto')),
                  PopupMenuItem(value: AppRouter.settingsRoute, child: Text('Config.')),
                ],
              ),
            ]
          : [
              _NavText(label: 'Data Analyst', route: AppRouter.dataAnalyst),
              _NavText(label: 'Módulos', route: AppRouter.modules),
              _NavText(label: 'Métricas', route: AppRouter.metrics),
              _NavText(label: 'Contacto', route: AppRouter.contact),
              IconButton(
                tooltip: 'Configuración',
                onPressed: () => Navigator.pushNamed(context, AppRouter.settingsRoute),
                icon: const Icon(Icons.settings_outlined),
              ),
              const SizedBox(width: 8),
            ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1),
      ),
    );
  }
}

class _NavText extends StatelessWidget {
  const _NavText({required this.label, required this.route});
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, route),
      child: Text(label),
    );
  }
}
