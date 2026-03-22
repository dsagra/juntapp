import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/app_mobile_shell.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/primary_button.dart';
import '../models/participant_model.dart';
import '../providers/participant_providers.dart';

class ParticipantsPage extends ConsumerWidget {
  const ParticipantsPage({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participantsAsync = ref.watch(participantsProvider(eventId));

    return AppMobileShell(
      title: 'Participantes',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context, ref),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Agregar'),
      ),
      child: participantsAsync.when(
        data: (participants) {
          if (participants.isEmpty) {
            return const EmptyStateWidget(
              title: 'No hay participantes',
              subtitle:
                  'Agregá el primer participante para habilitar el flujo público.',
              icon: Icons.groups_2_outlined,
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: participants
                .map((participant) {
                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: AppConstants.sectionGap,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      title: Text(participant.childName),
                      subtitle: Text(
                        [
                          if ((participant.familyName ?? '').isNotEmpty)
                            participant.familyName,
                          if ((participant.parentName ?? '').isNotEmpty)
                            participant.parentName,
                        ].join(' • '),
                      ),
                      trailing: Wrap(
                        spacing: 2,
                        children: [
                          IconButton(
                            onPressed: () => _openEditor(
                              context,
                              ref,
                              participant: participant,
                            ),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                          IconButton(
                            onPressed: () => ref
                                .read(participantRepositoryProvider)
                                .deleteParticipant(
                                  eventId: eventId,
                                  participantId: participant.id,
                                ),
                            icon: const Icon(Icons.delete_outline),
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

  Future<void> _openEditor(
    BuildContext context,
    WidgetRef ref, {
    ParticipantModel? participant,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _ParticipantEditorSheet(
          eventId: eventId,
          participant: participant,
        );
      },
    );
  }
}

class _ParticipantEditorSheet extends ConsumerStatefulWidget {
  const _ParticipantEditorSheet({required this.eventId, this.participant});

  final String eventId;
  final ParticipantModel? participant;

  @override
  ConsumerState<_ParticipantEditorSheet> createState() =>
      _ParticipantEditorSheetState();
}

class _ParticipantEditorSheetState
    extends ConsumerState<_ParticipantEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _childCtrl;
  late final TextEditingController _familyCtrl;
  late final TextEditingController _parentCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    _childCtrl = TextEditingController(text: widget.participant?.childName);
    _familyCtrl = TextEditingController(text: widget.participant?.familyName);
    _parentCtrl = TextEditingController(text: widget.participant?.parentName);
    _phoneCtrl = TextEditingController(text: widget.participant?.parentPhone);
    _emailCtrl = TextEditingController(text: widget.participant?.parentEmail);
  }

  @override
  void dispose() {
    _childCtrl.dispose();
    _familyCtrl.dispose();
    _parentCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.participant == null) {
      await ref
          .read(participantRepositoryProvider)
          .createParticipant(
            eventId: widget.eventId,
            childName: _childCtrl.text.trim(),
            familyName: _familyCtrl.text.trim(),
            parentName: _parentCtrl.text.trim(),
            parentPhone: _phoneCtrl.text.trim(),
            parentEmail: _emailCtrl.text.trim(),
          );
    } else {
      await ref
          .read(participantRepositoryProvider)
          .updateParticipant(
            eventId: widget.eventId,
            participant: widget.participant!.copyWith(
              childName: _childCtrl.text.trim(),
              familyName: _familyCtrl.text.trim(),
              parentName: _parentCtrl.text.trim(),
              parentPhone: _phoneCtrl.text.trim(),
              parentEmail: _emailCtrl.text.trim(),
            ),
          );
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.participant == null
                        ? 'Agregar participante'
                        : 'Editar participante',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _childCtrl,
                    label: 'Nombre del hijo/a',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Campo obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: _familyCtrl,
                    label: 'Apellido/familia (opcional)',
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: _parentCtrl,
                    label: 'Nombre del padre/madre',
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: _phoneCtrl,
                    label: 'Teléfono (opcional)',
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: _emailCtrl,
                    label: 'Email (opcional)',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: widget.participant == null
                        ? 'Guardar'
                        : 'Actualizar',
                    onPressed: _save,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
