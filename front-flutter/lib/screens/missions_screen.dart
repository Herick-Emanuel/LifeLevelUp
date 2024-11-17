import 'package:flutter/material.dart';
import '../models/mission.dart';
import '../services/api_service.dart';

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

  Widget _buildMissionItem(Mission mission) {
    return ListTile(
      title: Text(mission.title),
      subtitle: Text(mission.description),
      trailing: mission.isCompleted
          ? Icon(Icons.check, color: Colors.green)
          : ElevatedButton(
              onPressed: () => _completeMission(mission.id),
              child: Text('Completar'),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Missões'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _missions.isEmpty
              ? Center(child: Text('Nenhuma missão disponível.'))
              : ListView.builder(
                  itemCount: _missions.length,
                  itemBuilder: (context, index) {
                    return _buildMissionItem(_missions[index]);
                  },
                ),
    );
  }
}
