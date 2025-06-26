import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/detalhes_screen.dart';
import 'screens/cadastro_screen.dart';

void main() {
  runApp(const IMDBestApp());
} 

class IMDBestApp extends StatelessWidget {
  const IMDBestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMDBest',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainScreen(),
        '/detalhes': (context) => DetalhesScreen(),
        '/cadastro': (context) => const CadastroScreen(),
        // Adicione outras rotas conforme necessário
      },
    );
  }
}