import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../shared/widgets/app_mobile_shell.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/payment_status_chip.dart';
import '../../auth/providers/current_user_id_provider.dart';
import '../models/payment_model.dart';
import '../providers/payment_providers.dart';

class PaymentsReviewPage extends ConsumerWidget {
  const PaymentsReviewPage({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(paymentsProvider(eventId));

    return AppMobileShell(
      title: 'Revisión de pagos',
      child: paymentsAsync.when(
        data: (payments) {
          if (payments.isEmpty) {
            return const EmptyStateWidget(
              title: 'Sin pagos cargados',
              subtitle:
                  'Los comprobantes aparecerán acá para aprobar o rechazar.',
              icon: Icons.receipt_long_outlined,
            );
          }

          final pendingPayments = payments
              .where((payment) => payment.status == PaymentStatus.pending)
              .toList(growable: false);

          final orderedPayments = [...payments]
            ..sort((a, b) {
              final aPending = a.status == PaymentStatus.pending ? 0 : 1;
              final bPending = b.status == PaymentStatus.pending ? 0 : 1;
              final rankCompare = aPending.compareTo(bPending);
              if (rankCompare != 0) return rankCompare;
              return b.uploadedAt.compareTo(a.uploadedAt);
            });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: pendingPayments.isNotEmpty
                            ? Theme.of(context).colorScheme.tertiary
                            : Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        pendingPayments.isNotEmpty
                            ? '${pendingPayments.length} pago(s) pendiente(s) por revisar'
                            : 'No hay pagos pendientes por revisar',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ...orderedPayments.map(
                (payment) => _PaymentReviewCard(
                  payment: payment,
                  onOpenReceipt: () => _openReceipt(context, ref, payment),
                  onApprove: payment.status == PaymentStatus.pending
                      ? () => _approve(context, ref, payment.id)
                      : null,
                  onReject: payment.status == PaymentStatus.pending
                      ? () => _reject(context, ref, payment.id)
                      : null,
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Text('Error: $error'),
      ),
    );
  }

  Future<void> _openReceipt(
    BuildContext context,
    WidgetRef ref,
    PaymentModel payment,
  ) async {
    try {
      final directUrl = payment.receiptUrl;
      final url = (directUrl != null && directUrl.isNotEmpty)
          ? directUrl
          : await ref
                .read(paymentRepositoryProvider)
                .resolveReceiptUrl(payment.receiptPath!);

      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el comprobante.')),
      );
    }
  }

  Future<void> _approve(
    BuildContext context,
    WidgetRef ref,
    String paymentId,
  ) async {
    final reviewer = ref.read(currentUserIdProvider);
    if (reviewer == null) return;

    await ref
        .read(paymentRepositoryProvider)
        .approvePayment(
          eventId: eventId,
          paymentId: paymentId,
          reviewerId: reviewer,
        );
  }

  Future<void> _reject(
    BuildContext context,
    WidgetRef ref,
    String paymentId,
  ) async {
    final reviewer = ref.read(currentUserIdProvider);
    if (reviewer == null) return;

    final reasonCtrl = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Motivo del rechazo'),
          content: TextField(
            controller: reasonCtrl,
            decoration: const InputDecoration(labelText: 'Motivo'),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                final reason = reasonCtrl.text.trim();
                if (reason.isEmpty) return;
                await ref
                    .read(paymentRepositoryProvider)
                    .rejectPayment(
                      eventId: eventId,
                      paymentId: paymentId,
                      reviewerId: reviewer,
                      reason: reason,
                    );
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('Rechazar'),
            ),
          ],
        );
      },
    );

    reasonCtrl.dispose();
  }
}

class _PaymentReviewCard extends StatelessWidget {
  const _PaymentReviewCard({
    required this.payment,
    required this.onOpenReceipt,
    required this.onApprove,
    required this.onReject,
  });

  final PaymentModel payment;
  final VoidCallback onOpenReceipt;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    final initials = _initials(payment.payerName);

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.sectionGap),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${payment.payerName} subió comprobante por ${AppFormatters.currency(payment.amount)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${payment.childName} • ${AppFormatters.date(payment.uploadedAt)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            PaymentStatusChip(status: payment.status),
            if (payment.notes.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  payment.notes,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
            if ((payment.rejectReason ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Motivo: ${payment.rejectReason}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            if ((payment.receiptUrl ?? '').isNotEmpty ||
                (payment.receiptPath ?? '').isNotEmpty)
              OutlinedButton.icon(
                onPressed: onOpenReceipt,
                icon: const Icon(Icons.visibility_outlined),
                label: const Text('Ver comprobante'),
              )
            else
              const Chip(label: Text('Sin comprobante')),
            if (onApprove != null) ...[
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: onApprove,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Aprobar pago'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: onReject,
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Rechazar'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _initials(String fullName) {
    final words = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList(growable: false);
    if (words.isEmpty) return '?';
    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    }
    final firstInitial = words.first.substring(0, 1).toUpperCase();
    final lastInitial = words.last.substring(0, 1).toUpperCase();
    return '$firstInitial$lastInitial';
  }
}
