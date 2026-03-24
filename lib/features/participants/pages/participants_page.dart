import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/analytics_providers.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/app_mobile_shell.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../payments/models/payment_model.dart';
import '../../payments/providers/payment_providers.dart';
import '../models/participant_model.dart';
import '../providers/participant_providers.dart';

class ParticipantsPage extends ConsumerStatefulWidget {
  const ParticipantsPage({super.key, required this.eventId});

  final String eventId;

  @override
  ConsumerState<ParticipantsPage> createState() => _ParticipantsPageState();
}

class _ParticipantsPageState extends ConsumerState<ParticipantsPage> {
  _ParticipantsFilter _selectedFilter = _ParticipantsFilter.all;

  @override
  Widget build(BuildContext context) {
    final eventId = widget.eventId;
    final participantsAsync = ref.watch(participantsProvider(eventId));
    final paymentsAsync = ref.watch(paymentsProvider(eventId));

    return AppMobileShell(
      title: 'Participantes',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddOptions(context, ref),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Agregar'),
      ),
      child: participantsAsync.when(
        data: (participants) {
          if (participants.isEmpty &&
              _selectedFilter == _ParticipantsFilter.all) {
            return const EmptyStateWidget(
              title: 'No hay participantes',
              subtitle:
                  'Agregá el primer participante para habilitar el flujo público.',
              icon: Icons.groups_2_outlined,
            );
          }

          final latestPaymentStatusByParticipant = <String, PaymentStatus>{};
          for (final payment in paymentsAsync.valueOrNull ?? <PaymentModel>[]) {
            latestPaymentStatusByParticipant.putIfAbsent(
              payment.participantId,
              () => payment.status,
            );
          }

          final sortedParticipants = [...participants]
            ..sort((a, b) {
              final aStatus = _resolveStatus(
                latestPaymentStatusByParticipant[a.id],
              );
              final bStatus = _resolveStatus(
                latestPaymentStatusByParticipant[b.id],
              );

              final rankCompare = _statusSortRank(
                aStatus,
              ).compareTo(_statusSortRank(bStatus));
              if (rankCompare != 0) return rankCompare;

              return a.childName.toLowerCase().compareTo(
                b.childName.toLowerCase(),
              );
            });

          final statusByParticipant = {
            for (final participant in sortedParticipants)
              participant.id: _resolveStatus(
                latestPaymentStatusByParticipant[participant.id],
              ),
          };

          final paidCount = statusByParticipant.values
              .where((status) => status == _ParticipantPaymentViewStatus.paid)
              .length;
          final pendingReviewCount = statusByParticipant.values
              .where(
                (status) =>
                    status == _ParticipantPaymentViewStatus.pendingReview,
              )
              .length;
          final unpaidCount = statusByParticipant.values
              .where((status) => status == _ParticipantPaymentViewStatus.unpaid)
              .length;

          final filteredParticipants = sortedParticipants
              .where((participant) {
                final status = statusByParticipant[participant.id]!;
                switch (_selectedFilter) {
                  case _ParticipantsFilter.all:
                    return true;
                  case _ParticipantsFilter.unpaid:
                    return status == _ParticipantPaymentViewStatus.unpaid;
                  case _ParticipantsFilter.pendingReview:
                    return status ==
                        _ParticipantPaymentViewStatus.pendingReview;
                  case _ParticipantsFilter.paid:
                    return status == _ParticipantPaymentViewStatus.paid;
                }
              })
              .toList(growable: false);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ParticipantsSummary(
                totalParticipants: participants.length,
                paidCount: paidCount,
                pendingReviewCount: pendingReviewCount,
                unpaidCount: unpaidCount,
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _ParticipantsFilterChip(
                      label: 'Todos',
                      selected: _selectedFilter == _ParticipantsFilter.all,
                      onTap: () => setState(
                        () => _selectedFilter = _ParticipantsFilter.all,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _ParticipantsFilterChip(
                      label: 'Falta pago',
                      selected: _selectedFilter == _ParticipantsFilter.unpaid,
                      onTap: () => setState(
                        () => _selectedFilter = _ParticipantsFilter.unpaid,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _ParticipantsFilterChip(
                      label: 'En revisión',
                      selected:
                          _selectedFilter == _ParticipantsFilter.pendingReview,
                      onTap: () => setState(
                        () =>
                            _selectedFilter = _ParticipantsFilter.pendingReview,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _ParticipantsFilterChip(
                      label: 'Pagó',
                      selected: _selectedFilter == _ParticipantsFilter.paid,
                      onTap: () => setState(
                        () => _selectedFilter = _ParticipantsFilter.paid,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (filteredParticipants.isEmpty)
                const EmptyStateWidget(
                  title: 'Sin participantes para este filtro',
                  subtitle: 'Probá con otra vista para ver más resultados.',
                  icon: Icons.filter_alt_off_outlined,
                )
              else
                ...filteredParticipants.map((participant) {
                  final status = statusByParticipant[participant.id]!;
                  final label = participant.childName.trim();
                  final initial = label.isEmpty
                      ? '?'
                      : label.characters.first.toUpperCase();

                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: AppConstants.sectionGap,
                    ),
                    color: _cardColor(context, status),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              initial,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  participant.childName,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  [
                                    if ((participant.familyName ?? '')
                                        .isNotEmpty)
                                      participant.familyName,
                                    if ((participant.parentName ?? '')
                                        .isNotEmpty)
                                      participant.parentName,
                                  ].join(' • '),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 8),
                                _StatusBadge(status: status),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => _openEditor(
                                  context,
                                  ref,
                                  participant: participant,
                                ),
                                icon: const Icon(Icons.edit_outlined),
                              ),
                              IconButton(
                                onPressed: () => ref
                                    .read(participantRepositoryProvider)
                                    .deleteParticipant(
                                      eventId: eventId,
                                      participantId: participant.id,
                                    ),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Text('Error: $error'),
      ),
    );
  }

  Future<void> _openEditor(
    BuildContext context,
    WidgetRef ref, {
    ParticipantModel? participant,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _ParticipantEditorSheet(
          eventId: widget.eventId,
          participant: participant,
        );
      },
    );
  }

  Future<void> _openAddOptions(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person_add_alt_1_outlined),
                title: const Text('Agregar participante'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _openEditor(context, ref);
                },
              ),
              ListTile(
                leading: const Icon(Icons.playlist_add_outlined),
                title: const Text('Carga rápida (varios a la vez)'),
                subtitle: const Text('Pegá una lista de nombres'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _openBulkEditor(context, ref);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openBulkEditor(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _BulkParticipantsSheet(eventId: widget.eventId);
      },
    );
  }
}

enum _ParticipantsFilter { all, unpaid, pendingReview, paid }

class _ParticipantsSummary extends StatelessWidget {
  const _ParticipantsSummary({
    required this.totalParticipants,
    required this.paidCount,
    required this.pendingReviewCount,
    required this.unpaidCount,
  });

  final int totalParticipants;
  final int paidCount;
  final int pendingReviewCount;
  final int unpaidCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estado del grupo',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$totalParticipants participantes',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Icon(Icons.group, color: scheme.onPrimaryContainer),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SummaryStatCard(
                  label: 'Pagaron',
                  value: '$paidCount',
                  color: scheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SummaryStatCard(
                  label: 'En revisión',
                  value: '$pendingReviewCount',
                  color: scheme.tertiary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SummaryStatCard(
                  label: 'Falta pago',
                  value: '$unpaidCount',
                  color: scheme.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStatCard extends StatelessWidget {
  const _SummaryStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _ParticipantsFilterChip extends StatelessWidget {
  const _ParticipantsFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected ? scheme.primary : scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

enum _ParticipantPaymentViewStatus { paid, pendingReview, unpaid }

_ParticipantPaymentViewStatus _resolveStatus(PaymentStatus? paymentStatus) {
  switch (paymentStatus) {
    case PaymentStatus.approved:
      return _ParticipantPaymentViewStatus.paid;
    case PaymentStatus.pending:
      return _ParticipantPaymentViewStatus.pendingReview;
    case PaymentStatus.rejected:
    case null:
      return _ParticipantPaymentViewStatus.unpaid;
  }
}

int _statusSortRank(_ParticipantPaymentViewStatus status) {
  switch (status) {
    case _ParticipantPaymentViewStatus.unpaid:
      return 0;
    case _ParticipantPaymentViewStatus.pendingReview:
      return 1;
    case _ParticipantPaymentViewStatus.paid:
      return 2;
  }
}

Color _cardColor(BuildContext context, _ParticipantPaymentViewStatus status) {
  final scheme = Theme.of(context).colorScheme;
  switch (status) {
    case _ParticipantPaymentViewStatus.paid:
      return scheme.primaryContainer.withValues(alpha: 0.35);
    case _ParticipantPaymentViewStatus.pendingReview:
      return scheme.tertiaryContainer.withValues(alpha: 0.35);
    case _ParticipantPaymentViewStatus.unpaid:
      return scheme.errorContainer.withValues(alpha: 0.2);
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final _ParticipantPaymentViewStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final (label, icon, bgColor, textColor) = switch (status) {
      _ParticipantPaymentViewStatus.paid => (
        'Pagó',
        Icons.check_circle,
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
      _ParticipantPaymentViewStatus.pendingReview => (
        'Comprobante enviado',
        Icons.schedule,
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
      ),
      _ParticipantPaymentViewStatus.unpaid => (
        'Falta pago',
        Icons.error_outline,
        scheme.errorContainer,
        scheme.onErrorContainer,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _BulkParticipantsSheet extends ConsumerStatefulWidget {
  const _BulkParticipantsSheet({required this.eventId});

  final String eventId;

  @override
  ConsumerState<_BulkParticipantsSheet> createState() =>
      _BulkParticipantsSheetState();
}

class _BulkParticipantsSheetState
    extends ConsumerState<_BulkParticipantsSheet> {
  final _namesCtrl = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _namesCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveBulk() async {
    final names = _parseNames(_namesCtrl.text);
    if (names.isEmpty) {
      setState(() => _error = 'Pegá al menos un nombre.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final created = await ref
          .read(participantRepositoryProvider)
          .createParticipantsBulk(eventId: widget.eventId, childNames: names);
      await ref.read(appAnalyticsProvider).logParticipantsBulkAdded(created);

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Se agregaron $created participantes.')),
      );
    } catch (_) {
      setState(() => _error = 'No se pudieron agregar los participantes.');
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  List<String> _parseNames(String input) {
    return input
        .split(RegExp(r'[\n,;]'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Carga rápida de participantes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Pegá nombres separados por línea, coma o punto y coma.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _namesCtrl,
                  label: 'Lista de nombres',
                  hint: 'Juan\nMaría\nPedro',
                  maxLines: 8,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                PrimaryButton(
                  label: 'Agregar participantes',
                  loading: _saving,
                  onPressed: _saveBulk,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ParticipantEditorSheet extends ConsumerStatefulWidget {
  const _ParticipantEditorSheet({required this.eventId, this.participant});

  final String eventId;
  final ParticipantModel? participant;

  @override
  ConsumerState<_ParticipantEditorSheet> createState() =>
      _ParticipantEditorSheetState();
}

class _ParticipantEditorSheetState
    extends ConsumerState<_ParticipantEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _childCtrl;
  late final TextEditingController _familyCtrl;
  late final TextEditingController _parentCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    _childCtrl = TextEditingController(text: widget.participant?.childName);
    _familyCtrl = TextEditingController(text: widget.participant?.familyName);
    _parentCtrl = TextEditingController(text: widget.participant?.parentName);
    _phoneCtrl = TextEditingController(text: widget.participant?.parentPhone);
    _emailCtrl = TextEditingController(text: widget.participant?.parentEmail);
  }

  @override
  void dispose() {
    _childCtrl.dispose();
    _familyCtrl.dispose();
    _parentCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.participant == null) {
      await ref
          .read(participantRepositoryProvider)
          .createParticipant(
            eventId: widget.eventId,
            childName: _childCtrl.text.trim(),
            familyName: _familyCtrl.text.trim(),
            parentName: _parentCtrl.text.trim(),
            parentPhone: _phoneCtrl.text.trim(),
            parentEmail: _emailCtrl.text.trim(),
          );
    } else {
      await ref
          .read(participantRepositoryProvider)
          .updateParticipant(
            eventId: widget.eventId,
            participant: widget.participant!.copyWith(
              childName: _childCtrl.text.trim(),
              familyName: _familyCtrl.text.trim(),
              parentName: _parentCtrl.text.trim(),
              parentPhone: _phoneCtrl.text.trim(),
              parentEmail: _emailCtrl.text.trim(),
            ),
          );
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.participant == null
                        ? 'Agregar participante'
                        : 'Editar participante',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _childCtrl,
                    label: 'Nombre del hijo/a',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Campo obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: _familyCtrl,
                    label: 'Apellido/familia (opcional)',
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: _parentCtrl,
                    label: 'Nombre del padre/madre',
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: _phoneCtrl,
                    label: 'Teléfono (opcional)',
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: _emailCtrl,
                    label: 'Email (opcional)',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: widget.participant == null
                        ? 'Guardar'
                        : 'Actualizar',
                    onPressed: _save,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
