import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.savedTitle),
      ),
      body: Center(
        child: Text(AppLocalizations.of(context)!.savedComingSoon),
      ),
    );
  }
}
