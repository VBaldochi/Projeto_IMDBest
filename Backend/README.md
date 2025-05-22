# 🎬 IMDBest - Backend Node.js (Dev Guide)

API RESTful para gerenciamento de filmes, usuários, premiações e integração com a API de Machine Learning (FastAPI).

---

## ⚙️ Setup Rápido

Pré-requisitos: Node.js 18+, MongoDB local ou Atlas

```powershell
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

---

## 🏗️ Estrutura de Pastas

- `controllers/` — Lógica de negócio (Express)
- `models/` — Schemas do MongoDB (Mongoose)
- `routes/` — Rotas da API
- `middleware/` e `middlewares/` — Middlewares de autenticação e validação
- `validators/` — Validação de dados
- `docs/` — Documentação (Swagger)

---

## 🔑 Principais Endpoints

- `POST /api/auth/registrar` — Cadastro
- `POST /api/auth/login` — Login
- `GET /api/filmes` — Lista filmes
- `POST /api/filmes/classificar` — Previsão de premiação (chama FastAPI)
- `GET /api/premiacoes/anos` — Anos disponíveis
- `GET /api/premiacoes/oscar/:ano` — Premiações Oscar por ano
- `GET /api/premiacoes/globo/:ano` — Premiações Globo de Ouro por ano

---

## 🔄 Integração com FastAPI

- O endpoint `/api/filmes/classificar` faz requisição HTTP para a API Python (`/predict`).
- Configure a URL da FastAPI em uma variável de ambiente se necessário.

---

## 🧪 Testes

- Testes básicos em `test_api.js` e `test_auth.js` (use `node test_api.js`)
- Use ferramentas como Postman para testar endpoints.

---

## 🛠️ Dicas para Devs

- Use o Swagger (`docs/swagger.json`) para explorar a API.
- Adapte os middlewares conforme regras de negócio.
- MongoDB Atlas pode ser usado para deploy cloud.
- O backend não serve arquivos estáticos do Flutter.

---

## ℹ️ Observações

- Projeto acadêmico para fins de aprendizado.
- Contribuições e melhorias são bem-vindas!
