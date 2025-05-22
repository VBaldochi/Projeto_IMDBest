import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Importe o ApiService

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String senha = '';
  bool carregando = false;
  String? erro;

  void _login() async {
    setState(() {
      carregando = true;
      erro = null;
    });
    final api = ApiService();
    final sucesso = await api.login(email, senha);
    if (sucesso) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      setState(() {
        erro = 'E-mail ou senha inválidos';
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple.shade50,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.movie_filter, size: 64, color: Colors.deepPurple.shade400),
                      const SizedBox(height: 16),
                      const Text('Bem-vindo ao IMDBest', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) => email = v,
                        validator: (v) => v != null && v.contains('@') ? null : 'E-mail inválido',
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        onChanged: (v) => senha = v,
                        validator: (v) => v != null && v.length >= 6 ? null : 'Senha muito curta',
                      ),
                      if (erro != null) ...[
                        const SizedBox(height: 12),
                        Text(erro!, style: const TextStyle(color: Colors.red)),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: carregando
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton.icon(
                                icon: const Icon(Icons.login),
                                label: const Text('Entrar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) _login();
                                },
                              ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/cadastro'),
                        child: const Text('Criar conta', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}