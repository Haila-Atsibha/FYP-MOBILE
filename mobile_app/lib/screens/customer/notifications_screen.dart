import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notificationsTitle),
      ),
      body: Center(
        child: Text(AppLocalizations.of(context)!.notificationsComingSoon),
      ),
    );
  }
}
