import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../shared/widgets/app_dropdown_field.dart';
import '../../../shared/widgets/app_mobile_shell.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../payments/providers/payment_providers.dart';
import '../providers/public_event_providers.dart';
import '../widgets/receipt_uploader.dart';

class UploadReceiptPage extends ConsumerStatefulWidget {
  const UploadReceiptPage({super.key, required this.slug, required this.token});

  final String slug;
  final String token;

  @override
  ConsumerState<UploadReceiptPage> createState() => _UploadReceiptPageState();
}

class _UploadReceiptPageState extends ConsumerState<UploadReceiptPage> {
  final _formKey = GlobalKey<FormState>();
  final _payerCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String? _participantId;
  PickedReceipt? _receipt;
  bool _saving = false;
  String? _error;
  bool _amountPrefilled = false;

  @override
  void dispose() {
    _payerCtrl.dispose();
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(String eventId) async {
    if (!_formKey.currentState!.validate()) return;

    if (_participantId == null) {
      setState(() => _error = 'Seleccioná a tu hijo/a.');
      return;
    }

    if (_receipt == null) {
      setState(() => _error = 'El comprobante es obligatorio.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final participants = await ref.read(
        publicParticipantsProvider(eventId).future,
      );
      final participant = participants.firstWhere(
        (p) => p.id == _participantId,
      );

      await ref
          .read(paymentRepositoryProvider)
          .submitPayment(
            eventId: eventId,
            participantId: participant.id,
            childName: participant.childName,
            payerName: _payerCtrl.text.trim(),
            amount: double.parse(_amountCtrl.text.trim()),
            notes: _notesCtrl.text.trim(),
            fileBytes: _receipt!.bytes,
            fileExtension: _receipt!.extension,
            receiptType: _receipt!.mimeType,
          );

      if (mounted) {
        context.go(
          '/e/${widget.slug}/success?token=${Uri.encodeQueryComponent(widget.token)}',
        );
      }
    } catch (e) {
      setState(() => _error = 'No pudimos enviar el comprobante: $e');
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(publicEventBySlugProvider(widget.slug));

    return AppMobileShell(
      title: 'Enviar pago',
      child: eventAsync.when(
        data: (event) {
          if (event == null || !event.isActive) {
            return const _UploadMessageState(
              icon: Icons.event_busy_outlined,
              title: 'Evento no disponible',
              message: 'Este evento ya no acepta comprobantes.',
            );
          }

          if (!_amountPrefilled) {
            _amountCtrl.text = _formatAmount(event.amountPerParticipant);
            _amountPrefilled = true;
          }

          if (!_hasValidToken(event.publicToken, widget.token)) {
            return const _UploadMessageState(
              icon: Icons.vpn_key_outlined,
              title: 'Link inválido',
              message: 'Revisá que el enlace tenga el token completo.',
            );
          }

          final participantsAsync = ref.watch(
            publicParticipantsProvider(event.eventId),
          );

          return participantsAsync.when(
            data: (participants) {
              if (participants.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppConstants.sectionGap),
                    Icon(
                      Icons.celebration_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '¡Ya pagaron todos! 🎉',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Muchas gracias por participar. No quedan personas pendientes para cargar pago.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.sectionGap),
                    FilledButton(
                      onPressed: () => context.go(
                        '/e/${widget.slug}?token=${Uri.encodeQueryComponent(widget.token)}',
                      ),
                      child: const Text('Volver al evento'),
                    ),
                  ],
                );
              }

              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(
                          AppConstants.cardRadius,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detalle del pago',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  event.title,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                              Text(
                                AppFormatters.currency(
                                  event.amountPerParticipant,
                                ),
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.sectionGap),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(
                          AppConstants.cardRadius,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppDropdownField<String>(
                            label: 'Hijo/a',
                            prefixIcon: Icons.child_care_outlined,
                            value: _participantId,
                            items: participants
                                .map(
                                  (participant) => DropdownMenuItem(
                                    value: participant.id,
                                    child: Text(participant.childName),
                                  ),
                                )
                                .toList(growable: false),
                            onChanged: (value) =>
                                setState(() => _participantId = value),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            controller: _payerCtrl,
                            label: 'Nombre de quien pagó',
                            prefixIcon: Icons.person_outline,
                            validator: _required,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _amountCtrl,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Monto a transferir',
                              prefixIcon: Icon(Icons.payments_outlined),
                            ),
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            controller: _notesCtrl,
                            label: 'Nota (opcional)',
                            hint: 'Dato extra para el organizador',
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.sectionGap),
                    Text(
                      'Adjuntar comprobante',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    ReceiptUploader(
                      onChanged: (receipt) {
                        setState(() {
                          _receipt = receipt;
                          if (receipt != null &&
                              _error == 'El comprobante es obligatorio.') {
                            _error = null;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Asegurate de que el número de operación y el monto sean visibles.',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppConstants.sectionGap),
                    FilledButton.icon(
                      onPressed: _saving ? null : () => _submit(event.eventId),
                      icon: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.cloud_upload_outlined),
                      label: Text(
                        _saving
                            ? 'Enviando comprobante...'
                            : 'Enviar comprobante',
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('Error: $error'),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Text('Error: $error'),
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obligatorio';
    }
    return null;
  }

  bool _hasValidToken(String? expected, String received) {
    if (expected == null || expected.isEmpty) return false;
    return received.isNotEmpty && received == expected;
  }

  String _formatAmount(double amount) {
    final hasDecimals = amount != amount.truncateToDouble();
    return hasDecimals ? amount.toStringAsFixed(2) : amount.toInt().toString();
  }
}

class _UploadMessageState extends StatelessWidget {
  const _UploadMessageState({
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
