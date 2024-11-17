// controllers/motivationController.js

const MotivationMessage = require('../models/motivationMessage');

exports.addMessage = async (req, res) => {
    try {
        const { message } = req.body;
        const newMessage = await MotivationMessage.create({
            message,
            UserId: req.user.userId,
        });
        res.status(201).json(newMessage);
    } catch (error) {
        res.status(500).json({ message: 'Erro ao adicionar mensagem', error });
    }
};

exports.getMessages = async (req, res) => {
    try {
        const messages = await MotivationMessage.findAll({
            where: { UserId: req.user.userId },
        });
        res.json(messages);
    } catch (error) {
        res.status(500).json({ message: 'Erro ao obter mensagens', error });
    }
};
