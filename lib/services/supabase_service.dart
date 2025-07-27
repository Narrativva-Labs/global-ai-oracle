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

// Najdi ID metriky podle short_name (nebo podle name modelu)
Future<int?> getMetricId(String shortName) async {
  final supabase = Supabase.instance.client;
  final data = await supabase
      .from('metrics')
      .select('id')
      .eq('short_name', shortName)
      .maybeSingle();
  return data?['id'];
}

Future<int?> getModelId(String modelName) async {
  final supabase = Supabase.instance.client;
  final data = await supabase
      .from('models')
      .select('id')
      .eq('name', modelName)
      .maybeSingle();
  return data?['id'];
}

// Uložit predikce
Future<void> storePredictions(String metricShortName, Map<String, double> predictions) async {
  final supabase = Supabase.instance.client;
  final today = DateTime.now().toIso8601String().split('T')[0];

  final metricId = await getMetricId(metricShortName);
  if (metricId == null) throw Exception('Metric $metricShortName not found');

  for (final entry in predictions.entries) {
    final modelId = await getModelId(entry.key);
    if (modelId == null) throw Exception('Model ${entry.key} not found');

    await supabase.from('predictions').insert({
      'metric_id': metricId,
      'model_id': modelId,
      'probability': entry.value,
      'date': today,
    });
  }
}

// Načíst historická data pro jednu metriku
Future<List<PredictionData>> loadHistoricalData(String metricShortName) async {
  final supabase = Supabase.instance.client;

  // Získat id metriky
  final metricId = await getMetricId(metricShortName);
  if (metricId == null) return [];

  // Datum 30 dní zpět
  final thirtyDaysAgo =
      DateTime.now().subtract(const Duration(days: 30)).toIso8601String().split('T')[0];

  // Join na models a metrics, vyfiltruj podle metric_id a posledních 30 dní
  final response = await supabase
      .from('predictions')
      .select('date, probability, metrics(short_name), models(name)')
      .eq('metric_id', metricId)
      .gte('date', thirtyDaysAgo)
      .order('date', ascending: true);

  return (response as List)
      .map((data) => PredictionData(
            date: DateTime.parse(data['date']),
            metric: data['metrics']['short_name'] ?? '',
            model: data['models']['name'] ?? '',
            probability: (data['probability'] as num).toDouble(),
          ))
      .toList();
}
