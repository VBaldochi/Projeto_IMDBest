# 📊 Análise de Requisitos - Projeto IMDBest

Este documento apresenta os requisitos funcionais, não funcionais e regras de negócio da aplicação IMDBest, que reúne uma API RESTful e um aplicativo mobile Flutter voltado para a previsão de premiações de filmes, como Oscar e Globo de Ouro.

---

## ✅ Requisitos Funcionais

- O sistema deve permitir o **cadastro e login de usuários** com autenticação via **JWT**.
- O sistema deve **listar todos os filmes** disponíveis na base de dados.
- Usuários autenticados podem **cadastrar novos filmes** para análise.
- O sistema deve **listar todas as premiações** cadastradas.
- A API de Machine Learning deve **retornar a probabilidade** de um filme ser indicado ou vencer no **Oscar** e no **Globo de Ouro**.
- O app mobile deve **exibir a listagem de filmes e premiações** de forma responsiva.
- O app mobile deve permitir a **consulta da previsão de premiação** para filmes ainda **não premiados**.
- O app deve indicar se o filme já foi premiado e, caso não, oferecer o botão de previsão.

---

## 🚀 Requisitos Não Funcionais

- A API Node.js deve estar **hospedada em nuvem pública** (ex: Azure, Render, Railway).
- O sistema deve utilizar **autenticação segura** baseada em **JWT**.
- A previsão de premiações deve ser realizada por uma **API separada em Python (FastAPI)** com algoritmos de Machine Learning.
- A interface mobile deve ser **intuitiva, responsiva e compatível com Android e iOS**.
- A comunicação entre o app mobile e as APIs deve ser realizada via **requisições HTTP seguras** (HTTPS).
- A documentação da API REST deve seguir o **padrão OpenAPI 3.0 (Swagger)**.
- O backend deve seguir boas práticas de organização com **separação de rotas, controladores e middlewares**.

---

## 📌 Regras de Negócio

- Apenas **usuários autenticados** podem cadastrar novos filmes.
- **Não é permitido** solicitar a previsão de premiação para **filmes já premiados**.
- Cada filme deve conter **informações obrigatórias**: título, ano, duração, gênero e diretor.
- A previsão é baseada em **dados históricos e aprendizado supervisionado** (modelo XGBoost treinado com dados do IMDB, Oscar e Globo de Ouro).
- As premiações são armazenadas no banco de dados MongoDB e devem ser consistentes com as categorias aceitas.
- A precisão dos modelos deve ser validada em ambiente de testes antes da disponibilização no app.

---