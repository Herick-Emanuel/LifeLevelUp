import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'core/config/app_router.dart';
import 'services/api_service.dart';
import 'services/notification_service.dart';
import 'models/user.dart';
import 'theme_provider.dart';

void main() async {
  try {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    // Inicializa o serviço de notificações
    final notificationService = NotificationService();
    try {
      await notificationService.initialize();
    } catch (e) {
      print('Aviso: Erro ao inicializar notificações: $e');
      // Continua a execução mesmo se houver erro nas notificações
    }

    // Remove o splash screen após a inicialização
    FlutterNativeSplash.remove();

    runApp(const MyApp());
  } catch (e) {
    print('Erro fatal durante a inicialização: $e');
    FlutterNativeSplash.remove();
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return MaterialApp.router(
                title: 'Life Level Up',
                debugShowCheckedModeBanner: false,
                theme: themeProvider.getTheme(),
                routerConfig: AppRouter.router,
              );
            },
          );
        },
      ),
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
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          print('Erro ao obter usuário atual: ${snapshot.error}');
          AppRouter.router.go('/login');
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          AppRouter.router.go('/home');
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        AppRouter.router.go('/login');
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
