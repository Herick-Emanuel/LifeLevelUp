import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Tema'),
            subtitle: const Text('Personalize as cores e o modo do tema'),
            onTap: () => context.go('/settings/theme'),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Tema Escuro'),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (bool value) {
              themeProvider.toggleTheme(
                value ? ThemeMode.dark : ThemeMode.light,
              );
            },
          ),
          ListTile(
            title: const Text('Cor Primária'),
            subtitle: Text(
              'Toque para alterar a cor principal',
              style: TextStyle(
                color: themeProvider.customPrimaryColor ?? Colors.blue,
              ),
            ),
            trailing: CircleAvatar(
              backgroundColor: themeProvider.customPrimaryColor ?? Colors.blue,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Escolha a Cor Primária'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor:
                            themeProvider.customPrimaryColor ?? Colors.blue,
                        onColorChanged: (Color color) {
                          themeProvider.setCustomTheme(primaryColor: color);
                        },
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
