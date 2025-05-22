import 'package:flutter/material.dart';
import '../models/filme.dart';
import '../services/api_service.dart';

class DetalhesScreen extends StatefulWidget {
  @override
  State<DetalhesScreen> createState() => _DetalhesScreenState();
}

class _DetalhesScreenState extends State<DetalhesScreen> {
  Filme? detalhes;
  bool carregando = true;
  bool podeClassificar = false;

  // Adicione as opções de categoria
  final List<Map<String, String>> categoriasPremiacao = [
    {'key': 'oscar_nominated', 'label': 'Indicação ao Oscar'},
    {'key': 'oscar_winner', 'label': 'Vencedor do Oscar'},
    {'key': 'globe_nominated', 'label': 'Indicação ao Globo de Ouro'},
    {'key': 'globe_winner', 'label': 'Vencedor do Globo de Ouro'},
  ];
  final Set<String> categoriasSelecionadas = Set<String>();

  @override
  void initState() {
    super.initState();
    // Inicializa todas desmarcadas
    for (var cat in categoriasPremiacao) {
      categoriasSelecionadas.remove(cat['key']);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Filme filme = ModalRoute.of(context)!.settings.arguments as Filme;
    _carregarDetalhes(filme);
    _verificarPremiacao(filme); // <-- ESSENCIAL
  }

  Future<void> _carregarDetalhes(Filme filme) async {
    if (filme.imdbId != null) {
      final api = ApiService();
      final detalhesOmdb = await api.buscarFilmeOmdb(filme.imdbId!);
      // Preserve o originalTitle do TMDB e o titulo em português
      setState(() {
        detalhes = detalhesOmdb.copyWith(
          originalTitle: filme.originalTitle,
          titulo: filme.titulo, // mantém o título em português
        );
        carregando = false;
      });
    } else {
      setState(() {
        detalhes = filme;
        carregando = false;
      });
    }
  }

  Future<void> _verificarPremiacao(Filme filme) async {
    final api = ApiService();
    final permitido = await api.verificarPremiacao(filme.titulo, filme.ano);
    setState(() {
      podeClassificar = permitido;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Filme filme = detalhes ?? ModalRoute.of(context)!.settings.arguments as Filme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(filme.titulo),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: filme.posterUrl != null
                      ? Image.network(filme.posterUrl!, height: 350, fit: BoxFit.cover)
                      : Container(
                          height: 350,
                          color: Colors.grey[300],
                          child: const Icon(Icons.movie, size: 100),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                filme.titulo,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              if (filme.originalTitle != null && filme.originalTitle != '' && filme.originalTitle != filme.titulo)
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 8),
                  child: Text(
                    '(${filme.originalTitle})',
                    style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Chip(
                    label: Text('Ano: ${filme.ano}'),
                    backgroundColor: Colors.deepPurple.shade50,
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    avatar: const Icon(Icons.star, color: Colors.amber, size: 18),
                    label: Text('IMDB: ${filme.notaImdb ?? "N/A"}'),
                    backgroundColor: Colors.yellow.shade50,
                  ),
                  const SizedBox(width: 8),
                  if (filme.rottenTomatoes != null)
                    Chip(
                      avatar: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Image.asset(
                          'assets/images/rotten_tomatoes.png',
                          width: 18,
                          height: 18,
                          fit: BoxFit.contain,
                        ),
                      ),
                      label: Text('Rotten: ${filme.rottenTomatoes}'),
                      backgroundColor: Colors.green.shade50,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(thickness: 1.2),
              if (filme.genero != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.category, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      Expanded(child: Text('Gênero: ${filme.genero}', style: TextStyle(fontSize: 16))),
                    ],
                  ),
                ),
              if (filme.diretor != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      Expanded(child: Text('Diretor: ${filme.diretor}', style: TextStyle(fontSize: 16))),
                    ],
                  ),
                ),
              if (filme.elenco != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.people, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      Expanded(child: Text('Elenco: ${filme.elenco}', style: TextStyle(fontSize: 16))),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Divider(thickness: 1.2),
              if (filme.sinopse != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    filme.sinopse!,
                    style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.justify,
                  ),
                ),
              const SizedBox(height: 24),
              if (podeClassificar) ...[
                const Text('Selecione as categorias para verificar:', style: TextStyle(fontWeight: FontWeight.bold)),
                Column(
                  children: categoriasPremiacao.map((cat) => CheckboxListTile(
                    title: Text(cat['label']!),
                    value: categoriasSelecionadas.contains(cat['key']),
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          categoriasSelecionadas.add(cat['key']!);
                        } else {
                          categoriasSelecionadas.remove(cat['key']!);
                        }
                      });
                    },
                  )).toList(),
                ),
                ElevatedButton(
                  onPressed: categoriasSelecionadas.isEmpty ? null : () async {
                    final api = ApiService();
                    final resultado = await api.classificarFilme(
                      filme.originalTitle ?? filme.titulo,
                      filme.ano,
                      categoriasSelecionadas.toList(),
                    );
                    print('Resultado classificação:');
                    print(resultado);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Chances de Premiação'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: resultado.entries.map((e) {
                            final label = categoriasPremiacao.firstWhere((cat) => cat['key'] == e.key)['label'];
                            final value = e.value;
                            if (value == null) {
                              return Text('$label: Não elegível');
                            }
                            final percent = value * 100;
                            if (percent < 0.01 && percent > 0) {
                              return Text('$label: < 0.01%');
                            }
                            return Text('$label: ${percent.toStringAsFixed(2)}%');
                          }).toList(),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Verificar chances de premiação'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}