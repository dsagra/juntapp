import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/app_mobile_shell.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/section_card.dart';
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
          onPressed: () async {
            try {
              await ref.read(authServiceProvider).signOut();
              if (context.mounted) {
                context.go('/login');
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No se pudo cerrar sesión: $e')),
                );
              }
            }
          },
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
          final activeCount = events.where((event) => event.isActive).length;

          if (events.isEmpty) {
            return const EmptyStateWidget(
              title: 'Aún no tenés eventos',
              subtitle: 'Creá tu primer evento para empezar a recibir pagos.',
              icon: Icons.event_available,
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: events
                .asMap()
                .entries
                .map((entry) {
                  final index = entry.key;
                  final event = entry.value;
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
                    padding: EdgeInsets.only(
                      bottom: index == events.length - 1
                          ? 0
                          : AppConstants.sectionGap,
                    ),
                    child: index == 0
                        ? Column(
                            children: [
                              SectionCard(
                                title: 'Resumen rápido',
                                subtitle:
                                    'Gestioná aportes y seguimiento de pagos.',
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _StatPill(
                                        label: 'Eventos',
                                        value: '${events.length}',
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _StatPill(
                                        label: 'Activos',
                                        value: '$activeCount',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppConstants.sectionGap),
                              EventSummaryCard(
                                event: event,
                                totalParticipants:
                                    participantsCount.valueOrNull ?? 0,
                                approvedPayments:
                                    approvedCount.valueOrNull ?? 0,
                                pendingPayments: pendingCount.valueOrNull ?? 0,
                                onTap: () =>
                                    context.push('/events/${event.id}'),
                              ),
                            ],
                          )
                        : EventSummaryCard(
                            event: event,
                            totalParticipants:
                                participantsCount.valueOrNull ?? 0,
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

class _StatPill extends StatelessWidget {
  const _StatPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.titleMedium),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
