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
