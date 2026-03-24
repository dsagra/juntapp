import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../shared/widgets/app_mobile_shell.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../providers/public_event_providers.dart';

class PublicEventPage extends ConsumerWidget {
  const PublicEventPage({super.key, required this.slug, required this.token});

  final String slug;
  final String token;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(publicEventBySlugProvider(slug));

    return AppMobileShell(
      title: 'JuntApp',
      child: eventAsync.when(
        data: (event) {
          if (event == null || !event.isActive) {
            return const _PublicMessageState(
              icon: Icons.event_busy_outlined,
              title: 'Evento no disponible',
              message: 'Este evento ya no está activo o fue despublicado.',
            );
          }

          if (!_hasValidToken(event.publicToken, token)) {
            return const _PublicMessageState(
              icon: Icons.vpn_key_outlined,
              title: 'Link inválido',
              message: 'Revisá el enlace completo que te compartieron.',
            );
          }

          final participantsAsync = ref.watch(
            publicParticipantsProvider(event.eventId),
          );
          final participants = participantsAsync.valueOrNull ?? const [];
          final activeParticipants = participants.length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroSection(
                title: event.title,
                description: event.description,
                participantsCount: activeParticipants,
              ),
              const SizedBox(height: AppConstants.sectionGap),
              Row(
                children: [
                  Expanded(
                    child: _BentoInfoCard(
                      icon: Icons.calendar_today,
                      title: 'Fecha',
                      value: AppFormatters.date(event.eventDate),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _BentoInfoCard(
                      icon: Icons.payments,
                      title: 'Monto',
                      value: AppFormatters.currency(event.amountPerParticipant),
                      emphasize: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.sectionGap),
              _TransferDetailsCard(
                alias: event.transferAlias,
                cvu: event.cvu,
                accountHolder: event.accountHolder,
              ),
              const SizedBox(height: AppConstants.sectionGap),
              FilledButton.icon(
                onPressed: () => context.push(
                  '/e/$slug/upload?token=${Uri.encodeQueryComponent(token)}',
                ),
                icon: const Icon(Icons.cloud_upload_outlined),
                label: const Text('Subir mi comprobante de pago'),
              ),
              const SizedBox(height: 8),
              Text(
                'Al subirlo, el organizador recibirá una notificación para revisarlo.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
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

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.title,
    required this.description,
    required this.participantsCount,
  });

  final String title;
  final String description;
  final int participantsCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        const BrandLogo(size: 84, showWordmark: false, center: true),
        const SizedBox(height: 10),
        Text(
          '¡Hola! Te invitaron a',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        if (description.trim().isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$participantsCount personas invitadas',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
    );
  }
}

class _BentoInfoCard extends StatelessWidget {
  const _BentoInfoCard({
    required this.icon,
    required this.title,
    required this.value,
    this.emphasize = false,
  });

  final IconData icon;
  final String title;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = emphasize
        ? scheme.primaryContainer
        : scheme.surfaceContainerLowest;
    final foreground = emphasize ? scheme.onPrimaryContainer : scheme.onSurface;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: foreground),
          const SizedBox(height: 10),
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: foreground.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}

class _TransferDetailsCard extends StatelessWidget {
  const _TransferDetailsCard({
    required this.alias,
    required this.cvu,
    required this.accountHolder,
  });

  final String alias;
  final String? cvu;
  final String accountHolder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Transferí a:', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _CopyRow(label: 'Alias', value: alias),
          if ((cvu ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            _CopyRow(label: 'CVU', value: cvu!.trim()),
          ],
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Titular',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        accountHolder,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.account_balance_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyRow extends StatelessWidget {
  const _CopyRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 2),
                Text(value, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: value));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$label copiado al portapapeles.')),
                );
              }
            },
            icon: const Icon(Icons.content_copy_outlined),
            tooltip: 'Copiar $label',
          ),
        ],
      ),
    );
  }
}

class _PublicMessageState extends StatelessWidget {
  const _PublicMessageState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        Icon(icon, size: 64, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
