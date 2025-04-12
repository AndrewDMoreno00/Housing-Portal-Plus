import 'package:flutter/material.dart';
import 'package:housing_portal_plus/service/chatbot_service.dart';
import 'package:housing_portal_plus/widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatbotService _chatbotService = ChatbotService();
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addBotMessage('Hi! I\'m Sammy, your UCSC assistant. How can I help you with information about the colleges?');
  }

  void _addBotMessage(String message) {
    setState(() {
      _messages.add({
        'message': message,
        'isUser': false,
      });
    });
  }

  void _handleSubmitted(String text) async {
    _textController.clear();
    
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'message': text,
        'isUser': true,
      });
      _isLoading = true;
    });

    try {
      final response = await _chatbotService.sendMessage(text);
      
      setState(() {
        _isLoading = false;
        _messages.add({
          'message': response,
          'isUser': false,
        });
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _messages.add({
          'message': 'Sorry, something went wrong.',
          'isUser': false,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Chat with Sammy'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (_, int index) {
                final message = _messages[index];
                return ChatBubble(
                  message: message['message'],
                  isUser: message['isUser'],
                );
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ),
    );
  }
}