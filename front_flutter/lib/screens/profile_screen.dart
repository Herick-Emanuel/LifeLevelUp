import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/customization_item.dart';
import '../services/api_service.dart';
import '../skill_tree_page.dart';
import 'customization_screen.dart';
import 'journal_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  List<CustomizationItem> _customizationItems = [];
  bool _isLoading = true;
  bool _isAvatarLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _fetchCustomizationItems();
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

  Future<void> _fetchCustomizationItems() async {
    try {
      List<CustomizationItem> items =
          await ApiService.getAvailableCustomizationItems();
      setState(() {
        _customizationItems = items;
        _isAvatarLoading = false;
      });
    } catch (e) {
      setState(() {
        _isAvatarLoading = false;
      });
    }
  }

  Widget _buildAvatarSection() {
    if (_isAvatarLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_customizationItems.isEmpty) {
      return const Text('Sem itens desbloqueados para o avatar.');
    } else {
      return Column(
        children: [
          const Text(
            'Meu Avatar',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            children: _customizationItems.map((item) {
              return Chip(
                label: Text(item.name),
                avatar: const Icon(
                  Icons.circle,
                  color: Colors.blue,
                ),
              );
            }).toList(),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
              ? const Center(child: Text('Erro ao carregar perfil do usuário.'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      _buildAvatarSection(),
                      const SizedBox(height: 20),
                      Text(
                        _user!.name,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _user!.email,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Nível: ${_user!.level}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Pontos: ${_user!.points}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        leading: const Icon(Icons.brush),
                        title: const Text('Customização'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CustomizationScreen()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.book),
                        title: const Text('Diário de Hábitos'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const JournalScreen()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.tram),
                        title: const Text('Árvore de Habilidades'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SkillTreePage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
