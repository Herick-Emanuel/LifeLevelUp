// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'services/notification_service.dart';
import 'models/user.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'theme_provider.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  final notificationService = NotificationService();
  try {
    await notificationService.init();
  } catch (e) {
    print('Erro ao inicializar NotificationService: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        Provider<NotificationService>(
          create: (_) => notificationService,
        ),
      ],
      child: const HabitManagerApp(),
    ),
  );
}

class HabitManagerApp extends StatelessWidget {
  const HabitManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Gerenciador de Hábitos',
          theme: themeProvider.getTheme(),
          home: const AuthenticationWrapper(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: ApiService.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          print('Erro ao obter usuário atual: ${snapshot.error}');
          return Scaffold(
            body: Center(
              child: Text('Ocorreu um erro: ${snapshot.error}'),
            ),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          return HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
