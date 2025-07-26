// lib/services/supabase_service.dart
// Handles storing and retrieving historical prediction data from Supabase. This service is shared between the app (for loading data) and the backend (for storing predictions during automatic execution).

import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseKey = String.fromEnvironment('SUPABASE_KEY');

class PredictionData {
  final DateTime date;
  final String metric;
  final String model;
  final double probability;

  PredictionData({
    required this.date,
    required this.metric,
    required this.model,
    required this.probability,
  });
}

Future<void> storePredictions(String metric, Map<String, double> predictions) async {
  final supabase = Supabase.instance.client;
  final today = DateTime.now().toIso8601String().split('T')[0];

  for (final entry in predictions.entries) {
    await supabase.from('predictions').insert({
      'metric': metric,
      'model': entry.key,
      'probability': entry.value,
      'date': today,
    });
  }
}

Future<List<PredictionData>> loadHistoricalData(String metric) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('predictions')
      .select()
      .eq('metric', metric)
      .order('date', ascending: true);

  return response.map((data) => PredictionData(
        date: DateTime.parse(data['date']),
        metric: data['metric'],
        model: data['model'],
        probability: data['probability'],
      )).toList();
}