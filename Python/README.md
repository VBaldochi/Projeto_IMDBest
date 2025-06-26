# 🤖 IMDBest - API Machine Learning (FastAPI) - Guia Dev

API Python para previsão de indicações/vitórias no Oscar e Globo de Ouro usando modelos ML treinados.

---

## ⚙️ Setup Rápido

Pré-requisitos: Python 3.8+, FastAPI, Uvicorn, scikit-learn, xgboost, pandas, joblib

```powershell
cd Python
pip install -r requirements.txt  # ou instale manualmente
uvicorn api_modelo:app --reload
```

- Modelos e preprocessadores em `Joblib/`
- Scripts de treinamento em `Scripts/`

---

## 🏗️ Estrutura

- `api_modelo.py` — Código principal da API
- `Joblib/` — Modelos ML (.joblib)
- `Scripts/` — Scripts de ETL/treinamento

---

## 🔑 Endpoints Principais

- `POST /predict` — Previsão de chances para categorias
- `GET /top10?categoria=...` — Top 10 maiores chances por categoria

### Exemplo de request
```json
POST /predict
{
  "title": "Oppenheimer",
  "year": 2025,
  "categorias": ["oscar_nominated", "oscar_winner"]
}
```

---

## 🛠️ Dicas para Devs

- Use `/docs` para testar endpoints (Swagger UI)
- Adapte features e modelos em `api_modelo.py` conforme necessidade
- MongoDB Atlas já configurado para consulta de features
- Para treinar novos modelos, use os scripts em `Scripts/`

---

## ℹ️ Observações

- Projeto acadêmico, código aberto para estudo e extensão.

---

## 📊 Pré-processamento dos Dados e Treinamento

### 1. Origem e Limpeza dos Dados
- Os dados foram coletados de fontes públicas (IMDB, Oscar, Globo de Ouro) e unificados em um único dataset.
- Foram removidos registros duplicados, filmes sem informações essenciais (título, ano, duração, etc) e outliers evidentes.
- Colunas categóricas (gênero, diretores, escritores, estrelas, idiomas, classificação indicativa) foram padronizadas e, quando necessário, transformadas em múltiplas features (ex: `genre1`, `genre2`).
- Textos longos (sinopse/descrição) foram limpos para remover caracteres especiais e padronizar encoding.

### 2. Feature Engineering
- Novas colunas foram criadas para representar informações relevantes, como:
  - Flags binárias para indicações e vitórias anteriores (Oscar/Globo)
  - Extração dos dois principais gêneros (`genre1`, `genre2`)
  - Quantidade de votos, nota IMDB, duração, ano, etc.
- Features textuais (descrição) foram tratadas com técnicas de vetorização simples (ou descartadas para modelos tabulares).

### 3. Pré-processamento para o Modelo
- Dados categóricos foram transformados via One-Hot Encoding ou Label Encoding, conforme o modelo.
- Dados numéricos foram normalizados/standardizados.
- Dados faltantes foram preenchidos com valores padrão ("unknown" para categorias, 0 para números).
- O pipeline de pré-processamento foi salvo via `joblib` para garantir reprodutibilidade na API.

### 4. Treinamento com XGBoost
- O modelo escolhido foi o **XGBoost** devido à sua robustez para dados tabulares, capacidade de lidar com dados faltantes, alta performance em competições e facilidade de ajuste de hiperparâmetros.
- Foram treinados modelos separados para cada categoria (indicação/vitória Oscar/Globo).
- O script de treinamento (`Scripts/treinamento_script.py`) realiza:
  - Split train/test
  - Treinamento do XGBoost
  - Avaliação (AUC, accuracy)
  - Salvamento do modelo e do pipeline de pré-processamento

### 5. Justificativa do XGBoost
- Lida bem com dados mistos (numéricos/categóricos)
- Resistente a overfitting com tuning adequado
- Explicabilidade (feature importance)
- Suporte nativo a dados faltantes
- Resultados superiores a regressão logística e árvores simples nos testes

---

## 🧑‍💻 Para rodar o treinamento

Edite e execute o script em `Scripts/treinamento_script.py` para gerar novos modelos e preprocessadores.

---
