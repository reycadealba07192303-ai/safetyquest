import 'package:flutter/material.dart';
import 'package:safetyquest_mobile/core/theme/quest_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyCallCard extends StatelessWidget {
  const EmergencyCallCard({super.key, this.openDialer});

  final Future<bool> Function(Uri)? openDialer;

  Future<void> _call(BuildContext context) async {
    try {
      final uri = Uri(scheme: 'tel', path: '911');
      final opened =
          await (openDialer?.call(uri) ??
              launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
                webOnlyWindowName: '_self',
              ));
      if (!opened) throw StateError('No phone app available');
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not open the phone app. Dial 911 on your phone.',
          ),
        ),
      );
    }
  }

  void _confirm(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Call 911?'),
        content: const Text(
          'This opens your phone app for a real emergency call. For practice, use Random emergency drill.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Keep the handoff in the tap handler so Safari permits tel: links.
              _call(context);
            },
            child: const Text('Open phone — 911'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ClayCard(
    color: QuestColors.peach,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Emergency help', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        const Text('Need urgent help? Open your phone app to call 911.'),
        const SizedBox(height: 12),
        QuestButton(
          'Emergency — Call 911',
          icon: Icons.phone_in_talk_rounded,
          onPressed: () => _confirm(context),
        ),
      ],
    ),
  );
}
