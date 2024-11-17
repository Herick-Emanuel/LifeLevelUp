// controllers/missionController.js

const Mission = require('../models/mission');

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

            // Recompensa por completar a missão
            const user = await User.findByPk(req.user.userId);
            user.points += 50; // Exemplo: 50 pontos por missão
            await user.save();

            res.json({ message: 'Missão completada', mission });
        } else {
            res.status(404).json({ message: 'Missão não encontrada' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Erro ao completar missão', error });
    }
};
