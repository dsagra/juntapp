import 'package:flutter/material.dart';

import '../../../core/utils/app_formatters.dart';
import '../models/event_model.dart';

class EventSummaryCard extends StatelessWidget {
  const EventSummaryCard({
    super.key,
    required this.event,
    required this.totalParticipants,
    required this.approvedPayments,
    required this.pendingPayments,
    required this.onTap,
  });

  final EventModel event;
  final int totalParticipants;
  final int approvedPayments;
  final int pendingPayments;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Icon(Icons.chevron_right, color: scheme.primary),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                event.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text('Fecha: ${AppFormatters.date(event.eventDate)}'),
              Text(
                'Monto: ${AppFormatters.currency(event.amountPerParticipant)}',
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _MiniStat(
                    label: 'Participantes',
                    value: '$totalParticipants',
                  ),
                  _MiniStat(label: 'Aprobados', value: '$approvedPayments'),
                  _MiniStat(label: 'Pendientes', value: '$pendingPayments'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: scheme.onSurface),
          ),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
