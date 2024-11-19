const JournalEntry = require('../models/journalEntry');

exports.addEntry = async (req, res) => {
    try {
        const { content } = req.body;
        const entry = await JournalEntry.create({
            content,
            UserId: req.user.userId,
        });
        res.status(201).json(entry);
    } catch (error) {
        res.status(500).json({ message: 'Erro ao adicionar entrada', error });
    }
};

exports.getEntries = async (req, res) => {
    try {
        const entries = await JournalEntry.findAll({
            where: { UserId: req.user.userId },
        });
        res.json(entries);
    } catch (error) {
        res.status(500).json({ message: 'Erro ao obter entradas', error });
    }
};
