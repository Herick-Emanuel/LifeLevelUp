import 'package:flutter/material.dart';
import '../models/motivation_message.dart';
import '../services/api_service.dart';

class MotivationScreen extends StatefulWidget {
  const MotivationScreen({super.key});

  @override
  _MotivationScreenState createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  List<MotivationMessage> _messages = [];
  bool _isLoading = true;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      List<MotivationMessage> messages =
          await ApiService.getMotivationMessages();
      setState(() {
        _messages = messages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addMessage() async {
    String message = _controller.text.trim();
    if (message.isEmpty) return;

    bool success = await ApiService.addMotivationMessage(message);
    if (success) {
      _controller.clear();
      _fetchMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mensagens de Motivação'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _messages.isEmpty
                      ? Center(child: Text('Nenhuma mensagem encontrada.'))
                      : ListView.builder(
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            MotivationMessage msg = _messages[index];
                            return ListTile(
                              title: Text(msg.message),
                              subtitle: Text(
                                msg.createdAt.toLocal().toString(),
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            labelText: 'Nova mensagem',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _addMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
