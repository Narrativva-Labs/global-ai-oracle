// lib/dashboard_page.dart
// Manages the state and logic for the main dashboard screen, including loading and displaying metrics and graphs. This file loads historical data for trends but does not handle prediction generation, which is done automatically in the backend.

import 'package:flutter/material.dart';
import 'widgets/metric_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<String> _metrics = const [
    'Probability of Nuclear Weapons Use',
    'Probability of Third World War Start',
    'Probability of Global Financial Crisis',
    'Probability of AGI Creation',
    'Probability of WHO Global Pandemic Declaration',
    'Probability of Alien Civilizations Discovery',
    'Probability of Cancer Cure Discovery',
    'Probability of Physics Law Breakthrough',
    'Probability of Robot Rebellion Against Humanity',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global AI Oracle'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _metrics.length,
        itemBuilder: (context, index) {
          return MetricCard(metric: _metrics[index]);
        },
      ),
    );
  }
}