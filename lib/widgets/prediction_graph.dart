import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/supabase_service.dart';

class PredictionGraph extends StatelessWidget {
  final List<PredictionData> data;

  const PredictionGraph({super.key, required this.data});

  double getYInterval(double maxYDisplay) {
    if (maxYDisplay <= 0.01) return 0.001;
    if (maxYDisplay <= 0.05) return 0.005;
    if (maxYDisplay <= 0.1) return 0.01;
    if (maxYDisplay <= 1) return 0.05;
    if (maxYDisplay <= 10) return 0.5;
    return 1.0;
  }

  String formatPercent(double value, double maxYDisplay) {
    if (maxYDisplay <= 0.01) return '${value.toStringAsFixed(4)}%';
    if (maxYDisplay <= 0.1) return '${value.toStringAsFixed(3)}%';
    if (maxYDisplay <= 1) return '${value.toStringAsFixed(2)}%';
    return '${value.toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No data available', style: TextStyle(color: Colors.white70)));
    }

    // Připrav data pro jednotlivé modely
    Map<String, List<FlSpot>> modelData = {};
    final startDate = data.first.date;
    for (var entry in data) {
      modelData.putIfAbsent(entry.model, () => []);
      final days = entry.date.difference(startDate).inDays.toDouble();
      modelData[entry.model]!.add(FlSpot(days, entry.probability));
    }

    final allValues = data.map((d) => d.probability).toList();
    final minValue = allValues.reduce((a, b) => a < b ? a : b);
    final maxValue = allValues.reduce((a, b) => a > b ? a : b);
    final yRange = (maxValue - minValue).abs();

    // Přidej víc paddingu, aby nikdy nebyl graf nalepený
    final minY = (minValue - yRange * 0.35).clamp(0.0, double.infinity);
    final maxYDisplay = maxValue + yRange * 0.20;
    final yInterval = getYInterval(maxYDisplay);

    final minX = -0.25;
    final maxX = data.last.date.difference(startDate).inDays.toDouble() + 0.25;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: yInterval,
          verticalInterval: 5,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.white12.withOpacity(0.07),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.white12.withOpacity(0.06),
            strokeWidth: 1,
          ),
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
              reservedSize: 64,
              interval: yInterval,
              getTitlesWidget: (value, meta) => Text(
                formatPercent(value, maxYDisplay),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxYDisplay,
        lineBarsData: modelData.entries.map((entry) {
          return LineChartBarData(
            spots: entry.value,
            isCurved: true,
            curveSmoothness: 0.45,
            color: _getModelColor(entry.key),
            barWidth: 2.2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  _getModelColor(entry.key).withOpacity(0.13),
                  _getModelColor(entry.key).withOpacity(0.00)
                ],
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
        return const Color(0xFF50A7F7);
      case 'ChatGPT':
        return const Color(0xFF4ADE80);
      case 'Grok':
        return const Color(0xFFF87171);
      default:
        return Colors.grey;
    }
  }
}
