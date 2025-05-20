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
      setState(() => _isLoading = true);
      List<MotivationMessage> messages =
          await ApiService.getMotivationMessages();
      setState(() {
        _messages = messages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Erro ao carregar mensagens: ${e.toString()}');
    }
  }

  Future<void> _addMessage() async {
    String message = _controller.text.trim();
    if (message.isEmpty) return;

    try {
      bool success = await ApiService.addMotivationMessage(message);
      if (success) {
        _controller.clear();
        _fetchMessages();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mensagem adicionada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _showError('Erro ao adicionar mensagem: ${e.toString()}');
    }
  }

  Future<void> _deleteMessage(MotivationMessage message) async {
    try {
      bool success = await ApiService.deleteMotivationMessage(message.id);
      if (success) {
        _fetchMessages();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mensagem excluída com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _showError('Erro ao excluir mensagem: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mensagens de Motivação'), elevation: 0),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Expanded(
                    child:
                        _messages.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.format_quote,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Nenhuma mensagem encontrada.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              itemCount: _messages.length,
                              itemBuilder: (context, index) {
                                final message = _messages[index];
                                return Dismissible(
                                  key: Key(message.id.toString()),
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 16),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  direction: DismissDirection.endToStart,
                                  confirmDismiss: (direction) async {
                                    return await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirmar exclusão'),
                                          content: const Text(
                                            'Deseja realmente excluir esta mensagem?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.of(
                                                    context,
                                                  ).pop(false),
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.of(
                                                    context,
                                                  ).pop(true),
                                              child: const Text('Excluir'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  onDismissed: (direction) {
                                    _deleteMessage(message);
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    elevation: 2,
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(16),
                                      title: Text(
                                        message.message,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          message.createdAt
                                              .toLocal()
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Digite uma nova mensagem...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            maxLines: 3,
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _addMessage,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Enviar'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
