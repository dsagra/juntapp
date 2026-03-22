import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_mobile_shell.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/section_card.dart';
import '../providers/auth_providers.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      debugPrint('[SIGNUP_UI] validation failed');
      return;
    }

    final email = _emailCtrl.text.trim();
    debugPrint('[SIGNUP_UI] submit pressed email=$email');

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await ref
          .read(authServiceProvider)
          .createAccountWithEmailPassword(
            name: _nameCtrl.text.trim(),
            email: email,
            password: _passwordCtrl.text,
          );

      debugPrint('[SIGNUP_UI] account created, navigating to dashboard');
      if (mounted) {
        context.go('/dashboard');
      }
    } on FirebaseAuthException catch (e, stack) {
      debugPrint(
        '[SIGNUP_UI] FirebaseAuthException code=${e.code} message=${e.message}',
      );
      debugPrint('[SIGNUP_UI] stack=$stack');
      setState(() {
        _error = e.message ?? 'No se pudo crear la cuenta';
      });
    } catch (e, stack) {
      debugPrint('[SIGNUP_UI] unexpected error=$e');
      debugPrint('[SIGNUP_UI] stack=$stack');
      setState(() {
        _error = 'Ocurrió un error inesperado: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
      debugPrint('[SIGNUP_UI] submit finished');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppMobileShell(
      title: 'Crear cuenta',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BrandLogo(
            size: 128,
            tagline:
                'Creá tu cuenta y empezá a organizar pagos de forma simple.',
            center: false,
          ),
          const SizedBox(height: 14),
          SectionCard(
            title: 'Datos de acceso',
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    controller: _nameCtrl,
                    label: 'Nombre',
                    hint: 'Nombre y apellido',
                    prefixIcon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingresá tu nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _emailCtrl,
                    label: 'Email',
                    hint: 'organizador@email.com',
                    prefixIcon: Icons.alternate_email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingresá tu email';
                      }
                      if (!value.contains('@')) {
                        return 'Email inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _passwordCtrl,
                    label: 'Contraseña',
                    hint: 'Mínimo 6 caracteres',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresá una contraseña';
                      }
                      if (value.length < 6) {
                        return 'Mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _confirmCtrl,
                    label: 'Confirmar contraseña',
                    hint: 'Repetí tu contraseña',
                    prefixIcon: Icons.lock_reset_outlined,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirmá tu contraseña';
                      }
                      if (value != _passwordCtrl.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: 'Crear cuenta',
                    loading: _loading,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Ya tengo cuenta, ingresar'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
