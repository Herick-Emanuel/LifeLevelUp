import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações de Tema')),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Modo do Tema',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.system,
                            label: Text('Sistema'),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.light,
                            label: Text('Claro'),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.dark,
                            label: Text('Escuro'),
                          ),
                        ],
                        selected: {themeProvider.themeMode},
                        onSelectionChanged: (Set<ThemeMode> modes) {
                          themeProvider.toggleTheme(modes.first);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cores Personalizadas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildColorPicker(
                        context,
                        'Cor Primária',
                        themeProvider.customPrimaryColor,
                        (color) =>
                            themeProvider.setCustomTheme(primaryColor: color),
                      ),
                      const SizedBox(height: 8),
                      _buildColorPicker(
                        context,
                        'Cor Secundária',
                        themeProvider.customSecondaryColor,
                        (color) =>
                            themeProvider.setCustomTheme(secondaryColor: color),
                      ),
                      const SizedBox(height: 8),
                      _buildColorPicker(
                        context,
                        'Cor de Fundo',
                        themeProvider.customBackgroundColor,
                        (color) => themeProvider.setCustomTheme(
                          backgroundColor: color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildColorPicker(
                        context,
                        'Cor do Texto',
                        themeProvider.customTextColor,
                        (color) =>
                            themeProvider.setCustomTheme(textColor: color),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => themeProvider.resetCustomTheme(),
                          child: const Text('Resetar Cores'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildColorPicker(
    BuildContext context,
    String label,
    Color? currentColor,
    Function(Color) onColorChanged,
  ) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        GestureDetector(
          onTap: () async {
            final Color? pickedColor = await showDialog<Color>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text('Escolher $label'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: currentColor ?? Colors.blue,
                        onColorChanged: onColorChanged,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, currentColor),
                        child: const Text('Confirmar'),
                      ),
                    ],
                  ),
            );
            if (pickedColor != null) {
              onColorChanged(pickedColor);
            }
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: currentColor ?? Colors.grey,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}

class ColorPicker extends StatelessWidget {
  final Color pickerColor;
  final Function(Color) onColorChanged;
  final double pickerAreaHeightPercent;

  const ColorPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
    this.pickerAreaHeightPercent = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * pickerAreaHeightPercent,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: Colors.primaries.length,
        itemBuilder: (context, index) {
          final color = Colors.primaries[index];
          return GestureDetector(
            onTap: () => onColorChanged(color),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: pickerColor == color ? Colors.white : Colors.grey,
                  width: pickerColor == color ? 2 : 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
