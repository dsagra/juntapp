import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

class AppMobileShell extends StatelessWidget {
  const AppMobileShell({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.floatingActionButton,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppConstants.mobileMaxWidth,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    scheme.primaryContainer.withValues(alpha: 0.16),
                    scheme.surface,
                    scheme.surface,
                  ],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppConstants.pageHorizontalPadding,
                  AppConstants.pageVerticalPadding,
                  AppConstants.pageHorizontalPadding,
                  AppConstants.pageVerticalPadding + 24,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
