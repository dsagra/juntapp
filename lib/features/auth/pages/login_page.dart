import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_mobile_shell.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/section_card.dart';
import '../providers/auth_providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    debugPrint('[LOGIN_UI] submit pressed google');

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await ref.read(authServiceProvider).signInWithGoogle();
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BrandLogo(
            size: 128,
            tagline: 'Organizá pagos grupales en minutos',
            center: false,
            showWordmark: true,
          ),
          const SizedBox(height: 14),
          SectionCard(
            title: 'Acceso organizador',
            subtitle: 'Ingresá con Google para ver y administrar tus eventos.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Usamos acceso seguro con Google. No necesitás contraseña.',
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
                const SizedBox(height: 18),
                PrimaryButton(
                  label: 'Continuar con Google',
                  loading: _loading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context.go('/signup'),
            child: const Text('Crear cuenta con Google'),
          ),
        ],
      ),
    );
  }
}
