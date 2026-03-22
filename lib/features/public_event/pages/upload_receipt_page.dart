import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_dropdown_field.dart';
import '../../../shared/widgets/app_mobile_shell.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../payments/providers/payment_providers.dart';
import '../providers/public_event_providers.dart';
import '../widgets/receipt_uploader.dart';

class UploadReceiptPage extends ConsumerStatefulWidget {
  const UploadReceiptPage({super.key, required this.slug});

  final String slug;

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
            fileBytes: _receipt?.bytes,
            fileExtension: _receipt?.extension,
            receiptType: _receipt?.mimeType,
          );

      if (mounted) {
        context.go('/e/${widget.slug}/success');
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
      title: 'Subir comprobante',
      child: eventAsync.when(
        data: (event) {
          if (event == null) {
            return const Text('Evento no encontrado');
          }

          final participantsAsync = ref.watch(
            publicParticipantsProvider(event.eventId),
          );

          return participantsAsync.when(
            data: (participants) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Completá estos datos para confirmar tu pago',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    AppDropdownField<String>(
                      label: 'Hijo/a',
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
                      validator: _required,
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _amountCtrl,
                      label: 'Monto abonado',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) {
                          return 'Campo obligatorio';
                        }
                        final amount = double.tryParse(text);
                        if (amount == null || amount <= 0) {
                          return 'Monto inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _notesCtrl,
                      label: 'Nota (opcional)',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    ReceiptUploader(onChanged: (receipt) => _receipt = receipt),
                    const SizedBox(height: 8),
                    Text(
                      'Subir comprobante es opcional por ahora.',
                      style: Theme.of(context).textTheme.bodySmall,
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
                    const SizedBox(height: 16),
                    PrimaryButton(
                      label: 'Enviar comprobante',
                      loading: _saving,
                      onPressed: () => _submit(event.eventId),
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
}
