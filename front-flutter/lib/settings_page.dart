import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        appBar: AppBar(title: Text('Configurações')),
        body: Column(children: [
          SwitchListTile(
            title: Text('Tema Escuro'),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (bool value) {
              themeProvider
                  .toggleTheme(value ? ThemeMode.dark : ThemeMode.light);
            },
          ),
          ListTile(
            title: Text('Cor Primária'),
            subtitle: Text(
              'Toque para alterar a cor principal',
              style: TextStyle(
                  color: themeProvider.customPrimaryColor ?? Colors.blue),
            ),
            trailing: CircleAvatar(
              backgroundColor: themeProvider.customPrimaryColor ?? Colors.blue,
            ),
            onTap: () async {
              Color? pickedColor = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Escolha a Cor Primária'),
                  content: SingleChildScrollView(
                    child: BlockPicker(
                      pickerColor:
                          themeProvider.customPrimaryColor ?? Colors.blue,
                      onColorChanged: (color) {
                        themeProvider.setCustomTheme(color);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ]));
  }
}
