import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../shared/widgets/app_mobile_shell.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../auth/providers/auth_providers.dart';
import '../../events/providers/event_providers.dart';
import '../../events/widgets/event_summary_card.dart';
import '../../participants/providers/participant_providers.dart';
import '../../payments/providers/payment_providers.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  String? _checkedFtuForUserId;

  Future<bool?> _showOnboardingDialog({bool barrierDismissible = true}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('¡Bienvenido a JuntApp! 👋'),
          content: const Text(
            '1) Creá tu evento.\n'
            '2) Cargá participantes.\n'
            '3) Compartí el link para que suban comprobantes.\n'
            '4) Revisá y aprobá pagos.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Entendido'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Crear mi primer evento'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _maybeShowFirstTimeUse(String userId) async {
    final firestore = ref.read(firestoreProvider);
    final userRef = firestore.collection('users').doc(userId);
    final snapshot = await userRef.get();

    final seenAt = snapshot.data()?['organizerOnboardingSeenAt'];
    if (seenAt != null) return;
    if (!mounted) return;

    final shouldCreateEvent = await _showOnboardingDialog(
      barrierDismissible: false,
    );

    await userRef.set({
      'organizerOnboardingSeenAt': Timestamp.fromDate(DateTime.now()),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    }, SetOptions(merge: true));

    if (!mounted) return;
    if (shouldCreateEvent == true) {
      context.push('/events/new');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final currentUserId = currentUser?.uid;

    if (currentUserId != null && _checkedFtuForUserId != currentUserId) {
      _checkedFtuForUserId = currentUserId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _maybeShowFirstTimeUse(currentUserId);
      });
    }

    final eventsAsync = ref.watch(eventsByCurrentUserProvider);

    return AppMobileShell(
      title: 'Mis eventos',
      actions: [
        IconButton(
          onPressed: () async {
            final shouldCreateEvent = await _showOnboardingDialog();
            if (!mounted) return;
            if (shouldCreateEvent == true) {
              context.push('/events/new');
            }
          },
          icon: const Icon(Icons.help_outline),
          tooltip: 'Cómo funciona',
        ),
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
          if (events.isEmpty) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BrandLogo(size: 72, showWordmark: false),
                SizedBox(height: 12),
                EmptyStateWidget(
                  title: 'Aún no tenés eventos',
                  subtitle:
                      'Creá tu primer evento para empezar a recibir pagos.',
                  icon: Icons.event_available,
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BrandLogo(size: 72, showWordmark: false),
              const SizedBox(height: 12),
              ...events
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
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Text('Error: $error'),
      ),
    );
  }
}
