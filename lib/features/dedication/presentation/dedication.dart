import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// Texte de la dédicace : l'app est une sadaqa jariya pour Zahra, Mohammed
/// et Abdellah Hafidi (rahimahum Allah).
class DedicationText extends StatelessWidget {
  const DedicationText({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              l.dedicationBasmala,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: scheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              l.dedicationBody,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dédicace, depuis l'onglet Plus.
class DedicationScreen extends StatelessWidget {
  const DedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.dedicationTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Icon(
            Icons.volunteer_activism_outlined,
            size: 56,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(height: 16),
          const DedicationText(),
        ],
      ),
    );
  }
}
