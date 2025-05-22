import 'package:flutter/material.dart';
import '../models/filme.dart';
import '../services/api_service.dart';

class FilmesScreen extends StatefulWidget {
  const FilmesScreen({super.key});

  @override
  State<FilmesScreen> createState() => _FilmesScreenState();
}

class _FilmesScreenState extends State<FilmesScreen> {
  List<Filme> filmes = [];
  String busca = '';
  bool carregando = true;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final Map<String, String?> imdbRatings = {}; // imdbId -> rating

  @override
  void initState() {
    super.initState();
    buscarFilmes();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> buscarFilmes() async {
    final api = ApiService();
    final resultado = await api.buscarFilmesTmdb();

    // Aqui busca o imdbId de cada filme
    for (var filme in resultado) {
      if (filme.tmdbId != null) {
        final imdbId = await api.buscarImdbIdTmdb(filme.tmdbId!);
        filme.imdbId = imdbId;
      }
    }

    setState(() {
      filmes = resultado;
      carregando = false;
    });
    buscarNotasImdb(resultado);
  }

  void onBuscaChanged(String valor) async {
    setState(() {
      busca = valor;
      carregando = true;
    });
    if (valor.isEmpty) {
      await buscarFilmes();
    } else {
      final api = ApiService();
      final resultado = await api.buscarFilmesPorNome(valor);
      // Preencher imdbId para cada filme buscado
      for (var filme in resultado) {
        if (filme.tmdbId != null) {
          final imdbId = await api.buscarImdbIdTmdb(filme.tmdbId!);
          filme.imdbId = imdbId;
        }
      }
      setState(() {
        filmes = resultado;
        carregando = false;
      });
      buscarNotasImdb(resultado);
      _focusNode.requestFocus();
      return;
    }
    setState(() {
      carregando = false;
    });
    _focusNode.requestFocus();
  }

  Future<void> buscarNotasImdb(List<Filme> filmes) async {
    final api = ApiService();
    for (final filme in filmes) {
      if (filme.imdbId != null && !imdbRatings.containsKey(filme.imdbId)) {
        try {
          final detalhes = await api.buscarFilmeOmdb(filme.imdbId!);
          setState(() {
            imdbRatings[filme.imdbId!] = detalhes.notaImdb ?? 'N/A';
          });
        } catch (_) {
          setState(() {
            imdbRatings[filme.imdbId!] = 'N/A';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  labelText: 'Buscar filme...',
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            onBuscaChanged('');
                            FocusScope.of(context).unfocus();
                          },
                        )
                      : null,
                ),
                onChanged: onBuscaChanged,
              ),
            ),
            if (carregando)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            if (!carregando)
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: filmes.length,
                  itemBuilder: (context, index) {
                    final filme = filmes[index];
                    final nota = filme.imdbId != null
                        ? imdbRatings[filme.imdbId] ?? '...'
                        : 'N/A';
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/detalhes',
                          arguments: filme,
                        );
                      },
                      child: Card(
                        elevation: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: filme.posterUrl != null
                                  ? Image.network(
                                      filme.posterUrl!,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.movie, size: 48),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    filme.titulo,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Ano: ${filme.ano}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'IMDB: $nota',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold,
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
                ),
              ),
          ],
        ),
      ),
    );
  }
}