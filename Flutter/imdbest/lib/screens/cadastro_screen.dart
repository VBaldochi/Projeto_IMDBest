import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});
  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String senha = '';
  String nome = '';
  String confirmarSenha = '';
  String? erro;
  bool carregando = false;

  void _cadastrar() async {
    setState(() {
      carregando = true;
      erro = null;
    });
    final api = ApiService();
    if (senha != confirmarSenha) {
      setState(() {
        erro = 'As senhas não conferem';
        carregando = false;
      });
      return;
    }
    final sucesso = await api.registrar(nome, email, senha, confirmarSenha);
    if (sucesso) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      setState(() {
        erro = 'Erro ao cadastrar. Verifique os dados.';
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
                      Icon(Icons.person_add_alt_1, size: 64, color: Colors.deepPurple.shade400),
                      const SizedBox(height: 16),
                      const Text('Criar Conta', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Confirmar Senha',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        onChanged: (v) => confirmarSenha = v,
                        validator: (v) => v != null && v == senha ? null : 'As senhas não conferem',
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) => nome = v,
                        validator: (v) => v != null && v.isNotEmpty ? null : 'Nome obrigatório',
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
                                icon: const Icon(Icons.check),
                                label: const Text('Cadastrar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) _cadastrar();
                                },
                              ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Já tenho conta', style: TextStyle(fontWeight: FontWeight.bold)),
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