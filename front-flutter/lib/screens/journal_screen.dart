import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../services/api_service.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  List<JournalEntry> _entries = [];
  bool _isLoading = true;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchEntries();
  }

  Future<void> _fetchEntries() async {
    try {
      List<JournalEntry> entries = await ApiService.getJournalEntries();
      setState(() {
        _entries = entries;
        _isLoading = false;
      });
    } catch (e) {
      // Trate o erro
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addEntry() async {
    String content = _controller.text.trim();
    if (content.isEmpty) return;

    bool success = await ApiService.addJournalEntry(content);
    if (success) {
      _controller.clear();
      _fetchEntries();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diário de Hábitos'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _entries.isEmpty
                      ? Center(child: Text('Nenhuma entrada encontrada.'))
                      : ListView.builder(
                          itemCount: _entries.length,
                          itemBuilder: (context, index) {
                            JournalEntry entry = _entries[index];
                            return ListTile(
                              title: Text(entry.content),
                              subtitle: Text(
                                entry.createdAt.toLocal().toString(),
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
                            labelText: 'Nova entrada',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _addEntry,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
