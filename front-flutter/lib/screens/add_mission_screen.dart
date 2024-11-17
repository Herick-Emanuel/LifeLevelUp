import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddMissionScreen extends StatefulWidget {
  final VoidCallback onMissionAdded;

  const AddMissionScreen({required this.onMissionAdded, super.key});

  @override
  _AddMissionScreenState createState() => _AddMissionScreenState();
}

class _AddMissionScreenState extends State<AddMissionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _type = 'daily';

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        bool success = await ApiService.addMission(
          title: _title,
          description: _description,
          type: _type,
        );
        if (success) {
          widget.onMissionAdded();
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar missão: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Missão'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Insira um título' : null,
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descrição'),
                onSaved: (value) => _description = value ?? '',
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(
                    value: 'daily',
                    child: Text('Diária'),
                  ),
                  DropdownMenuItem(
                    value: 'weekly',
                    child: Text('Semanal'),
                  ),
                ],
                onChanged: (value) => _type = value!,
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
