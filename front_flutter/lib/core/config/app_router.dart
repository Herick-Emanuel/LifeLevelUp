import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../login_page.dart';
import '../../home_page.dart';
import '../../register_page.dart';
import '../../screens/profile_screen.dart';
import '../../screens/missions_screen.dart';
import '../../screens/motivation_screen.dart';
import '../../screens/customization_screen.dart';
import '../../screens/journal_screen.dart';
import '../../settings_page.dart';
import '../../progress_page.dart';
import '../../screens/habit_form_screen.dart';
import '../../screens/habit_stats_screen.dart';
import '../../screens/theme_settings_page.dart';
import '../../services/api_service.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      if (state.uri.path == '/') {
        final user = await ApiService.getCurrentUser();
        return user != null ? '/home' : '/login';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder:
            (context, state) => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/missions',
        builder: (context, state) => const MissionsScreen(),
      ),
      GoRoute(
        path: '/motivation',
        builder: (context, state) => const MotivationScreen(),
      ),
      GoRoute(
        path: '/customization',
        builder: (context, state) => const CustomizationScreen(),
      ),
      GoRoute(
        path: '/journal',
        builder: (context, state) => const JournalScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/settings/theme',
        builder: (context, state) => const ThemeSettingsPage(),
      ),
      GoRoute(
        path: '/progress',
        builder: (context, state) => const ProgressPage(),
      ),
      GoRoute(
        path: '/habits/new',
        builder: (context, state) {
          final userId = state.extra as int;
          return HabitFormScreen(userId: userId);
        },
      ),
      GoRoute(
        path: '/habits/edit/:id',
        builder: (context, state) {
          final habit = state.extra as Map<String, dynamic>;
          return HabitFormScreen(
            habit: habit['habit'],
            userId: habit['userId'],
          );
        },
      ),
      GoRoute(
        path: '/habits/stats/:id',
        builder: (context, state) {
          final habit = state.extra as Map<String, dynamic>;
          return HabitStatsScreen(habit: habit['habit']);
        },
      ),
    ],
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Página não encontrada: ${state.uri.path}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => router.go('/home'),
                  child: const Text('Voltar para Home'),
                ),
              ],
            ),
          ),
        ),
  );
}
