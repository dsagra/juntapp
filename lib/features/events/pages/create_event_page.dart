import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/app_date_field.dart';
import '../../../shared/widgets/app_mobile_shell.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/section_card.dart';
import '../../auth/providers/current_user_id_provider.dart';
import '../providers/event_providers.dart';

class CreateEventPage extends ConsumerStatefulWidget {
  const CreateEventPage({super.key});

  @override
  ConsumerState<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends ConsumerState<CreateEventPage> {
  static const _uuid = Uuid();

  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _aliasCtrl = TextEditingController();
  final _cvuCtrl = TextEditingController();
  final _holderCtrl = TextEditingController();
  final _slugCtrl = TextEditingController();
  final _publicTokenCtrl = TextEditingController();

  DateTime? _eventDate;
  DateTime? _deadline;
  bool _isActive = true;
  bool _saving = false;
  String? _error;
  bool _slugEditedManually = false;
  bool _isApplyingAutoSlug = false;

  @override
  void initState() {
    super.initState();
    _publicTokenCtrl.text = _generatePublicToken();
    _titleCtrl.addListener(_onTitleChanged);
    _slugCtrl.addListener(_onSlugChanged);
  }

  @override
  void dispose() {
    _titleCtrl.removeListener(_onTitleChanged);
    _slugCtrl.removeListener(_onSlugChanged);
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _amountCtrl.dispose();
    _aliasCtrl.dispose();
    _cvuCtrl.dispose();
    _holderCtrl.dispose();
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
            isActive: _isActive,
            slug: _slugCtrl.text.trim().toLowerCase(),
            publicToken: _publicTokenCtrl.text.trim(),
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
            Text(
              'Configurá tu evento en pocos pasos',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              'La invitación pública se genera automáticamente con el slug.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppConstants.sectionGap),
            SectionCard(
              title: 'Información del evento',
              child: Column(
                children: [
                  AppTextField(
                    controller: _titleCtrl,
                    label: 'Título',
                    prefixIcon: Icons.celebration_outlined,
                    validator: _required,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _descriptionCtrl,
                    label: 'Descripción',
                    hint: 'Cumpleaños, cena, regalo, salida, etc.',
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
                    hint: 'Ej: 15000',
                    prefixIcon: Icons.payments_outlined,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return 'Campo obligatorio';
                      final amount = double.tryParse(text);
                      if (amount == null || amount <= 0)
                        return 'Monto inválido';
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.sectionGap),
            SectionCard(
              title: 'Datos de pago',
              child: Column(
                children: [
                  AppTextField(
                    controller: _aliasCtrl,
                    label: 'Alias de transferencia',
                    prefixIcon: Icons.account_balance_outlined,
                    validator: _required,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _cvuCtrl,
                    label: 'CVU (opcional)',
                    prefixIcon: Icons.numbers_outlined,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _holderCtrl,
                    label: 'Titular de la cuenta',
                    prefixIcon: Icons.person_outline,
                    validator: _required,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.sectionGap),
            SectionCard(
              title: 'Publicación y estado',
              child: Column(
                children: [
                  AppTextField(
                    controller: _slugCtrl,
                    label: 'Slug público',
                    hint: 'cumple-juan-2026',
                    prefixIcon: Icons.link_outlined,
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
                    label: 'Token público',
                    prefixIcon: Icons.password_outlined,
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return 'Campo obligatorio';
                      if (text.length < 8) return 'Usá al menos 8 caracteres';
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile.adaptive(
                    value: _isActive,
                    title: const Text('Evento activo'),
                    subtitle: const Text(
                      'Si está activo, el link público funciona.',
                    ),
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) => setState(() => _isActive = value),
                  ),
                ],
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: AppConstants.sectionGap),
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

  String _generatePublicToken() {
    return _uuid.v4().replaceAll('-', '').substring(0, 16);
  }

  void _onTitleChanged() {
    if (_slugEditedManually) return;

    final generated = _slugify(_titleCtrl.text);
    if (_slugCtrl.text == generated) return;

    _isApplyingAutoSlug = true;
    _slugCtrl.value = _slugCtrl.value.copyWith(
      text: generated,
      selection: TextSelection.collapsed(offset: generated.length),
      composing: TextRange.empty,
    );
    _isApplyingAutoSlug = false;
  }

  void _onSlugChanged() {
    if (_isApplyingAutoSlug) return;

    final slug = _slugCtrl.text.trim();
    if (slug.isEmpty) {
      _slugEditedManually = false;
      _onTitleChanged();
      return;
    }

    final generated = _slugify(_titleCtrl.text);
    _slugEditedManually = slug != generated;
  }

  String _slugify(String input) {
    final normalized = input
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[áàäâ]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöô]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        .replaceAll('ñ', 'n');

    return normalized
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-{2,}'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }
}
