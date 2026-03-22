import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../shared/widgets/app_mobile_shell.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../../../shared/widgets/section_card.dart';
import '../providers/public_event_providers.dart';

class PublicEventPage extends ConsumerWidget {
  const PublicEventPage({super.key, required this.slug, required this.token});

  final String slug;
  final String token;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(publicEventBySlugProvider(slug));

    return AppMobileShell(
      title: 'Pago del evento',
      child: eventAsync.when(
        data: (event) {
          if (event == null || !event.isActive) {
            return const Center(child: Text('Evento no disponible.'));
          }

          if (!_hasValidToken(event.publicToken, token)) {
            return const Center(
              child: Text('Link inválido. Revisá el enlace completo.'),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BrandLogo(
                size: 112,
                showWordmark: false,
                tagline: 'Juntar plata fácil',
              ),
              const SizedBox(height: 8),
              Text(event.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(
                'Pagá y confirmá en menos de un minuto',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppConstants.sectionGap),
              SectionCard(
                title: 'Datos del evento',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.description),
                    const SizedBox(height: 10),
                    Text('Fecha: ${AppFormatters.date(event.eventDate)}'),
                    Text(
                      'Límite: ${AppFormatters.date(event.paymentDeadline)}',
                    ),
                    Text(
                      'Monto por participante: ${AppFormatters.currency(event.amountPerParticipant)}',
                    ),
                    const SizedBox(height: 10),
                    Text('Alias: ${event.transferAlias}'),
                    if ((event.cvu ?? '').isNotEmpty) Text('CVU: ${event.cvu}'),
                    Text('Titular: ${event.accountHolder}'),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.sectionGap),
              FilledButton(
                onPressed: () => context.push(
                  '/e/$slug/upload?token=${Uri.encodeQueryComponent(token)}',
                ),
                child: const Text('Ya transferí, subir comprobante'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Text('Error: $error'),
      ),
    );
  }

  bool _hasValidToken(String? expected, String received) {
    if (expected == null || expected.isEmpty) return false;
    return received.isNotEmpty && received == expected;
  }
}
