import 'package:flutter/material.dart';

import '../../features/payments/models/payment_model.dart';

class PaymentStatusChip extends StatelessWidget {
  const PaymentStatusChip({super.key, required this.status});

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    late Color bg;
    const fg = Color(0xFF111111);
    late String label;

    switch (status) {
      case PaymentStatus.pending:
        bg = scheme.tertiaryContainer;
        label = 'Pendiente';
      case PaymentStatus.approved:
        bg = Colors.green.shade100;
        label = 'Aprobado';
      case PaymentStatus.rejected:
        bg = scheme.errorContainer;
        label = 'Rechazado';
    }

    return Chip(
      label: Text(label),
      backgroundColor: bg,
      labelStyle: TextStyle(color: fg),
      visualDensity: VisualDensity.compact,
    );
  }
}
