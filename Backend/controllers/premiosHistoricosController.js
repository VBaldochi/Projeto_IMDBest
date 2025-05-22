const mongoose = require('mongoose');

// Controller para premiações históricas (Oscar e Globo de Ouro)
exports.anosDisponiveis = async (req, res) => {
  try {
    const Oscar = mongoose.connection.collection('Oscar');
    const GoldenGlobe = mongoose.connection.collection('Golden Globe');
    // Corrige para buscar os campos corretos de ano
    const anosOscar = await Oscar.distinct('year_ceremony');
    const anosGlobo = await GoldenGlobe.distinct('year');
    res.json({ oscar: anosOscar.sort(), globo: anosGlobo.sort() });
  } catch (err) {
    res.status(500).json({ erro: 'Erro ao buscar anos disponíveis' });
  }
};

exports.oscarPorAno = async (req, res) => {
  try {
    const ano = parseInt(req.params.ano);
    const Oscar = mongoose.connection.collection('Oscar');
    const dados = await Oscar.find({ year_ceremony: ano }).toArray();
    res.json(dados);
  } catch (err) {
    res.status(500).json({ erro: 'Erro ao buscar dados do Oscar' });
  }
};

exports.globoPorAno = async (req, res) => {
  try {
    const ano = parseInt(req.params.ano);
    const GoldenGlobe = mongoose.connection.collection('Golden Globe');
    const dados = await GoldenGlobe.find({ year: ano }).toArray();
    res.json(dados);
  } catch (err) {
    res.status(500).json({ erro: 'Erro ao buscar dados do Globo de Ouro' });
  }
};
