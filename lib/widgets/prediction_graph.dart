// lib/widgets/prediction_graph.dart
// Component for displaying the graph of historical trends for a metric.

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/supabase_service.dart';

class PredictionGraph extends StatelessWidget {
  final List<PredictionData> data;

  const PredictionGraph({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No data available', style: TextStyle(color: Colors.white70)));
    }

    // Group data by model for multi-line graph and map X axis to days
    Map<String, List<FlSpot>> modelData = {};
    final startDate = data.first.date;
    for (var entry in data) {
      modelData.putIfAbsent(entry.model, () => []);
      final days = entry.date.difference(startDate).inDays.toDouble();
      modelData[entry.model]!.add(FlSpot(days, entry.probability));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 20,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) => const FlLine(color: Colors.white10, strokeWidth: 1),
          getDrawingVerticalLine: (value) => const FlLine(color: Colors.white10, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 5,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                if (value < 0) return const Text('');
                final date = startDate.add(Duration(days: value.toInt()));
                return Text(
                  date.toString().substring(5, 10),
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text('$value%', style: const TextStyle(color: Colors.white70, fontSize: 10)),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: data.last.date.difference(startDate).inDays.toDouble(),
        minY: 0,
        maxY: 100,
        lineBarsData: modelData.entries.map((entry) {
          return LineChartBarData(
            spots: entry.value,
            isCurved: true,
            curveSmoothness: 0.35,
            color: _getModelColor(entry.key),
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [_getModelColor(entry.key).withOpacity(0.3), _getModelColor(entry.key).withOpacity(0.0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getModelColor(String model) {
    switch (model) {
      case 'Gemini':
        return Colors.blueAccent;
      case 'ChatGPT':
        return Colors.greenAccent;
      case 'Grok':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}