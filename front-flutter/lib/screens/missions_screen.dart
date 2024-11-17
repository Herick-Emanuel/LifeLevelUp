import 'package:flutter/material.dart';
import '../models/mission.dart';
import '../services/api_service.dart';
import 'add_mission_screen.dart';

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({super.key});

  @override
  _MissionsScreenState createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  List<Mission> _missions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMissions();
  }

  Future<void> _fetchMissions() async {
    try {
      List<Mission> missions = await ApiService.getMissions();
      setState(() {
        _missions = missions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _completeMission(int missionId) async {
    bool success = await ApiService.completeMission(missionId);
    if (success) {
      _fetchMissions();
    }
  }

  void _navigateToAddMission() async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMissionScreen(onMissionAdded: _fetchMissions),
      ),
    );

    if (result == true) {
      _fetchMissions();
    }
  }

  Widget _buildMissionItem(Mission mission) {
    return ListTile(
      title: Text(mission.title),
      subtitle: Text(mission.description),
      trailing: mission.isCompleted
          ? const Icon(Icons.check, color: Colors.green)
          : ElevatedButton(
              onPressed: () => _completeMission(mission.id),
              child: const Text('Completar'),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Missões'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToAddMission,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _missions.isEmpty
              ? const Center(child: Text('Nenhuma missão disponível.'))
              : ListView.builder(
                  itemCount: _missions.length,
                  itemBuilder: (context, index) {
                    return _buildMissionItem(_missions[index]);
                  },
                ),
    );
  }
}
