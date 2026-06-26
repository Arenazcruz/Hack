import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  GeminiService({required String apiKey, String modelName = 'gemini-1.5-flash'})
    : _model = GenerativeModel(model: modelName, apiKey: apiKey);

  final GenerativeModel _model;

  Future<String> generateTouristicDescription(String prompt) async {
    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text ?? '';
  }

  Future<String> generateGastronomicRoute(String prompt) async {
    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text ?? '';
  }
}
