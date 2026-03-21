import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_mobile_shell.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../auth/providers/auth_providers.dart';
import '../../events/providers/event_providers.dart';
import '../../events/widgets/event_summary_card.dart';
import '../../participants/providers/participant_providers.dart';
import '../../payments/providers/payment_providers.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsByCurrentUserProvider);

    return AppMobileShell(
      title: 'Mis eventos',
      actions: [
        IconButton(
          onPressed: () => ref.read(authServiceProvider).signOut(),
          icon: const Icon(Icons.logout),
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/events/new'),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo evento'),
      ),
      child: eventsAsync.when(
        data: (events) {
          if (events.isEmpty) {
            return const EmptyStateWidget(
              title: 'Aún no tenés eventos',
              subtitle: 'Creá tu primer evento para empezar a recibir pagos.',
            );
          }

          return Column(
            children: events
                .map((event) {
                  final participantsCount = ref.watch(
                    participantsCountProvider(event.id),
                  );
                  final approvedCount = ref.watch(
                    approvedPaymentsCountProvider(event.id),
                  );
                  final pendingCount = ref.watch(
                    pendingPaymentsCountProvider(event.id),
                  );

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: EventSummaryCard(
                      event: event,
                      totalParticipants: participantsCount.valueOrNull ?? 0,
                      approvedPayments: approvedCount.valueOrNull ?? 0,
                      pendingPayments: pendingCount.valueOrNull ?? 0,
                      onTap: () => context.push('/events/${event.id}'),
                    ),
                  );
                })
                .toList(growable: false),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Text('Error: $error'),
      ),
    );
  }
}
