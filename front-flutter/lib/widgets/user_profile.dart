// lib/widgets/user_profile.dart

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
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
      // Trate o erro
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return CircularProgressIndicator();
    }

    if (_user == null) {
      return Text('Erro ao carregar perfil do usuário.');
    }

    return Column(
      children: [
        Text(
          'Nível: ${_user!.level}',
          style: TextStyle(fontSize: 24),
        ),
        Text(
          'Pontos: ${_user!.points}',
          style: TextStyle(fontSize: 24),
        ),
        // Informações adicionais do usuário
      ],
    );
  }
}
