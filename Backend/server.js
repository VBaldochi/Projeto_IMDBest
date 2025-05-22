require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const swaggerUi = require('swagger-ui-express');
const swaggerDocument = require('./docs/swagger.json');

const app = express();

app.use(cors());
app.use(express.json());

mongoose
  .connect(process.env.MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => {
    console.log('Conectado ao MongoDB com sucesso!');
  })
  .catch((err) => {
    console.error('Erro ao conectar ao MongoDB:', err);
  });

app.use('/filmes', require('./routes/filmes'));
app.use('/auth', require('./routes/authRoutes'));
app.use('/premiacoes', require('./routes/premiacoesRoutes'));

app.use('/docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

const PORT = process.env.PORT || 5000;
app.listen(PORT, () =>
  console.log(
    `Servidor rodando na porta ${PORT}\nDocumentação: http://localhost:${PORT}/docs`,
  ),
);
