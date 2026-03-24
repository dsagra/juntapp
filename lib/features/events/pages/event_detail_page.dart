import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/analytics_providers.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../shared/widgets/app_mobile_shell.dart';
import '../../../shared/widgets/section_card.dart';
import '../../participants/providers/participant_providers.dart';
import '../../participants/models/participant_model.dart';
import '../../payments/providers/payment_providers.dart';
import '../../payments/models/payment_model.dart';
import '../providers/event_providers.dart';

class EventDetailPage extends ConsumerWidget {
  const EventDetailPage({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventByIdProvider(eventId));
    final participantsAsync = ref.watch(participantsProvider(eventId));
    final paymentsAsync = ref.watch(paymentsProvider(eventId));
    final participantsCount = ref.watch(participantsCountProvider(eventId));
    final approvedCount = ref.watch(approvedPaymentsCountProvider(eventId));
    final pendingCount = ref.watch(pendingPaymentsCountProvider(eventId));

    return AppMobileShell(
      title: 'Detalle del evento',
      child: eventAsync.when(
        data: (event) {
          final participants = participantsCount.valueOrNull ?? 0;
          final participantsList = participantsAsync.valueOrNull ?? const [];
          final paymentsList = paymentsAsync.valueOrNull ?? const [];
          final recentActivity = _buildRecentActivity(
            payments: paymentsList,
            participants: participantsList,
          );
          final hasParticipants = participants > 0;
          final approved = approvedCount.valueOrNull ?? 0;
          final pending = pendingCount.valueOrNull ?? 0;
          final missing = (participants - approved - pending).clamp(
            0,
            participants,
          );
          final expectedTotal = participants * event.amountPerParticipant;
          final approvedAmount = approved * event.amountPerParticipant;
          final remainingAmount = (expectedTotal - approvedAmount).clamp(
            0,
            expectedTotal,
          );
          final progress = participants == 0 ? 0.0 : approved / participants;
          final progressPct = (progress * 100).round();
          final token = event.publicToken ?? '';
          final publicLink = token.isEmpty
              ? '/e/${event.slug}'
              : '/e/${event.slug}?token=${Uri.encodeQueryComponent(token)}';
          final absolutePublicLink = _buildAbsolutePublicLink(publicLink);
          final scheme = Theme.of(context).colorScheme;
          final textTheme = Theme.of(context).textTheme;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(event.title, style: textTheme.titleLarge),
              if (event.description.trim().isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(event.description),
              ],
              const SizedBox(height: AppConstants.sectionGap),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total recaudado',
                      style: textTheme.labelLarge?.copyWith(
                        color: scheme.primary,
                      ),
                    ),
                    Text(
                      '${AppFormatters.currency(approvedAmount)} de ${AppFormatters.currency(expectedTotal)}',
                      style: textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: scheme.outlineVariant.withValues(
                          alpha: 0.35,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$progressPct% completado',
                            style: textTheme.bodySmall,
                          ),
                        ),
                        Text(
                          'Faltan ${AppFormatters.currency(remainingAmount)}',
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.sectionGap),
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      icon: Icons.check_circle,
                      iconColor: scheme.primary,
                      value: '$approved/$participants',
                      label: 'Pagados',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricTile(
                      icon: Icons.pending,
                      iconColor: scheme.tertiary,
                      value: '$pending',
                      label: 'Revisiones',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _MetricTile(
                icon: Icons.error,
                iconColor: scheme.error,
                value: '$missing',
                label: 'Faltan pagar',
                compact: false,
              ),
              const SizedBox(height: AppConstants.sectionGap),
              SectionCard(
                title: 'Información del evento',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.sectionGap),
              SectionCard(
                title: 'Link público',
                subtitle:
                    'Compartilo por WhatsApp para que cada familia complete su carga.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(absolutePublicLink),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: hasParticipants
                          ? () => _shareEventLink(
                              context: context,
                              ref: ref,
                              eventTitle: event.title,
                              eventDate: event.eventDate,
                              publicLink: absolutePublicLink,
                            )
                          : null,
                      icon: const Icon(Icons.share_outlined),
                      label: const Text('Compartir link público'),
                    ),
                    if (!hasParticipants) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Primero agregá al menos un participante para habilitar el link.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.sectionGap),
              SectionCard(
                title: 'Última actividad',
                child: recentActivity.isEmpty
                    ? const Text('Aún no hay actividad reciente.')
                    : Column(
                        children: recentActivity
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _ActivityTile(item: item),
                              ),
                            )
                            .toList(growable: false),
                      ),
              ),
              const SizedBox(height: AppConstants.sectionGap),
              FilledButton.icon(
                onPressed: () => context.push('/events/$eventId/participants'),
                icon: const Icon(Icons.person_add_alt_1_outlined),
                label: const Text('Agregar / administrar participantes'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => context.push('/events/$eventId/payments'),
                icon: const Icon(Icons.receipt_long_outlined),
                label: const Text('Revisar pagos'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => _confirmDeleteEvent(
                  context: context,
                  ref: ref,
                  eventId: event.id,
                  slug: event.slug,
                ),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Eliminar evento'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Text('Error: $error'),
      ),
    );
  }

  Future<void> _shareEventLink({
    required BuildContext context,
    required WidgetRef ref,
    required String eventTitle,
    required DateTime eventDate,
    required String publicLink,
  }) async {
    final absoluteLink = publicLink;

    final message =
        '''🎉 ¡Sumate a "$eventTitle"!

Estamos organizando el aporte de forma simple con JuntApp 💚
Podés confirmar y cargar tu pago en segundos.

📅 Fecha del evento: ${AppFormatters.date(eventDate)}
🔗 Link seguro: $absoluteLink

¡Gracias por participar!''';

    if (kIsWeb) {
      await _showShareFallback(
        context: context,
        ref: ref,
        eventTitle: eventTitle,
        message: message,
        absoluteLink: absoluteLink,
      );
      return;
    }

    try {
      await Share.share(message, subject: 'Invitación y pago - $eventTitle');
      await ref.read(appAnalyticsProvider).logPublicLinkShared('native_share');
    } catch (_) {
      await _showShareFallback(
        context: context,
        ref: ref,
        eventTitle: eventTitle,
        message: message,
        absoluteLink: absoluteLink,
      );
    }
  }

  Future<void> _showShareFallback({
    required BuildContext context,
    required WidgetRef ref,
    required String eventTitle,
    required String message,
    required String absoluteLink,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.chat_outlined),
                title: const Text('Compartir por WhatsApp'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  final whatsappMessage = [
                    '🎉 ¡Sumate a "$eventTitle"!',
                    'Juntar plata ahora es más fácil 💚',
                    '🔗 $absoluteLink',
                  ].join('\n\n');

                  final uri = Uri.https('api.whatsapp.com', '/send', {
                    'text': whatsappMessage,
                  });
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                  await ref
                      .read(appAnalyticsProvider)
                      .logPublicLinkShared('whatsapp');
                },
              ),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Compartir por email'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  final subject = Uri.encodeComponent(
                    'Invitación y pago - $eventTitle',
                  );
                  final body = Uri.encodeComponent(message);
                  final uri = Uri.parse('mailto:?subject=$subject&body=$body');
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                  await ref
                      .read(appAnalyticsProvider)
                      .logPublicLinkShared('email');
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy_outlined),
                title: const Text('Copiar link'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await Clipboard.setData(ClipboardData(text: absoluteLink));
                  await ref
                      .read(appAnalyticsProvider)
                      .logPublicLinkShared('copy_link');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Link copiado al portapapeles'),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  List<_ActivityItem> _buildRecentActivity({
    required List<PaymentModel> payments,
    required List<ParticipantModel> participants,
  }) {
    final items = <_ActivityItem>[];

    for (final payment in payments) {
      switch (payment.status) {
        case PaymentStatus.pending:
          items.add(
            _ActivityItem(
              timestamp: payment.uploadedAt,
              title: '${payment.payerName} subió su comprobante',
              subtitle: 'Pendiente de revisión',
              icon: Icons.receipt_long,
              iconColorRole: _ActivityColorRole.tertiary,
              trailingLabel: 'Revisar',
            ),
          );
        case PaymentStatus.approved:
          items.add(
            _ActivityItem(
              timestamp: payment.reviewedAt ?? payment.uploadedAt,
              title:
                  '${payment.payerName} pagó ${AppFormatters.currency(payment.amount)}',
              subtitle: 'Pago aprobado',
              icon: Icons.check_circle,
              iconColorRole: _ActivityColorRole.primary,
            ),
          );
        case PaymentStatus.rejected:
          items.add(
            _ActivityItem(
              timestamp: payment.reviewedAt ?? payment.uploadedAt,
              title: '${payment.payerName} requiere corrección',
              subtitle: payment.rejectReason?.trim().isNotEmpty == true
                  ? payment.rejectReason!
                  : 'Comprobante rechazado',
              icon: Icons.error,
              iconColorRole: _ActivityColorRole.error,
            ),
          );
      }
    }

    for (final participant in participants) {
      items.add(
        _ActivityItem(
          timestamp: participant.createdAt,
          title: '${participant.childName} se unió al evento',
          subtitle: 'Participante agregado',
          icon: Icons.person_add,
          iconColorRole: _ActivityColorRole.secondary,
        ),
      );
    }

    items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return items.take(3).toList(growable: false);
  }

  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Hace instantes';
    if (diff.inHours < 1) return 'Hace ${diff.inMinutes} min';
    if (diff.inDays < 1) return 'Hace ${diff.inHours} h';
    if (diff.inDays == 1) return 'Ayer';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} días';
    return AppFormatters.date(dateTime);
  }

  String _buildAbsolutePublicLink(String publicPath) {
    final currentUri = Uri.base;
    if (currentUri.fragment.startsWith('/')) {
      return '${currentUri.origin}/#$publicPath';
    }
    return '${currentUri.origin}$publicPath';
  }

  Future<void> _confirmDeleteEvent({
    required BuildContext context,
    required WidgetRef ref,
    required String eventId,
    required String slug,
  }) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar evento'),
          content: const Text(
            'El evento se archivará: dejará de aparecer en tu tablero y el link público se desactivará.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    try {
      await ref
          .read(eventRepositoryProvider)
          .deleteEvent(eventId: eventId, slug: slug);
      await ref.read(appAnalyticsProvider).logEventDeleted();

      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Evento archivado.')));
      context.go('/dashboard');
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo eliminar el evento.')),
      );
    }
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.compact = true,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
      ),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(height: 8),
                Text(value, style: textTheme.titleLarge),
                Text(label, style: textTheme.labelSmall),
              ],
            )
          : Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(value, style: textTheme.titleLarge),
                      Text(label, style: textTheme.labelSmall),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: scheme.outline),
              ],
            ),
    );
  }
}

