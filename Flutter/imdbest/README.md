# 🎬 IMDBest - Flutter App (Guia Dev)

App Flutter para explorar filmes, consultar premiações históricas e prever chances de premiação via IA.

---

## ⚙️ Setup Rápido

Pré-requisitos: Flutter SDK 3.0+

```powershell
cd Flutter/imdbest
flutter pub get
flutter run
```

---

## 🏗️ Estrutura

- `lib/`
  - `models/` — Modelos de dados (Filme, etc)
  - `screens/` — Telas principais (login, filmes, detalhes, premiações)
  - `services/` — Integração com APIs (Node.js, FastAPI, TMDB/OMDB)
  - `viewmodels/` — Lógica de estado
  - `main.dart` — Entry point
- `assets/` — Imagens e ícones

---

## 🔑 Funcionalidades

- Login/cadastro (JWT)
- Busca de filmes (TMDB/OMDB)
- Detalhes completos do filme
- Previsão de premiação (seleção de categorias)
- Tela de premiações: escolha de premiação, ano, categoria, destaque para vencedores
- UI moderna, responsiva e segura (SafeArea em todas as telas)

---

## 🛠️ Dicas para Devs

- Configure a URL do backend em `api_service.dart` se necessário
- Use o modo debug para ver logs de API
- Adapte os modelos conforme a resposta das APIs
- Para testes, use o emulador Android/iOS ou `flutter run -d chrome` para web

---

## ℹ️ Observações

- O app consome dados do backend Node.js e da API Python FastAPI
- Projeto acadêmico, contribuições são bem-vindas!
