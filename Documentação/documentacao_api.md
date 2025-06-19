#  Documentação da API RESTful - IMDBest

## Tecnologias Utilizadas
- Node.js com Express
- MongoDB (via Mongoose)
- Autenticação com JWT
- API Python separada (FastAPI) para Machine Learning
- Hospedada em Nuvem Pública (Azure ou Railway)

---

## Autenticação

### POST `/api/auth/registrar`
Cria um novo usuário.
```json
{
  "nome": "Igor",
  "email": "igor@email.com",
  "senha": "123456"
}

Respostas:

201 Created – Usuário criado com sucesso

400 Bad Request – Dados inválidos ou já existentes

POST /api/auth/login
Autentica o usuário e retorna o token JWT.

Request body:

{
  "email": "igor@email.com",
  "senha": "123456"
}

Respostas:

200 OK – Token JWT retornado

401 Unauthorized – Credenciais inválidas

---

🎬 Filmes
GET /api/filmes
Retorna todos os filmes cadastrados no sistema.

Resposta:

[
  {
    "_id": "1",
    "titulo": "Duna",
    "ano": 2021,
    "genero": "Ficção Científica",
    "duracao": 155,
    "diretor": "Denis Villeneuve"
  }
]

POST /api/filmes
Adiciona um novo filme para análise de premiação.
🔒 Requer autenticação JWT

Request body:

{
  "titulo": "Oppenheimer",
  "ano": 2023,
  "genero": "Drama",
  "duracao": 180,
  "diretor": "Christopher Nolan"
}

Respostas:

201 Created – Filme adicionado

401 Unauthorized – Token ausente ou inválido

400 Bad Request – Dados faltando ou inválidos

---

🏆 Premiações
GET /api/premiacoes
Retorna a lista de premiações cadastradas no banco de dados.

Resposta:

[
  {
    "_id": "a1",
    "nome": "Oscar",
    "categoria": "Melhor Filme",
    "ano": 2024,
    "vencedor": true
  }
]

---

🤖 Integração com a API Python (Machine Learning)
Esta integração é feita via HTTP para a API FastAPI hospedada separadamente.

POST /predict
Recebe dados de um filme e retorna probabilidades de indicação e vitória.

Request body:

{
  "title": "Duna",
  "year": 2025,
  "categorias": ["oscar_nominated", "oscar_winner"]
}

Resposta:

{
  "oscar_nominated": 0.87,
  "oscar_winner": 0.52
}

GET /top10?categoria=oscar_nominated
Retorna os 10 filmes com maior probabilidade naquela categoria.

---

🔐 Segurança da API
A autenticação é feita via JWT. Após o login, o token deve ser enviado no cabeçalho das requisições protegidas:

Authorization: Bearer SEU_TOKEN

---

🧪 Testes e Documentação Interativa
Documentação interativa (Swagger UI) disponível em /api-docs

Testes podem ser realizados com Postman ou Insomnia

---

📎 Observações Finais
A API REST é independente da API de Machine Learning (Python).

O sistema está pronto para deploy em nuvem com suporte a HTTPS.

Todas as requisições e respostas seguem o padrão JSON.

---