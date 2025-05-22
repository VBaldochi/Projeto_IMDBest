## 🎬 IMDBest - Sistema de Previsão de Premiações de Filmes

Este projeto integra um backend Node.js (Express + MongoDB), uma API de Machine Learning em Python (FastAPI) e um aplicativo Flutter para prever indicações e vitórias no Oscar e Globo de Ouro. O sistema permite consultar filmes, ver históricos de premiações e prever chances de premiação para filmes ainda não indicados ou premiados.

---

### ✅ Funcionalidades

- Cadastro e login de usuários (JWT)
- Listagem de filmes e detalhes (dados do TMDB/OMDB)
- Consulta e visualização de premiações históricas (Oscar e Globo de Ouro)
- Previsão de chances de indicação/vitória para filmes (ML API Python)
- Tela de premiações moderna e interativa no app Flutter
- Backend robusto com endpoints RESTful e autenticação

---

### 🚀 Instalação e Execução

#### Backend Node.js

```bash
cd Backend
npm install
# Configure o .env conforme exemplo abaixo
npm start
```

`.env` exemplo:
```
PORT=5000
MONGO_URI=mongodb://localhost:27017/filmes-db
JWT_SECRET=sua-chave-secreta
```

#### API de Machine Learning (Python)

Pré-requisitos: Python 3.8+, FastAPI, Uvicorn, scikit-learn, xgboost, pandas, joblib

```bash
cd Python
pip install -r requirements.txt  # ou instale os pacotes manualmente
uvicorn api_modelo:app --reload
```

Acesse a documentação da API Python em: http://127.0.0.1:8000/docs

#### App Flutter

```bash
cd Flutter/imdbest
flutter pub get
flutter run
```

---

### 📡 Principais Endpoints

#### Node.js

- `POST /api/auth/registrar` — Cadastro
- `POST /api/auth/login` — Login
- `GET /api/filmes` — Lista filmes
- `POST /api/filmes/classificar` — Previsão de premiação (chama FastAPI)
- `GET /api/premiacoes/anos` — Anos disponíveis
- `GET /api/premiacoes/oscar/:ano` — Premiações Oscar por ano
- `GET /api/premiacoes/globo/:ano` — Premiações Globo de Ouro por ano

#### FastAPI (Python)

- `POST /predict` — Previsão de chances para categorias
- `GET /top10?categoria=...` — Top 10 maiores chances por categoria

---

### 📱 App Flutter

- Login/cadastro com JWT
- Busca de filmes (TMDB/OMDB)
- Detalhes completos do filme
- Seleção de categorias e previsão de premiação
- Tela de premiações: escolha de premiação, ano, categoria, destaque para vencedores
- Visual moderno, responsivo e seguro (SafeArea em todas as telas)

---

### 📦 Estrutura do Projeto

```
raiz-do-projeto/
├── Backend/          # API Node.js (Express + MongoDB)
├── Python/           # API FastAPI + scripts ML
├── Flutter/imdbest/  # App Flutter
├── Data/             # Dados históricos (Oscar, Globo, IMDB)
├── README.md         # Este arquivo
```

---

### ℹ️ Observações

- O sistema utiliza dados públicos do IMDB, Oscar e Globo de Ouro.
- Projeto acadêmico para fins de aprendizado.
- Para dúvidas, consulte os READMEs de cada subpasta ou entre em contato com a equipe.

---

