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
                  // Slightly taller than wide to fit card contents
                  childAspectRatio: 0.59,
                ),
                itemCount: _metrics.length,
                itemBuilder: (context, index) {
                  return MetricCard(metric: _metrics[index]);
                },
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _metrics.length,
              itemBuilder: (context, index) {
                return MetricCard(metric: _metrics[index]);
              },
            ),
    );
  }
}