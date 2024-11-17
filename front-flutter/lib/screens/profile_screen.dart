import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'customization_screen.dart';
import 'journal_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      User? user = await ApiService.getUserProfile();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _user == null
              ? Center(child: Text('Erro ao carregar perfil do usuário.'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        _user!.name,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _user!.email,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Nível: ${_user!.level}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Pontos: ${_user!.points}',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        leading: Icon(Icons.brush),
                        title: Text('Customização'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomizationScreen()),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.book),
                        title: Text('Diário de Hábitos'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JournalScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
