import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/app_formatters.dart';
import '../../../shared/widgets/app_mobile_shell.dart';
import '../../../shared/widgets/section_card.dart';
import '../providers/public_event_providers.dart';

class PublicEventPage extends ConsumerWidget {
  const PublicEventPage({super.key, required this.slug});

  final String slug;

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

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
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
                    const SizedBox(height: 8),
                    Text('Instrucciones: ${event.instructions}'),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: () => context.push('/e/$slug/upload'),
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
}
