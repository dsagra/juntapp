import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/analytics_providers.dart';
import '../../../shared/widgets/app_mobile_shell.dart';
import '../providers/public_event_providers.dart';

class UploadSuccessPage extends ConsumerWidget {
  const UploadSuccessPage({super.key, required this.slug, required this.token});

  final String slug;
  final String token;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(publicEventBySlugProvider(slug));

    return AppMobileShell(
      title: 'Comprobante enviado',
      child: eventAsync.when(
        data: (event) {
          final eventTitle = event?.title ?? 'tu evento';
          final eventPath = '/e/$slug?token=${Uri.encodeQueryComponent(token)}';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 108,
                height: 108,
                margin: const EdgeInsets.symmetric(horizontal: 80),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 64,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '¡Listo! Comprobante enviado',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'El organizador de "$eventTitle" lo va a revisar en breve.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.sectionGap),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Estado del envío',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Enviado',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.receipt_long_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Comprobante de pago para $eventTitle',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () async {
                  final link = _absoluteEventLink(eventPath);
                  await Share.share(
                    'Ya envié mi comprobante en JuntApp. Sumate acá: $link',
                    subject: 'Pago enviado - $eventTitle',
                  );
                  await ref
                      .read(appAnalyticsProvider)
                      .logPublicLinkShared('success_share');
                },
                icon: const Icon(Icons.share_outlined),
                label: const Text('Compartir con el grupo'),
              ),
              const SizedBox(height: AppConstants.sectionGap),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Organizá tu propia junta gratis',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Creá tu cuenta y gestioná pagos grupales sin complicaciones.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
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
                      label: const Text('Crear una junta'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () async {
                        await ref
                            .read(appAnalyticsProvider)
                            .logPublicSuccessPromoClicked('login');
                        if (context.mounted) {
                          context.go('/login');
                        }
                      },
                      child: const Text('Ya tengo cuenta'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  await ref
                      .read(appAnalyticsProvider)
                      .logPublicSuccessPromoClicked('back_to_event');
                  if (context.mounted) {
                    context.go(eventPath);
                  }
                },
                icon: const Icon(Icons.arrow_back_outlined),
                label: const Text('Volver al evento'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Text('Error: $error'),
      ),
    );
  }

  String _absoluteEventLink(String path) {
    final currentUri = Uri.base;
    if (currentUri.fragment.startsWith('/')) {
      return '${currentUri.origin}/#$path';
    }
    return '${currentUri.origin}$path';
  }
}
