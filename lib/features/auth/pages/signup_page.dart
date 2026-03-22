import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_mobile_shell.dart';
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
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    debugPrint('[SIGNUP_UI] submit pressed google');

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await ref.read(authServiceProvider).signInWithGoogle();

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
            title: 'Crear cuenta con Google',
            subtitle: 'Usá tu cuenta de Google para empezar en segundos.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'No necesitás completar formularios ni crear contraseña.',
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
                  label: 'Registrarme con Google',
                  loading: _loading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Ya tengo cuenta, continuar con Google'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
