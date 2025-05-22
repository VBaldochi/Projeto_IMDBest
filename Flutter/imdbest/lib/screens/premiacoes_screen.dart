import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PremiacoesScreen extends StatefulWidget {
  const PremiacoesScreen({super.key});

  @override
  State<PremiacoesScreen> createState() => _PremiacoesScreenState();
}

class _PremiacoesScreenState extends State<PremiacoesScreen> {
  String? tipoSelecionado; // 'oscar' ou 'globo'
  int? anoSelecionado;
  String? categoriaSelecionada;
  List<int> anosOscar = [];
  List<int> anosGlobo = [];
  List<dynamic> premiacoes = [];
  bool carregando = false;

  @override
  void initState() {
    super.initState();
    carregarAnos();
  }

  Future<void> carregarAnos() async {
    setState(() => carregando = true);
    try {
      final anos = await ApiService().buscarAnosPremiacoes();
      setState(() {
        anosOscar = List<int>.from(anos['oscar'] ?? []);
        anosGlobo = List<int>.from(anos['globo'] ?? []);
        carregando = false;
      });
    } catch (_) {
      setState(() => carregando = false);
    }
  }

  Future<void> carregarPremiacoes() async {
    if (tipoSelecionado == null || anoSelecionado == null) return;
    setState(() {
      carregando = true;
      categoriaSelecionada = null;
    });
    try {
      if (tipoSelecionado == 'oscar') {
        premiacoes = await ApiService().buscarOscarPorAno(anoSelecionado!);
      } else {
        premiacoes = await ApiService().buscarGloboPorAno(anoSelecionado!);
      }
      setState(() {
        carregando = false;
        categoriaSelecionada = null;
      });
    } catch (_) {
      setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.emoji_events, color: tipoSelecionado == 'oscar' ? Colors.amber[800] : Colors.deepPurple),
                    label: const Text('Oscar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tipoSelecionado == 'oscar' ? Colors.amber[100] : Colors.white,
                      foregroundColor: tipoSelecionado == 'oscar' ? Colors.amber[900] : Colors.deepPurple,
                      elevation: tipoSelecionado == 'oscar' ? 4 : 1,
                      side: BorderSide(color: Colors.amber[800]!, width: tipoSelecionado == 'oscar' ? 2 : 1),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      setState(() {
                        tipoSelecionado = 'oscar';
                        anoSelecionado = null;
                        premiacoes = [];
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.star, color: tipoSelecionado == 'globo' ? Colors.amber[800] : Colors.deepPurple),
                    label: const Text('Globo de Ouro', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tipoSelecionado == 'globo' ? Colors.amber[100] : Colors.white,
                      foregroundColor: tipoSelecionado == 'globo' ? Colors.amber[900] : Colors.deepPurple,
                      elevation: tipoSelecionado == 'globo' ? 4 : 1,
                      side: BorderSide(color: Colors.deepPurple, width: tipoSelecionado == 'globo' ? 2 : 1),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      setState(() {
                        tipoSelecionado = 'globo';
                        anoSelecionado = null;
                        premiacoes = [];
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (tipoSelecionado == null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_events, size: 64, color: Colors.deepPurple.shade200),
                      const SizedBox(height: 16),
                      const Text(
                        'Selecione uma premiação para explorar os vencedores e indicados!',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            if (tipoSelecionado != null)
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: DropdownButton<int>(
                    value: anoSelecionado,
                    hint: const Text('Selecione o ano'),
                    isExpanded: true,
                    underline: Container(),
                    items: (tipoSelecionado == 'oscar' ? anosOscar.reversed.toList() : anosGlobo.reversed.toList())
                        .map((ano) => DropdownMenuItem(
                              value: ano,
                              child: Text(ano.toString(), style: const TextStyle(fontWeight: FontWeight.w500)),
                            ))
                        .toList(),
                    onChanged: (ano) {
                      setState(() {
                        anoSelecionado = ano;
                        categoriaSelecionada = null;
                      });
                      carregarPremiacoes();
                    },
                  ),
                ),
              ),
            const SizedBox(height: 16),
            if (carregando)
              const Center(child: CircularProgressIndicator()),
            if (!carregando && premiacoes.isNotEmpty)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: DropdownButton<String>(
                          value: categoriaSelecionada,
                          hint: const Text('Selecione a categoria'),
                          isExpanded: true,
                          underline: Container(),
                          items: (() {
                            final categorias = premiacoes
                                .map((premio) => (tipoSelecionado == 'oscar'
                                    ? premio['canon_category'] ?? premio['category']
                                    : premio['award']))
                                .toSet()
                                .where((cat) => cat != null && cat != '')
                                .toList();
                            categorias.sort((a, b) => a.toString().compareTo(b.toString()));
                            return categorias
                                .map((cat) => DropdownMenuItem<String>(
                                      value: cat,
                                      child: Text(cat, style: const TextStyle(fontWeight: FontWeight.w500)),
                                    ))
                                .toList();
                          })(),
                          onChanged: (cat) {
                            setState(() {
                              categoriaSelecionada = cat;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (categoriaSelecionada != null)
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            final listaFiltrada = premiacoes
                                .where((premio) => (tipoSelecionado == 'oscar'
                                    ? (premio['canon_category'] ?? premio['category'])
                                    : premio['award']) == categoriaSelecionada)
                                .toList();
                            // Ordena: vencedor primeiro, depois ordem alfabética do nome
                            listaFiltrada.sort((a, b) {
                              final aVencedor = a['winner'] == true || a['winner'] == 'True';
                              final bVencedor = b['winner'] == true || b['winner'] == 'True';
                              if (aVencedor && !bVencedor) return -1;
                              if (!aVencedor && bVencedor) return 1;
                              final aNome = tipoSelecionado == 'oscar'
                                  ? (a['name'] ?? a['film'] ?? '')
                                  : (a['title'] ?? '');
                              final bNome = tipoSelecionado == 'oscar'
                                  ? (b['name'] ?? b['film'] ?? '')
                                  : (b['title'] ?? '');
                              return aNome.toString().compareTo(bNome.toString());
                            });
                            return ListView.builder(
                              itemCount: listaFiltrada.length,
                              itemBuilder: (context, index) {
                                final premio = listaFiltrada[index];
                                final isOscar = tipoSelecionado == 'oscar';
                                final categoria = isOscar
                                    ? (premio['canon_category'] ?? premio['category'] ?? 'Categoria')
                                    : (premio['award'] ?? 'Categoria');
                                final nome = isOscar
                                    ? (premio['name'] ?? premio['film'] ?? '')
                                    : (premio['title'] ?? '');
                                final filme = isOscar ? (premio['film'] ?? '') : '';
                                final vencedor = premio['winner'] == true || premio['winner'] == 'True';
                                return Card(
                                  elevation: 3,
                                  color: vencedor ? Colors.amber[100] : Colors.white,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          isOscar ? Icons.emoji_events : Icons.star,
                                          color: vencedor ? Colors.amber[800] : Colors.deepPurple,
                                          size: 32,
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                nome,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: vencedor ? Colors.amber[900] : Colors.black,
                                                ),
                                              ),
                                              if (filme.isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2, bottom: 2),
                                                  child: Text('Filme: $filme', style: const TextStyle(fontSize: 15)),
                                                ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 2, bottom: 2),
                                                child: Text(
                                                  'Categoria: $categoria',
                                                  style: const TextStyle(fontSize: 15, color: Colors.deepPurple),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 2),
                                                child: Text(
                                                  vencedor ? '🏆 Vencedor' : 'Indicado',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: vencedor ? Colors.amber[900] : Colors.grey[700],
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            if (!carregando && premiacoes.isEmpty && tipoSelecionado != null && anoSelecionado != null)
              const Center(child: Text('Nenhuma premiação encontrada para o ano selecionado.')),
          ],
        ),
      ),
    );
  }
}