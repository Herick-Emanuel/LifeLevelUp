const Mission = require('../models/mission');
const User = require('../models/user');

exports.addMission = async (req, res) => {
    try {
        const { title, description, type } = req.body;
        if (!title || !type) {
            return res.status(400).json({ message: 'Título e tipo são obrigatórios' });
        }

        const mission = await Mission.create({
            title,
            description,
            type,
            isCompleted: false,
            UserId: req.user.userId,
        });

        res.status(201).json(mission);
    } catch (error) {
        res.status(500).json({ message: 'Erro ao adicionar missão', error });
    }
};


exports.getMissions = async (req, res) => {
    try {
        const missions = await Mission.findAll({
            where: { UserId: req.user.userId },
        });
        res.json(missions);
    } catch (error) {
        res.status(500).json({ message: 'Erro ao obter missões', error });
    }
};

exports.completeMission = async (req, res) => {
    try {
        const mission = await Mission.findByPk(req.params.id);
        if (mission && mission.UserId === req.user.userId) {
            mission.isCompleted = true;
            await mission.save();

            const user = await User.findByPk(req.user.userId);
            user.points += 50;
            await user.save();

            res.json({ message: 'Missão completada', mission });
        } else {
            res.status(404).json({ message: 'Missão não encontrada' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Erro ao completar missão', error });
    }
};
