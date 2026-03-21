import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_date_field.dart';
import '../../../shared/widgets/app_mobile_shell.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../auth/providers/current_user_id_provider.dart';
import '../providers/event_providers.dart';

class CreateEventPage extends ConsumerStatefulWidget {
  const CreateEventPage({super.key});

  @override
  ConsumerState<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends ConsumerState<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _aliasCtrl = TextEditingController();
  final _cvuCtrl = TextEditingController();
  final _holderCtrl = TextEditingController();
  final _instructionsCtrl = TextEditingController();
  final _slugCtrl = TextEditingController();
  final _publicTokenCtrl = TextEditingController();

  DateTime? _eventDate;
  DateTime? _deadline;
  bool _isActive = true;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _amountCtrl.dispose();
    _aliasCtrl.dispose();
    _cvuCtrl.dispose();
    _holderCtrl.dispose();
    _instructionsCtrl.dispose();
    _slugCtrl.dispose();
    _publicTokenCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_eventDate == null || _deadline == null) {
      setState(() => _error = 'Seleccioná fecha del evento y fecha límite.');
      return;
    }

    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      setState(() => _error = 'Tu sesión expiró. Volvé a ingresar.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final amount = double.parse(_amountCtrl.text.trim());
      if (amount <= 0) {
        throw StateError('El monto debe ser mayor a 0.');
      }

      final eventId = await ref
          .read(eventRepositoryProvider)
          .createEvent(
            title: _titleCtrl.text.trim(),
            description: _descriptionCtrl.text.trim(),
            eventDate: _eventDate!,
            paymentDeadline: _deadline!,
            amountPerParticipant: amount,
            transferAlias: _aliasCtrl.text.trim(),
            cvu: _cvuCtrl.text.trim().isEmpty ? null : _cvuCtrl.text.trim(),
            accountHolder: _holderCtrl.text.trim(),
            instructions: _instructionsCtrl.text.trim(),
            isActive: _isActive,
            slug: _slugCtrl.text.trim().toLowerCase(),
            publicToken: _publicTokenCtrl.text.trim().isEmpty
                ? null
                : _publicTokenCtrl.text.trim(),
            createdBy: userId,
          );

      if (mounted) {
        context.go('/events/$eventId');
      }
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('StateError: ', ''));
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppMobileShell(
      title: 'Crear evento',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _titleCtrl,
              label: 'Título',
              validator: _required,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _descriptionCtrl,
              label: 'Descripción',
              maxLines: 3,
              validator: _required,
            ),
            const SizedBox(height: 12),
            AppDateField(
              label: 'Fecha del evento',
              value: _eventDate,
              onChanged: (value) => setState(() => _eventDate = value),
            ),
            const SizedBox(height: 12),
            AppDateField(
              label: 'Fecha límite de pago',
              value: _deadline,
              onChanged: (value) => setState(() => _deadline = value),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _amountCtrl,
              label: 'Monto por participante',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return 'Campo obligatorio';
                final amount = double.tryParse(text);
                if (amount == null || amount <= 0) return 'Monto inválido';
                return null;
              },
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _aliasCtrl,
              label: 'Alias de transferencia',
              validator: _required,
            ),
            const SizedBox(height: 12),
            AppTextField(controller: _cvuCtrl, label: 'CVU (opcional)'),
            const SizedBox(height: 12),
            AppTextField(
              controller: _holderCtrl,
              label: 'Titular de la cuenta',
              validator: _required,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _instructionsCtrl,
              label: 'Instrucciones',
              maxLines: 3,
              validator: _required,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _slugCtrl,
              label: 'Slug público',
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return 'Campo obligatorio';
                if (!RegExp(r'^[a-z0-9-]+$').hasMatch(text)) {
                  return 'Usá minúsculas, números y guiones';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _publicTokenCtrl,
              label: 'Token público (opcional)',
            ),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              value: _isActive,
              title: const Text('Evento activo'),
              contentPadding: EdgeInsets.zero,
              onChanged: (value) => setState(() => _isActive = value),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Crear evento',
              loading: _saving,
              onPressed: _save,
            ),
          ],
        ),
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
