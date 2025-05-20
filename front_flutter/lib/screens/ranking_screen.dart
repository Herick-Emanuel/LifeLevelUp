import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRanking();
  }

  Future<void> _fetchRanking() async {
    try {
      List<User> users = await ApiService.getGlobalRanking();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildUser(User user, int rank) {
    return ListTile(
      leading: Text('#$rank'),
      title: Text(user.name),
      subtitle: Text('Nível: ${user.level} - Pontos: ${user.points}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ranking Global')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _users.isEmpty
              ? const Center(child: Text('Ranking indisponível.'))
              : ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  return _buildUser(_users[index], index + 1);
                },
              ),
    );
  }
}