enum _ActivityColorRole { primary, secondary, tertiary, error }

class _ActivityItem {
  const _ActivityItem({
    required this.timestamp,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColorRole,
    this.trailingLabel,
  });

  final DateTime timestamp;
  final String title;
  final String subtitle;
  final IconData icon;
  final _ActivityColorRole iconColorRole;
  final String? trailingLabel;
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.item});

  final _ActivityItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Color iconBackground;
    Color iconColor;
    switch (item.iconColorRole) {
      case _ActivityColorRole.primary:
        iconBackground = scheme.primaryContainer;
        iconColor = scheme.onPrimaryContainer;
      case _ActivityColorRole.secondary:
        iconBackground = scheme.secondaryContainer;
        iconColor = scheme.onSecondaryContainer;
      case _ActivityColorRole.tertiary:
        iconBackground = scheme.tertiaryContainer;
        iconColor = scheme.onTertiaryContainer;
      case _ActivityColorRole.error:
        iconBackground = scheme.errorContainer;
        iconColor = scheme.onErrorContainer;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
      ),
      child: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Icon(item.icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  '${item.subtitle} · ${EventDetailPage.timeAgo(item.timestamp)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if ((item.trailingLabel ?? '').isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: scheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                item.trailingLabel!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.onTertiaryContainer,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
