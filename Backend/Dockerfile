# Imagem base
FROM node:20

# Diretório de trabalho
WORKDIR /app

# Copia os arquivos do projeto
COPY . /app

# Instala as dependências
RUN npm install

# Expõe a porta do backend
EXPOSE 5000

# Inicia o servidor
CMD ["npm", "start"]
