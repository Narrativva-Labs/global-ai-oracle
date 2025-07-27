// lib/dashboard_page.dart
// Manages the state and logic for the main dashboard screen, including loading and displaying metrics and graphs.
// This file loads historical data for trends but does not handle prediction generation, which is done automatically in the backend.

import 'package:flutter/material.dart';
import 'widgets/metric_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Seznam short_name hodnot přesně podle tvé databáze
  final List<String> _metrics = const [
    'Nukes',
    'WW3',
    'FinanceCrisis',
    'AGI',
    'Pandemic',
    'Aliens',
    'CancerCure',
    'Physics',
    'RobotRebellion',
  ];

  // Mapování short_name → long_name
  final Map<String, String> _metricLabels = const {
    'Nukes': 'Probability of Nuclear Weapons Use',
    'WW3': 'Probability of Third World War Start',
    'FinanceCrisis': 'Probability of Global Financial Crisis',
    'AGI': 'Probability of AGI Creation',
    'Pandemic': 'Probability of WHO Global Pandemic Declaration',
    'Aliens': 'Probability of Alien Civilizations Discovery',
    'CancerCure': 'Probability of Cancer Cure Discovery',
    'Physics': 'Probability of Physics Law Breakthrough',
    'RobotRebellion': 'Probability of Robot Rebellion Against Humanity',
  };

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool useGrid = screenWidth >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Global AI Oracle'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: useGrid
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: _metrics.length,
                itemBuilder: (context, index) {
                  final shortName = _metrics[index];
                  final label = _metricLabels[shortName] ?? shortName;
                  return MetricCard(
                    metric: shortName,
                    label: label,
                  );
                },
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _metrics.length,
              itemBuilder: (context, index) {
                final shortName = _metrics[index];
                final label = _metricLabels[shortName] ?? shortName;
                return MetricCard(
                  metric: shortName,
                  label: label,
                );
              },
            ),
    );
  }
}
