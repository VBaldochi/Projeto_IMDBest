# Imagem base com Python 3.11
FROM python:3.11-slim

# Diretório de trabalho
WORKDIR /app

# Copiar todos os arquivos do projeto
COPY . /app

# Instalar dependências de sistema
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Instalar bibliotecas Python (incluindo xgboost)
RUN pip install --no-cache-dir \
    fastapi \
    uvicorn \
    pandas \
    numpy \
    pymongo \
    joblib \
    scikit-learn==1.6.1 \
    xgboost

# Expor a porta da API
EXPOSE 8000

# Rodar a aplicação
CMD ["uvicorn", "api_modelo:app", "--host", "0.0.0.0", "--port", "8000"]
