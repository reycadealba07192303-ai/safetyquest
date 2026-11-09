import 'package:flutter/material.dart';
import 'package:safetyquest_mobile/core/theme/quest_theme.dart';
import 'package:safetyquest_mobile/features/lessons/lesson_models.dart';
import 'package:safetyquest_mobile/features/lessons/simulation_view.dart';

/// Optional practice; never spends a teacher-assigned attempt or submits scores.
class EmergencyDrill extends StatelessWidget {
  const EmergencyDrill({super.key, required this.step});
  final SimStep step;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: QuestColors.paper,
    appBar: AppBar(title: const Text('Practice emergency drill')),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'SIMULATION ONLY — This is a practice activity, not a real emergency. '
              'Your school scores and tries are unchanged.',
            ),
            const SizedBox(height: 16),
            SimulationView(
              steps: [step],
              eyebrowPrefix: 'Practice',
              onStep: (_) {},
              onDone: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    ),
  );
}
