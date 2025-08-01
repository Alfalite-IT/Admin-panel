import 'package:admin_panel/screens/login_screen.dart';
import 'package:admin_panel/screens/product_list_page.dart';
import 'package:admin_panel/services/auth_service.dart';
import 'package:admin_panel/services/navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_panel/config/environment.dart';
import 'package:flutter/foundation.dart';

void main() {
  // Print environment information for debugging
  if (kDebugMode) {
    Environment.printEnvironment();
  }
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: const AdminPanelApp(),
    ),
  );
}

class AdminPanelApp extends StatelessWidget {
  const AdminPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigatorService.navigatorKey,
      title: 'Alfalite Admin Panel',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFC7100),
        scaffoldBackgroundColor: const Color(0xFF222222),
        cardColor: const Color(0xFF333333),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFC7100)),
          ),
          labelStyle: TextStyle(color: Colors.white70),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(color: Color(0xFFF78400), fontWeight: FontWeight.bold),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF222222),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFFFC7100),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFC7100),
            foregroundColor: Colors.black,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFC7100),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthService>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    switch (authService.status) {
      case AuthStatus.loading:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AuthStatus.authenticated:
        return const ProductListPage();
      case AuthStatus.unauthenticated:
        return const LoginScreen();
    }
  }
}
