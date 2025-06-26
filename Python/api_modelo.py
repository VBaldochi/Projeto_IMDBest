import pandas as pd
import numpy as np
from fastapi import FastAPI, HTTPException, Query
from pydantic import BaseModel
from pymongo import MongoClient
import joblib
import os

# ==== CONEXÃO COM MONGODB ATLAS ====
MONGO_URL = "mongodb+srv://admin:adminpi@pi.r3vqecf.mongodb.net/?retryWrites=true&w=majority&appName=PI"
client = MongoClient(MONGO_URL)
db = client["IMDBest"]
colecao_filmes = db["Generos"]

# ==== CARREGAR MODELOS ====
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
JOBLIB_DIR = os.path.join(BASE_DIR, "Joblib")
MODELOS = {
    "oscar_nominated": (
        joblib.load(os.path.join(JOBLIB_DIR, "best_oscar_nominated_xgboost.joblib")),
        joblib.load(os.path.join(JOBLIB_DIR, "preprocessor_oscar_nominated.joblib")),
        ['Year', 'Duration', 'Rating', 'Votes', 'MPA', 'Languages', 'directors', 'writers', 'stars', 'genre1', 'genre2', 'globe_nominated', 'globe_winner', 'description']
    ),
    "oscar_winner": (
        joblib.load(os.path.join(JOBLIB_DIR, "best_oscar_winner_xgboost.joblib")),
        joblib.load(os.path.join(JOBLIB_DIR, "preprocessor_oscar_winner.joblib")),
        ['Year', 'Duration', 'Rating', 'Votes', 'MPA', 'Languages', 'directors', 'writers', 'stars', 'genre1', 'genre2', 'oscar_nominated', 'globe_nominated', 'globe_winner', 'description']
    ),
    "globe_nominated": (
        joblib.load(os.path.join(JOBLIB_DIR, "best_globe_nominated_xgboost.joblib")),
        joblib.load(os.path.join(JOBLIB_DIR, "preprocessor_globe_nominated.joblib")),
        ['Year', 'Duration', 'Rating', 'Votes', 'MPA', 'Languages', 'directors', 'writers', 'stars', 'genre1', 'genre2', 'oscar_nominated', 'globe_winner', 'description']
    ),
    "globe_winner": (
        joblib.load(os.path.join(JOBLIB_DIR, "best_globe_winner_xgboost.joblib")),
        joblib.load(os.path.join(JOBLIB_DIR, "preprocessor_globe_winner.joblib")),
        ['Year', 'Duration', 'Rating', 'Votes', 'MPA', 'Languages', 'directors', 'writers', 'stars', 'genre1', 'genre2', 'oscar_nominated', 'globe_nominated', 'description']
    ),
}

# ==== FASTAPI APP ====
app = FastAPI()

class ConsultaRequest(BaseModel):
    title: str
    year: int
    categorias: list

def preparar_features(filme, features):
    row = filme.copy()
    if 'genres_first2' in row and (('genre1' not in row) or ('genre2' not in row)):
        genres = row['genres_first2'].split(',')
        row['genre1'] = genres[0].strip() if len(genres) > 0 else 'unknown'
        row['genre2'] = genres[1].strip() if len(genres) > 1 else 'unknown'
    for col in features:
        if col not in row or pd.isna(row[col]):
            row[col] = 'unknown' if col not in ['Year', 'Duration', 'Rating', 'Votes'] else 0
    return pd.DataFrame([row])[features]

def tem_premiacao(valor):
    return valor is True

@app.post("/predict")
def predict(request: ConsultaRequest):
    # Normaliza o título removendo espaços extras
    # Busca por Title OU original_title (case-insensitive)
    titulo_normalizado = request.title.strip()
    filme = colecao_filmes.find_one({
        "$or": [
            {"Title": {"$regex": f"^{titulo_normalizado}$", "$options": "i"}},
            {"original_title": {"$regex": f"^{titulo_normalizado}$", "$options": "i"}}
        ],
        "Year": int(request.year)
    })

    if not filme:
        raise HTTPException(status_code=404, detail="Filme não encontrado")

    if tem_premiacao(filme.get('oscar_nominated')) or tem_premiacao(filme.get('oscar_winner')):
        raise HTTPException(status_code=400, detail="Filme já possui indicação ou premiação")

    result = {}
    for cat in request.categorias:
        if cat not in MODELOS:
            result[cat] = None
            continue
        model, preproc, features = MODELOS[cat]
        X = preparar_features(filme, features)
        prob = float(model.predict_proba(preproc.transform(X))[:, 1])
        result[cat] = prob
    return result

@app.get("/top10")
def top10(categoria: str = Query(..., enum=list(MODELOS.keys()))):
    model, preproc, features = MODELOS[categoria]

    # Filtro dinâmico conforme a categoria
    filtro = {
        "oscar_nominated": {"$in": [None, "", "nan", False]},
        "oscar_winner": {"$in": [None, "", "nan", False]},
        "globe_nominated": {"$in": [None, "", "nan", False]},
        "globe_winner": {"$in": [None, "", "nan", False]}
    }
    # Garante que NENHUM dos status de premiação esteja True
    filtro_exclusao = {
        "$and": [
            {"oscar_nominated": {"$in": [None, "", "nan", False]}},
            {"oscar_winner": {"$in": [None, "", "nan", False]}},
            {"globe_nominated": {"$in": [None, "", "nan", False]}},
            {"globe_winner": {"$in": [None, "", "nan", False]}}
        ]
    }
    cursor = colecao_filmes.find(filtro_exclusao)
    filmes = list(cursor)

    if not filmes:
        raise HTTPException(status_code=404, detail="Nenhum filme encontrado")

    df_filmes = pd.DataFrame(filmes)

    split_genres = df_filmes['genres_first2'].str.split(',', n=1, expand=True)
    df_filmes['genre1'] = split_genres[0].str.strip().fillna('unknown')
    df_filmes['genre2'] = split_genres[1].str.strip().fillna('unknown') if split_genres.shape[1] > 1 else 'unknown'

    # Converter listas para string em todas as colunas exceto as numéricas
    for col in features:
        if col not in df_filmes.columns:
            df_filmes[col] = 'unknown'
        # Preencher nulos
        df_filmes[col] = df_filmes[col].fillna('unknown' if col not in ['Year', 'Duration', 'Rating', 'Votes'] else 0)
        # Converter listas para string
        if col not in ['Year', 'Duration', 'Rating', 'Votes']:
            df_filmes[col] = df_filmes[col].apply(lambda x: ', '.join(x) if isinstance(x, list) else x)

    X = df_filmes[features]
    probs = model.predict_proba(preproc.transform(X))[:, 1]
    df_filmes['prob'] = probs
    top = df_filmes.sort_values('prob', ascending=False).head(10)
    return top[['Title', 'Year', 'prob']].to_dict(orient='records')

