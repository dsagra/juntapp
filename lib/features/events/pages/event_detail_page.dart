import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/app_formatters.dart';
import '../../../shared/widgets/app_mobile_shell.dart';
import '../../../shared/widgets/section_card.dart';
import '../../participants/providers/participant_providers.dart';
import '../../payments/providers/payment_providers.dart';
import '../providers/event_providers.dart';

class EventDetailPage extends ConsumerWidget {
  const EventDetailPage({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventByIdProvider(eventId));
    final participantsCount = ref.watch(participantsCountProvider(eventId));
    final approvedCount = ref.watch(approvedPaymentsCountProvider(eventId));
    final pendingCount = ref.watch(pendingPaymentsCountProvider(eventId));

    return AppMobileShell(
      title: 'Detalle del evento',
      child: eventAsync.when(
        data: (event) {
          final participants = participantsCount.valueOrNull ?? 0;
          final approved = approvedCount.valueOrNull ?? 0;
          final pending = pendingCount.valueOrNull ?? 0;
          final expectedTotal = participants * event.amountPerParticipant;
          final progress = participants == 0 ? 0.0 : approved / participants;

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
                    const SizedBox(height: 12),
                    Text('Fecha: ${AppFormatters.date(event.eventDate)}'),
                    Text(
                      'Límite: ${AppFormatters.date(event.paymentDeadline)}',
                    ),
                    Text(
                      'Monto por participante: ${AppFormatters.currency(event.amountPerParticipant)}',
                    ),
                    const SizedBox(height: 8),
                    Text('Alias: ${event.transferAlias}'),
                    if ((event.cvu ?? '').isNotEmpty) Text('CVU: ${event.cvu}'),
                    Text('Titular: ${event.accountHolder}'),
                    const SizedBox(height: 8),
                    Text('Instrucciones: ${event.instructions}'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estado y métricas',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('Participantes: $participants'),
                    Text(
                      'Total esperado: ${AppFormatters.currency(expectedTotal)}',
                    ),
                    Text('Pagos aprobados: $approved'),
                    Text('Pagos pendientes: $pending'),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: progress),
                    const SizedBox(height: 6),
                    Text('$approved de $participants pagaron'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Link público',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    SelectableText('/e/${event.slug}'),
                    const SizedBox(height: 8),
                    Text(
                      'Compartilo por WhatsApp para que cada familia cargue el comprobante.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => context.push('/events/$eventId/participants'),
                icon: const Icon(Icons.people_alt_outlined),
                label: const Text('Administrar participantes'),
              ),
              const SizedBox(height: 10),
              FilledButton.icon(
                onPressed: () => context.push('/events/$eventId/payments'),
                icon: const Icon(Icons.receipt_long_outlined),
                label: const Text('Revisar pagos'),
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
