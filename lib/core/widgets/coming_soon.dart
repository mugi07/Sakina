import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Écran provisoire pour une section prévue dans une prochaine version.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({required this.title, required this.icon, super.key});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 64, color: scheme.tertiary),
              const SizedBox(height: 16),
              Text(l.comingSoon, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                l.comingSoonBody,
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Message d'erreur de chargement avec bouton pour réessayer.
class LoadErrorView extends StatelessWidget {
  const LoadErrorView({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l.loadError),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: Text(l.retry)),
        ],
      ),
    );
  }
}
