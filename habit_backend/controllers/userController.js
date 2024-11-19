const User = require('../models/user');

exports.getUserProfile = async (req, res) => {
    try {
        const user = await User.findByPk(req.user.userId, {
            attributes: ['id', 'name', 'email', 'level', 'points'],
        });
        res.json(user);
    } catch (error) {
        res.status(500).json({ message: 'Erro ao obter perfil do usuário', error });
    }
};
