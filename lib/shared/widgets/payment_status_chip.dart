import 'package:flutter/material.dart';

import '../../features/payments/models/payment_model.dart';

class PaymentStatusChip extends StatelessWidget {
  const PaymentStatusChip({super.key, required this.status});

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    late Color bg;
    late Color fg;
    late String label;

    switch (status) {
      case PaymentStatus.pending:
        bg = scheme.tertiaryContainer;
        fg = scheme.onTertiaryContainer;
        label = 'Pendiente';
      case PaymentStatus.approved:
        bg = Colors.green.shade100;
        fg = Colors.green.shade900;
        label = 'Aprobado';
      case PaymentStatus.rejected:
        bg = scheme.errorContainer;
        fg = scheme.onErrorContainer;
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
