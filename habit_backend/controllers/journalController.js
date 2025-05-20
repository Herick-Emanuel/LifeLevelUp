const JournalEntry = require("../models/journalEntry");

exports.addEntry = async (req, res) => {
  try {
    const { content } = req.body;
    console.log("Adicionando entrada para o usuário:", req.user.userId);
    const entry = await JournalEntry.create({
      content,
      user_id: req.user.userId,
    });
    res.status(201).json(entry);
  } catch (error) {
    console.error("Erro ao adicionar entrada:", error);
    res
      .status(500)
      .json({ message: "Erro ao adicionar entrada", error: error.message });
  }
};

exports.getEntries = async (req, res) => {
  try {
    console.log("Buscando entradas para o usuário:", req.user.userId);
    const entries = await JournalEntry.findAll({
      where: { user_id: req.user.userId },
      order: [["createdAt", "DESC"]],
    });
    console.log("Entradas encontradas:", entries.length);
    res.json(entries);
  } catch (error) {
    console.error("Erro ao obter entradas:", error);
    res
      .status(500)
      .json({ message: "Erro ao obter entradas", error: error.message });
  }
};
