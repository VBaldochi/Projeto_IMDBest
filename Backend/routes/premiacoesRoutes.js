const express = require('express');
const router = express.Router();
// Corrige o caminho para o middleware
const proteger = require('../middleware/authMiddleware');
const { listarPremiacoes, criarPremiacao } = require('../controllers/premiacoesController');
const premiosHistoricos = require('../controllers/premiosHistoricosController');

// Premiações cadastradas pelo usuário
router.get('/', listarPremiacoes);
router.post('/', proteger, criarPremiacao); // Exige login

// Premiações históricas (Oscar e Globo de Ouro)
router.get('/anos', premiosHistoricos.anosDisponiveis);
router.get('/oscar/:ano', premiosHistoricos.oscarPorAno);
router.get('/globo/:ano', premiosHistoricos.globoPorAno);

module.exports = router;
