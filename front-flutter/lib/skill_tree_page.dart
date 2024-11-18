import 'package:flutter/material.dart';

class SkillTreePage extends StatelessWidget {
  const SkillTreePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Árvore de Habilidades'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Progresso na Árvore de Habilidades',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildSkillTree(),
              const SizedBox(height: 20),
              const Text(
                'Dica: Complete missões para desbloquear novas habilidades!',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillTree() {
    List<bool> skillUnlocked = [true, false, false, false, false, false];

    return Column(
      children: [
        _buildSkillRow(
          [skillUnlocked[0]],
          ['Início'],
          isRoot: true,
        ),
        _buildSkillRow(
          [skillUnlocked[1], skillUnlocked[2]],
          ['Habilidade 1', 'Habilidade 2'],
        ),
        _buildSkillRow(
          [skillUnlocked[3], skillUnlocked[4], skillUnlocked[5]],
          ['Habilidade 3', 'Habilidade 4', 'Habilidade 5'],
        ),
      ],
    );
  }

  Widget _buildSkillRow(List<bool> unlocked, List<String> labels,
      {bool isRoot = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(labels.length, (index) {
        return Column(
          children: [
            if (!isRoot) _buildConnectionLine(),
            _buildSkillNode(unlocked[index], labels[index]),
          ],
        );
      }),
    );
  }

  Widget _buildSkillNode(bool unlocked, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: unlocked ? Colors.teal : Colors.grey,
          child: Icon(
            unlocked ? Icons.check_circle : Icons.lock,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildConnectionLine() {
    return SizedBox(
      height: 20,
      child: VerticalDivider(
        color: Colors.teal,
        thickness: 2,
      ),
    );
  }
}
