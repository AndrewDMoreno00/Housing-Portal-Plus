import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatbotService {
  final GenerativeModel _model;
  ChatSession? _chatSession;

  ChatbotService() : _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
  ) {
    _initChat();
  }

  void _initChat() {
    final prompt = '''
    You are Sammy, an AI assistant for UC Santa Cruz students.
    You can help with information about the ten colleges at UCSC:
    - Cowell College
    - Stevenson College
    - Crown College
    - Merrill College
    - Porter College
    - Kresge College
    - Oakes College
    - Rachel Carson College
    - College Nine
    - John R. Lewis College
    
    You provide friendly and helpful information about college locations, 
    traditions, themes, and can help students determine which college might 
    be the best fit for them based on their interests.
    
    Be concise in your responses and focus on being accurate about UCSC-specific information.
    ''';

    _chatSession = _model.startChat(history: [
      Content.text(prompt),
    ]);
  }

  Future<String> sendMessage(String message) async {
    try {
      final response = await _chatSession?.sendMessage(Content.text(message));
      final responseText = response?.text ?? 'Sorry, I couldn\'t process your request.';
      return responseText;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}