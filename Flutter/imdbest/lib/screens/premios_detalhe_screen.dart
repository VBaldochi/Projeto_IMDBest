import 'package:flutter/material.dart';

class PremiosDetalheScreen extends StatelessWidget {
  final String premio;
  final String ano;

  const PremiosDetalheScreen({super.key, required this.premio, required this.ano});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('$premio $ano')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: const Text('Detalhes da premiação aqui...'),
        ),
      ),
    );
  }
}