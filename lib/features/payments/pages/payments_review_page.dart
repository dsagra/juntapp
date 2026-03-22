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

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: payments
                .map((payment) {
                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: AppConstants.sectionGap,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            payment.childName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text('Pagador: ${payment.payerName}'),
                          Text(
                            'Monto: ${AppFormatters.currency(payment.amount)}',
                          ),
                          Text(
                            'Fecha: ${AppFormatters.date(payment.uploadedAt)}',
                          ),
                          const SizedBox(height: 8),
                          PaymentStatusChip(status: payment.status),
                          if ((payment.rejectReason ?? '').isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text('Motivo: ${payment.rejectReason}'),
                            ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if ((payment.receiptUrl ?? '').isNotEmpty ||
                                  (payment.receiptPath ?? '').isNotEmpty)
                                OutlinedButton.icon(
                                  onPressed: () =>
                                      _openReceipt(context, ref, payment),
                                  icon: const Icon(Icons.open_in_new),
                                  label: const Text('Ver comprobante'),
                                )
                              else
                                const Chip(label: Text('Sin comprobante')),
                              if (payment.status == PaymentStatus.pending)
                                FilledButton(
                                  onPressed: () =>
                                      _approve(context, ref, payment.id),
                                  child: const Text('Aprobar'),
                                ),
                              if (payment.status == PaymentStatus.pending)
                                OutlinedButton(
                                  onPressed: () =>
                                      _reject(context, ref, payment.id),
                                  child: const Text('Rechazar'),
                                ),
                            ],
                          ),
                        ],
                      ),
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
