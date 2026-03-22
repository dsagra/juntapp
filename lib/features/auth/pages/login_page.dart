import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_mobile_shell.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../providers/auth_providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      debugPrint('[LOGIN_UI] validation failed');
      return;
    }

    final email = _emailCtrl.text.trim();
    debugPrint('[LOGIN_UI] submit pressed email=$email');

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await ref
          .read(authServiceProvider)
          .signInWithEmailPassword(
            email: email,
            password: _passwordCtrl.text,
          );
      debugPrint('[LOGIN_UI] signIn finished without exception');
      debugPrint('[LOGIN_UI] waiting auth state stream to redirect');
    } on FirebaseAuthException catch (e, stack) {
      debugPrint(
        '[LOGIN_UI] FirebaseAuthException code=${e.code} message=${e.message}',
      );
      debugPrint('[LOGIN_UI] stack=$stack');
      setState(() {
        _error = e.message ?? 'No se pudo iniciar sesión';
      });
    } catch (e, stack) {
      debugPrint('[LOGIN_UI] unexpected error=$e');
      debugPrint('[LOGIN_UI] stack=$stack');
      setState(() {
        _error = 'Ocurrió un error inesperado: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
      debugPrint('[LOGIN_UI] submit finished');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppMobileShell(
      title: 'Ingresar',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'JuntApp',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Acceso para organizadores',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppTextField(
              controller: _emailCtrl,
              label: 'Email',
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
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresá tu contraseña';
                }
                if (value.length < 6) {
                  return 'Mínimo 6 caracteres';
                }
                return null;
              },
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Ingresar',
              loading: _loading,
              onPressed: _submit,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go('/signup'),
              child: const Text('Soy nuevo, crear cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}
