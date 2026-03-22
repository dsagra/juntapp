import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_mobile_shell.dart';
import '../../../shared/widgets/brand_logo.dart';

class UploadSuccessPage extends StatelessWidget {
  const UploadSuccessPage({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    return AppMobileShell(
      title: 'Comprobante enviado',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BrandLogo(size: 112, showWordmark: false),
          const SizedBox(height: 8),
          Icon(
            Icons.check_circle,
            size: 72,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            '¡Listo! Recibimos tu comprobante.',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'El organizador lo revisará y te confirmará el estado.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => context.go('/e/$slug'),
            child: const Text('Volver al evento'),
          ),
        ],
      ),
    );
  }
}
