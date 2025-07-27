// lib/widgets/metric_card.dart
// Widget for displaying a single metric card with graph and current predictions.

import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'prediction_graph.dart';

class MetricCard extends StatefulWidget {
  final String metric; // short_name, pro načítání z DB
  final String label;  // long_name, pro zobrazení uživateli

  const MetricCard({
    super.key,
    required this.metric,
    required this.label,
  });

  @override
  State<MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<MetricCard> {
  List<PredictionData> _data = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await loadHistoricalData(widget.metric); // pořád předáváš short_name
    setState(() {
      _data = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label, // Tohle je teď user-friendly popisek
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 1.2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.grey[800]!],
                  ),
                ),
                child: PredictionGraph(data: _data),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
