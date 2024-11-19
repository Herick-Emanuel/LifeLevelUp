const User = require('../models/user');

exports.getGlobalRanking = async (req, res) => {
    try {
        const users = await User.findAll({
            attributes: ['id', 'name', 'level', 'points'],
            order: [['points', 'DESC']],
            limit: 100,
        });
        res.json(users);
    } catch (error) {
        res.status(500).json({ message: 'Erro ao obter ranking', error });
    }
};
