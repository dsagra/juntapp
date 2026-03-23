import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/analytics_providers.dart';
import '../../../shared/widgets/app_mobile_shell.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../../../shared/widgets/section_card.dart';

class UploadSuccessPage extends ConsumerWidget {
  const UploadSuccessPage({super.key, required this.slug, required this.token});

  final String slug;
  final String token;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppMobileShell(
      title: 'Comprobante enviado',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BrandLogo(size: 112, showWordmark: false),
          const SizedBox(height: 8),
          Icon(
            Icons.check_circle,
            size: 72,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            '¡Listo! Recibimos tu comprobante.',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'El organizador lo revisará y te confirmará el estado.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SectionCard(
            title: '¿Querés organizar tu propio evento?',
            subtitle:
                'Creá tu cuenta y empezá a juntar pagos como anfitrión en minutos.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.icon(
                  onPressed: () async {
                    await ref
                        .read(appAnalyticsProvider)
                        .logPublicSuccessPromoClicked('signup');
                    if (context.mounted) {
                      context.go('/signup');
                    }
                  },
                  icon: const Icon(Icons.rocket_launch_outlined),
                  label: const Text('Quiero crear mi evento'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () async {
                    await ref
                        .read(appAnalyticsProvider)
                        .logPublicSuccessPromoClicked('login');
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                  child: const Text('Ya tengo cuenta, ingresar'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () async {
              await ref
                  .read(appAnalyticsProvider)
                  .logPublicSuccessPromoClicked('back_to_event');
              if (context.mounted) {
                context.go('/e/$slug?token=${Uri.encodeQueryComponent(token)}');
              }
            },
            child: const Text('Volver al evento'),
          ),
        ],
      ),
    );
  }
}
