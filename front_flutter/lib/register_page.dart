import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _nome = '';
  String _email = '';
  String _senha = '';
  bool _isLoading = false;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await ApiService.register(_nome, _email, _senha);

      if (!mounted) return;

      if (success) {
        showDialog(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: const Text('Sucesso'),
                content: const Text('Cadastro realizado com sucesso!'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      context.go('/login');
                    },
                  ),
                ],
              ),
        );
      } else {
        _showErrorDialog('Falha ao cadastrar. Tente novamente.');
      }
    } catch (e) {
      _showErrorDialog('Erro ao cadastrar: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String mensagem) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Erro'),
            content: Text(mensagem),
            actions: <Widget>[
              TextButton(
                child: const Text('Fechar'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.teal;
    const Color buttonColor = Colors.tealAccent;
    const Color backgroundColor = Colors.white;
    final Color textFieldFillColor = Colors.teal.shade50;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Cadastro'),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Criar Conta',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: Icon(Icons.person, color: primaryColor),
                        filled: true,
                        fillColor: textFieldFillColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu nome';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _nome = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email, color: primaryColor),
                        filled: true,
                        fillColor: textFieldFillColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@')) {
                          return 'Por favor, insira um e-mail válido';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: Icon(Icons.lock, color: primaryColor),
                        filled: true,
                        fillColor: textFieldFillColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'A senha deve ter pelo menos 6 caracteres';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _senha = value!;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:
                            _isLoading
                                ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                )
                                : const Text(
                                  'Cadastrar',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(
                        'Já possui uma conta? Faça login',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
