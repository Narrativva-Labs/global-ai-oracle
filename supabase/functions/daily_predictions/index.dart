// supabase/functions/daily_predictions/index.dart
// Supabase Edge Function in Dart for automatic daily calling of Gemini, ChatGPT, and Grok APIs, and storing to DB. This function runs automatically via pg_cron trigger in Supabase.
// To set up the pg_cron trigger, run the following SQL in Supabase dashboard:
// SELECT cron.schedule('daily-predictions', '0 0 * * *', $$ SELECT net.http_get('https://[project-id].supabase.co/functions/v1/daily_predictions'); $$);

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

Deno.serve(async (req) {
  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL');
    const supabaseKey = Deno.env.get('SUPABASE_SERVICE_KEY');

    final supabase = SupabaseClient(supabaseUrl, supabaseKey);

    final metrics = [
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

    final today = DateTime.now().toIso8601String().split('T')[0];

    for (final metric in metrics) {
      final prompt = 'Estimate the probability (as a number 0-100) that $metric will happen tomorrow. Return only the number.';

      // Gemini call
      final geminiApiKey = Deno.env.get('GEMINI_API_KEY');
      final geminiUrl = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$geminiApiKey');
      final geminiBody = jsonEncode({
        'contents': [
          {'parts': [{'text': prompt}]}
        ],
      });
      final geminiResponse = await http.post(geminiUrl, headers: {'Content-Type': 'application/json'}, body: geminiBody);
      final geminiData = jsonDecode(geminiResponse.body);
      final geminiPred = double.parse(geminiData['candidates'][0]['content']['parts'][0]['text'].trim());

      // ChatGPT call
      final openAiKey = Deno.env.get('OPENAI_API_KEY');
      final openAiUrl = Uri.parse('https://api.openai.com/v1/chat/completions');
      final openAiBody = jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': [{'role': 'user', 'content': prompt}],
      });
      final openAiResponse = await http.post(openAiUrl, headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $openAiKey'}, body: openAiBody);
      final openAiData = jsonDecode(openAiResponse.body);
      final chatgptPred = double.parse(openAiData['choices'][0]['message']['content'].trim());

      // Grok call
      final grokApiKey = Deno.env.get('GROK_API_KEY');
      final grokUrl = Uri.parse('https://api.x.ai/v1/chat/completions');
      final grokBody = jsonEncode({
        'model': 'grok-beta',
        'messages': [{'role': 'user', 'content': prompt}],
      });
      final grokResponse = await http.post(grokUrl, headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $grokApiKey'}, body: grokBody);
      final grokData = jsonDecode(grokResponse.body);
      final grokPred = double.parse(grokData['choices'][0]['message']['content'].trim());

      // Store in DB
      await supabase.from('predictions').insert([
        {'metric': metric, 'model': 'Gemini', 'probability': geminiPred, 'date': today},
        {'metric': metric, 'model': 'ChatGPT', 'probability': chatgptPred, 'date': today},
        {'metric': metric, 'model': 'Grok', 'probability': grokPred, 'date': today},
      ]);
    }

    return new Response('Predictions updated successfully', { status: 200 });
  } catch (e) {
    return new Response(`Error: $e`, { status: 500 });
  }
});