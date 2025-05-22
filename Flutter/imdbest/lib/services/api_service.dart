import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/filme.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String tmdbApiKey = 'd41a10c6861b1402691065387415ca43';
  final String omdbApiKey = 'f201fb92';

  // URL base da sua API Node.js
  final String baseUrl = 'http://10.0.2.2:5000'; // Corrigido: não inclui /api para rotas de auth
  String? _jwt;

  // Salvar token JWT
  void setJwt(String? token) {
    _jwt = token;
  }

   // Exemplo: Buscar filmes populares no TMDB
  Future<List<Filme>> buscarFilmesTmdb() async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?api_key=$tmdbApiKey&language=pt-BR&page=1',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Filme.fromTmdbJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar filmes no TMDB');
    }
  }

  // Exemplo: Buscar detalhes de um filme no OMDB
  Future<Filme> buscarFilmeOmdb(String imdbId) async {
    final url = Uri.parse(
      'https://www.omdbapi.com/?apikey=$omdbApiKey&i=$imdbId&plot=full',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Filme.fromOmdbJson(data);
    } else {
      throw Exception('Erro ao buscar filme no OMDB');
    }
  }

  Future<List<Filme>> buscarFilmesPorNome(String query) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/search/movie?api_key=$tmdbApiKey&language=pt-BR&query=$query&page=1',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Filme.fromTmdbJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar filmes por nome no TMDB');
    }
  }

  Future<String?> buscarImdbIdTmdb(int tmdbId) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/$tmdbId?api_key=$tmdbApiKey&language=pt-BR',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['imdb_id'];
    }
    return null;
  }


  // --- Funções que usam a API Node.js ---

  // Login
  Future<bool> login(String email, String senha) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setJwt(data['token']); // ESSENCIAL: salva o token para as próximas requisições
      return true;
    } else {
      return false;
    }
  }

  // Cadastro
  Future<bool> registrar(String nome, String email, String senha, String confirmarSenha) async {
    final url = Uri.parse('$baseUrl/auth/registrar');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': nome,
          'email': email,
          'senha': senha,
          'confirmarSenha': confirmarSenha
        }));
    if (response.statusCode != 200 && response.statusCode != 201) {
      print('Erro cadastro: ' + response.body);
    }
    return response.statusCode == 200 || response.statusCode == 201;
  }

  // Listar filmes
  Future<List<Filme>> listarFilmes() async {
    // Volta a buscar filmes do TMDB como antes
    return buscarFilmesTmdb();
  }

  // Listar premiações
  Future<List<dynamic>> listarPremiacoes() async {
    final url = Uri.parse('$baseUrl/filmes/premiacoes');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao buscar premiações');
    }
  }

  // Classificar filme (previsão de prêmios)
  Future<Map<String, dynamic>> classificarFilme(String titulo, String ano, List<String> categorias) async {
    final url = Uri.parse('$baseUrl/filmes/classificar');
    print('JWT enviado: $_jwt');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          if (_jwt != null) 'Authorization': 'Bearer $_jwt',
        },
        body: jsonEncode({'title': titulo, 'year': int.tryParse(ano) ?? 0, 'categorias': categorias}));
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao classificar filme');
    }
  }

  Future<bool> verificarPremiacao(String titulo, String ano) async {
    final url = Uri.parse('$baseUrl/filmes/verificar');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          if (_jwt != null) 'Authorization': 'Bearer $_jwt',
        },
        body: jsonEncode({'title': titulo, 'year': int.tryParse(ano) ?? 0}));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return !(data['indicado'] == true || data['premiado'] == true);
    } else {
      return true; // fallback: permite
    }
  }

  // Buscar anos disponíveis de premiações
  Future<Map<String, List<dynamic>>> buscarAnosPremiacoes() async {
    final url = Uri.parse('$baseUrl/premiacoes/anos');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Map<String, List<dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Erro ao buscar anos de premiações');
    }
  }

  // Buscar dados do Oscar por ano
  Future<List<dynamic>> buscarOscarPorAno(int ano) async {
    final url = Uri.parse('$baseUrl/premiacoes/oscar/$ano');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao buscar dados do Oscar');
    }
  }

  // Buscar dados do Globo de Ouro por ano
  Future<List<dynamic>> buscarGloboPorAno(int ano) async {
    final url = Uri.parse('$baseUrl/premiacoes/globo/$ano');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao buscar dados do Globo de Ouro');
    }
  }
}