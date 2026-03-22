import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_constants.dart';
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
          final token = event.publicToken ?? '';
          final publicLink = token.isEmpty
              ? '/e/${event.slug}'
              : '/e/${event.slug}?token=${Uri.encodeQueryComponent(token)}';
          final absolutePublicLink = _buildAbsolutePublicLink(publicLink);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(event.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(event.description),
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
                title: 'Estado y métricas',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      onPressed: () => _shareEventLink(
                        context: context,
                        eventTitle: event.title,
                        eventDate: event.eventDate,
                        publicLink: absolutePublicLink,
                      ),
                      icon: const Icon(Icons.share_outlined),
                      label: const Text('Compartir por WhatsApp o email'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.sectionGap),
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
        eventTitle: eventTitle,
        message: message,
        absoluteLink: absoluteLink,
      );
      return;
    }

    try {
      await Share.share(message, subject: 'Invitación y pago - $eventTitle');
    } catch (_) {
      await _showShareFallback(
        context: context,
        eventTitle: eventTitle,
        message: message,
        absoluteLink: absoluteLink,
      );
    }
  }

  Future<void> _showShareFallback({
    required BuildContext context,
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
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy_outlined),
                title: const Text('Copiar link'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await Clipboard.setData(ClipboardData(text: absoluteLink));
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
            'Esta acción no se puede deshacer. Se borrarán participantes, pagos y link público.',
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

      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Evento eliminado.')));
      context.go('/dashboard');
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo eliminar el evento.')),
      );
    }
  }
}
